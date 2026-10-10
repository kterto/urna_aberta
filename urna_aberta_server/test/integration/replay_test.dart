import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/replay/fixture_seeder.dart';
import 'package:urna_aberta_server/src/replay/replay_service.dart';

import 'test_tools/serverpod_test_tools.dart';

final _fixtures = Directory('../fixtures/2026-1t');

/// Brasília time (UTC-3) on election night, as UTC.
DateTime brt(int day, int hour, int minute) =>
    DateTime.utc(2026, 10, day, hour + 3, minute);

void main() {
  withServerpod('FixtureSeeder', (sessionBuilder, _) {
    late final session = sessionBuilder.build();

    test('loads every archived EA20 file once, with its fetch time', () async {
      expect(await FixtureSeeder.seed(session, _fixtures), 29 + 2 * 27);
      expect(await FixtureSeeder.seed(session, _fixtures), 0);
      expect(await ResultSnapshot.db.count(session), 83);

      final br = await ResultSnapshot.db.findFirstRow(
        session,
        where: (t) => t.scopeCode.equals('br'),
      );
      expect(br!.origin, DataOrigin.replay);
      expect(br.officeCode, 1);
      expect(br.fetchedAt.isAfter(DateTime.utc(2026, 10, 5)), isTrue);
    });

    test('checks each archived file against its archived .jws', () async {
      await FixtureSeeder.seed(session, _fixtures);
      final rows = await ResultSnapshot.db.find(session);
      expect(rows.map((r) => r.signature).toSet(), {SignatureStatus.valid});
      expect(rows.every((r) => r.jws != null), isTrue);
    });
  });

  withServerpod('tally endpoint', (sessionBuilder, endpoints) {
    late final session = sessionBuilder.build();
    final tally = endpoints.tally;

    setUp(ReplayService.resetCache);

    test('without archived files there is nothing to replay', () async {
      await expectLater(
        tally.night(sessionBuilder),
        throwsA(isA<ReplayUnavailableException>()),
      );
    });

    group('with the 1st-round fixtures', () {
      setUp(() => FixtureSeeder.seed(session, _fixtures));

      test('night: synthetic clock ending at the final files', () async {
        final night = await tally.night(sessionBuilder);
        expect(night.origin, DataOrigin.synthetic);
        expect(night.electionCode, 6257);
        expect(night.start, brt(4, 17, 0));
        expect(night.freezeStart, brt(4, 21, 2));
        expect(night.freezeEnd, brt(4, 21, 57));
        expect(night.finalsGeneratedAt.isAfter(night.end), isTrue);
      });

      test('mid-freeze frame: national stuck, states moving', () async {
        final f = await tally.frame(sessionBuilder, brt(4, 21, 30));
        expect(f.origin, DataOrigin.synthetic);
        expect(f.nationalPct, closeTo(64.81, 0.005));
        expect(f.statesPct - f.nationalPct, greaterThan(5));
        expect(f.ufs, hasLength(28));
        expect(f.missingScopes, isEmpty);
        expect(f.candidates, hasLength(12));
      });

      test(
        'from the final files on, frames are the real stored files',
        () async {
          final night = await tally.night(sessionBuilder);
          final f = await tally.frame(sessionBuilder, night.finalsGeneratedAt);
          expect(f.origin, DataOrigin.replay);
          expect(f.nationalPct, 100);
          expect(f.statesPct, f.nationalPct);
          for (final c in f.candidates) {
            expect(c.states, c.national, reason: '${c.candidateNumber}');
          }
          expect(
            f.candidates.singleWhere((c) => c.candidateNumber == 22).national,
            greaterThan(0),
          );
        },
      );

      test('timeline samples the night at the requested step', () async {
        final night = await tally.night(sessionBuilder);
        final points = await tally.timeline(
          sessionBuilder,
          night.start,
          night.end,
          60,
        );
        expect(points, hasLength(8 * 60 + 1));
        final frozen = points.where(
          (p) =>
              !p.at.isBefore(night.freezeStart) &&
              p.at.isBefore(night.freezeEnd),
        );
        expect(frozen.map((p) => p.nationalPct).toSet(), hasLength(1));
      });

      test('timeline refuses requests over 2000 points', () async {
        final night = await tally.night(sessionBuilder);
        await expectLater(
          tally.timeline(sessionBuilder, night.start, night.end, 1),
          throwsArgumentError,
        );
      });

      test('divergence: open during the freeze, closed after', () async {
        final during = await tally.divergence(sessionBuilder, brt(4, 21, 30));
        expect(during.single.endedAt, isNull);
        expect(during.single.origin, DataOrigin.synthetic);

        final after = await tally.divergence(sessionBuilder, brt(5, 2, 0));
        expect(after.single.endedAt, brt(4, 21, 57));
        expect(after.single.maxGap, greaterThan(10));
      });
    });
  });
}

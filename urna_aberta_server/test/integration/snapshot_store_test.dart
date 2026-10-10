import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/ingestion/snapshot_store.dart';
import 'package:urna_aberta_server/src/tally/aggregator.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

import 'test_tools/serverpod_test_tools.dart';

const _dados = '../fixtures/2026-1t/oficial/ele2026/6257/dados';

List<int> presidentFile(String scope) =>
    File('$_dados/$scope/$scope-c0001-e006257-u.json').readAsBytesSync();

/// The Acre file with its counts and generation time rewritten, standing in
/// for an earlier version of the same file.
List<int> earlierAcre() {
  final json = jsonDecode(utf8.decode(presidentFile('ac'))) as Map;
  (json['s'] as Map)['st'] = '1000';
  json['hg'] = '20:00:00';
  json['dg'] = '04/10/2026';
  return utf8.encode(jsonEncode(json));
}

void main() {
  final fetchedAt = DateTime.utc(2026, 10, 10, 12);

  withServerpod('SnapshotStore', (sessionBuilder, _) {
    late final session = sessionBuilder.build();

    Future<({ResultSnapshot snapshot, bool isNew})> record(
      List<int> bytes, {
      DataOrigin origin = DataOrigin.replay,
      Office office = Office.presidente,
      int election = 6257,
    }) => SnapshotStore.record(
      session,
      origin: origin,
      electionCode: election,
      office: office,
      bytes: bytes,
      fetchedAt: fetchedAt,
    );

    test('stores counts, votes, hash and TSE time from the file', () async {
      final r = await record(presidentFile('ac'));
      expect(r.isNew, isTrue);
      final s = (await ResultSnapshot.db.findById(
        session,
        r.snapshot.id!,
        include: ResultSnapshot.include(tallies: CandidateTally.includeList()),
      ))!;
      expect(s.scopeCode, 'ac');
      expect(s.officeCode, 1);
      expect(s.sectionsTotalized, 2270);
      expect(s.tseGeneratedAt, DateTime.utc(2026, 10, 5, 15, 51, 40));
      expect(s.rawSha256, hasLength(64));
      expect(s.signatureValid, isNull);
      expect(s.tallies, hasLength(12));
      expect(
        s.tallies!.singleWhere((t) => t.candidateNumber == 22).votes,
        302807,
      );
    });

    test('recording the same file again adds nothing', () async {
      final first = await record(presidentFile('ac'));
      final again = await record(presidentFile('ac'));
      expect(again.isNew, isFalse);
      expect(again.snapshot.id, first.snapshot.id);
      expect(await ResultSnapshot.db.count(session), 1);
      expect(await CandidateTally.db.count(session), 12);
    });

    test('the same bytes from another origin are a separate row', () async {
      await record(presidentFile('ac'));
      final live = await record(presidentFile('ac'), origin: DataOrigin.live);
      expect(live.isNew, isTrue);
      expect(await ResultSnapshot.db.count(session), 2);
    });

    test('a file whose election or office differs is refused', () async {
      await expectLater(
        record(presidentFile('ac'), election: 6259),
        throwsFormatException,
      );
      await expectLater(
        record(presidentFile('ac'), office: Office.governador),
        throwsFormatException,
      );
      expect(await ResultSnapshot.db.count(session), 0);
    });

    test(
      'latestAt picks, per scope, the newest version at that time',
      () async {
        await record(earlierAcre());
        await record(presidentFile('ac'));
        await record(presidentFile('rr'));

        Future<List<ScopeResult>> at(DateTime t) => SnapshotStore.latestAt(
          session,
          origin: DataOrigin.replay,
          electionCode: 6257,
          office: Office.presidente,
          at: t,
        );

        final night = await at(DateTime.utc(2026, 10, 4, 23, 30));
        expect(night.map((r) => r.scope), ['ac']);
        expect(night.single.sectionsTotalized, 1000);

        final next = await at(DateTime.utc(2026, 10, 6));
        expect(next.map((r) => r.scope).toSet(), {'ac', 'rr'});
        expect(
          next.singleWhere((r) => r.scope == 'ac').sectionsTotalized,
          2270,
        );
      },
    );

    test('replayed final files: sum of stored UFs equals stored BR', () async {
      for (final scope in ['br', ...Scope.ufs]) {
        await record(presidentFile(scope));
      }
      final latest = await SnapshotStore.latestAt(
        session,
        origin: DataOrigin.replay,
        electionCode: 6257,
        office: Office.presidente,
        at: DateTime.utc(2026, 10, 6),
      );
      final br = latest.singleWhere((r) => r.scope == 'br');
      final sum = sumOfStates(latest.where((r) => r.scope != 'br').toList());
      expect(sum.complete, isTrue);
      expect(sum.sectionsTotalizedPct, br.sectionsTotalizedPct);
      expect(sum.votes, br.votes);
    });
  });
}

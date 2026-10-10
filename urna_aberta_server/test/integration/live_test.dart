import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/ingestion/snapshot_store.dart';
import 'package:urna_aberta_server/src/live/elections.dart';
import 'package:urna_aberta_server/src/live/live_ingestor.dart';
import 'package:urna_aberta_server/src/live/live_service.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

import 'test_tools/serverpod_test_tools.dart';

const _fixtures = '../fixtures/2026-1t';

/// Archived TSE files served by URL path, with ETags and 304s like the CDN;
/// anything not archived is a 404.
class LiveFakeTse implements TseHttp {
  final requested = <String>[];
  final overrides = <String, List<int>>{};

  @override
  Future<TseHttpResponse> get(Uri uri, Map<String, String> headers) async {
    requested.add(uri.path);
    final f = File('$_fixtures${uri.path}');
    final body =
        overrides[uri.path] ?? (f.existsSync() ? f.readAsBytesSync() : null);
    if (body == null) return TseHttpResponse(404, const [], const {});
    final etag = '"${sha256.convert(body)}"';
    if (headers['if-none-match'] == etag) {
      return TseHttpResponse(304, const [], {'etag': etag});
    }
    return TseHttpResponse(200, body, {'etag': etag});
  }
}

class _NoWait extends TokenBucket {
  _NoWait() : super(ratePerSecond: 20, burst: 1);

  @override
  Future<void> acquire() async {}
}

/// The 1st-round elections from the archived EA11.
final _firstRound = parseElections(
  File('$_fixtures/oficial/comum/config/ele-c.json').readAsBytesSync(),
).where((e) => e.pleito == 3220).toList();

DateTime brt(int day, int hour, [int minute = 0]) =>
    DateTime.utc(2026, 10, day, hour + 3, minute);

/// [bytes] wrapped in the Acre President file's real header and signature,
/// which do not sign them.
String forgedAcre(List<int> bytes) {
  final parts = File(
    '$_fixtures/oficial/ele2026/6257/dados/ac/ac-c0001-e006257-u.jws',
  ).readAsStringSync().trim().split('.');
  return '${parts[0]}.${base64Url.encode(bytes).replaceAll('=', '')}.${parts[2]}';
}

void main() {
  late LiveFakeTse tse;
  late DateTime now;
  late LiveIngestor live;

  setUp(() {
    tse = LiveFakeTse();
    now = brt(4, 20);
    live = LiveIngestor(
      client: TseClient(http: tse, bucket: _NoWait(), now: () => now),
      urls: TseUrls.oficial(),
      now: () => now,
    )..elections = _firstRound;
  });

  withServerpod('LiveIngestor', (sessionBuilder, _) {
    late final session = sessionBuilder.build();

    test('nothing is requested outside the live window', () async {
      now = brt(4, 16, 59);
      final r = await live.tick(session);
      expect(tse.requested, isEmpty);
      expect(r.recorded, 0);
      expect(live.nextDelay(), const Duration(minutes: 1));
    });

    test('election night: every result file, signed, stored as live', () async {
      final r = await live.tick(session);
      expect(r.recorded, 83);
      expect(tse.requested, hasLength(83));
      expect(tse.requested.every((p) => p.endsWith('-u.jws')), isTrue);
      final rows = await ResultSnapshot.db.find(session);
      expect(rows.map((s) => s.origin).toSet(), {DataOrigin.live});
      expect(rows.map((s) => s.signature).toSet(), {SignatureStatus.valid});
      expect(live.nextDelay(), LiveIngestor.pollEvery);
    });

    test('an unchanged file is a 304 and stores nothing', () async {
      await live.tick(session);
      tse.requested.clear();
      final r = await live.tick(session);
      expect(tse.requested, hasLength(83));
      expect(r.recorded, 0);
      expect(r.unchanged, 83);
    });

    test(
      'a new version of one file is stored; a forged one never counts',
      () async {
        await live.tick(session);
        final acre = '/oficial/ele2026/6257/dados/ac/ac-c0001-e006257-u.jws';
        final json =
            jsonDecode(
                  utf8.decode(
                    File(
                      '$_fixtures/oficial/ele2026/6257/dados/ac/ac-c0001-e006257-u.json',
                    ).readAsBytesSync(),
                  ),
                )
                as Map;
        json['dg'] = '06/10/2026';
        tse.overrides[acre] = utf8.encode(
          forgedAcre(utf8.encode(jsonEncode(json))),
        );
        final r = await live.tick(session);
        expect(r.recorded, 1);
        final ac = await ResultSnapshot.db.find(
          session,
          where: (t) => t.scopeCode.equals('ac') & t.officeCode.equals(1),
        );
        expect(ac.map((s) => s.signature).toSet(), {
          SignatureStatus.valid,
          SignatureStatus.invalid,
        });
      },
    );

    test(
      'before TSE publishes, one probe per election, then a pause',
      () async {
        live.elections = [
          Election(
            code: 6258,
            pleito: 3221,
            round: 2,
            name: '2º turno',
            day: (2026, 10, 4),
            targets: [
              (Scope.brazil(), Office.presidente),
              (Scope.uf('ac'), Office.presidente),
            ],
          ),
        ];
        final r = await live.tick(session);
        expect(tse.requested, [
          '/oficial/ele2026/6258/dados/br/br-c0001-e006258-u.jws',
        ]);
        expect(r.waiting, [6258]);
        now = now.add(const Duration(minutes: 4));
        await live.tick(session);
        expect(tse.requested, hasLength(1));
        now = now.add(const Duration(minutes: 2));
        await live.tick(session);
        expect(tse.requested, hasLength(2));
      },
    );

    test('a recurring run that is not due asks TSE nothing', () async {
      now = brt(10, 9);
      await live.pollIfDue(session); // reads EA11, then waits 6 h
      expect(tse.requested, ['/oficial/comum/config/ele-c.json']);
      now = now.add(const Duration(hours: 5));
      await live.pollIfDue(session);
      expect(tse.requested, hasLength(1));
      now = now.add(const Duration(hours: 1));
      await live.pollIfDue(session);
      expect(tse.requested, hasLength(2));
    });

    test('next opening when no window is open', () {
      live.elections = parseElections(
        File('$_fixtures/oficial/comum/config/ele-c.json').readAsBytesSync(),
      );
      now = brt(10, 9);
      expect(live.nextDelay(), LiveIngestor.idleCheck);
      now = brt(25, 16, 50);
      expect(live.nextDelay(), const Duration(minutes: 10));
    });
  });
  withServerpod('LiveService', (sessionBuilder, endpoints) {
    late final session = sessionBuilder.build();
    final all = parseElections(
      File('$_fixtures/oficial/comum/config/ele-c.json').readAsBytesSync(),
    );

    test(
      'weeks before: the next presidential count, nothing to show',
      () async {
        LiveService.elections = () => all;
        final s = await LiveService.status(session, now: brt(10, 9));
        expect(s.electionCode, 6258);
        expect(s.round, 2);
        expect(s.open, isFalse);
        expect(s.opensAt, DateTime.utc(2026, 10, 25, 20));
        expect(s.frame, isNull);
        expect(s.timeline, isEmpty);
      },
    );

    test('window open, no file yet: open, no frame', () async {
      LiveService.elections = () => _firstRound;
      final s = await LiveService.status(session, now: brt(4, 17, 1));
      expect(s.electionCode, 6257);
      expect(s.open, isTrue);
      expect(s.frame, isNull);
    });

    test(
      'with live files: national file vs sum of states, and a timeline',
      () async {
        await live.tick(session);
        LiveService.elections = () => _firstRound;
        final s = await endpoints.tally.live(sessionBuilder);
        expect(s.electionCode, 6257);
        final f = s.frame!;
        expect(f.origin, DataOrigin.live);
        expect(f.nationalPct, 100);
        expect(f.statesPct, 100);
        expect(f.missingScopes, isEmpty);
        expect(f.ufs, hasLength(28));
        final top = f.candidates.first;
        expect(top.ballotName, isNotNull);
        expect(top.national, top.states);
        expect(s.timeline, isNotEmpty);
        final times = s.timeline.map((p) => p.at).toList();
        expect(times, orderedEquals([...times]..sort()));
        expect(s.timeline.last.statesPct, 100);
      },
    );

    test(
      'a state file without the national one: the national side waits',
      () async {
        LiveService.elections = () => _firstRound;
        await SnapshotStore.record(
          session,
          origin: DataOrigin.live,
          electionCode: 6257,
          office: Office.presidente,
          bytes: File(
            '$_fixtures/oficial/ele2026/6257/dados/ac/ac-c0001-e006257-u.json',
          ).readAsBytesSync(),
          fetchedAt: brt(4, 18),
        );
        final s = await LiveService.status(session, now: brt(4, 18));
        expect(s.frame!.nationalPct, 0);
        expect(s.frame!.missingScopes, contains('br'));
        expect(s.frame!.missingScopes, contains('sp'));
      },
    );
  });
}

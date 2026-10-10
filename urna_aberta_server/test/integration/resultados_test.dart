import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/live/elections.dart';
import 'package:urna_aberta_server/src/results/results_service.dart';
import 'package:urna_aberta_server/src/results/resultados_endpoint.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Serves both archives by URL path (2024 under `fixtures/2024`, the rest
/// under `fixtures/2026-1t`); anything else is a 404.
class ArchiveTse implements TseHttp {
  final requested = <String>[];

  /// Served instead of the archived file, by file name.
  final overrides = <String, List<int>>{};
  int? failWith;

  @override
  Future<TseHttpResponse> get(Uri uri, Map<String, String> headers) async {
    requested.add(uri.path);
    if (failWith != null) return TseHttpResponse(failWith!, const [], const {});
    final override = overrides[uri.pathSegments.last];
    if (override != null) return TseHttpResponse(200, override, const {});
    final root = uri.path.contains('/ele2024/')
        ? '../fixtures/2024'
        : '../fixtures/2026-1t';
    final f = File('$root${uri.path}');
    if (!f.existsSync()) return TseHttpResponse(404, const [], const {});
    return TseHttpResponse(200, f.readAsBytesSync(), const {});
  }
}

class _NoWait extends TokenBucket {
  _NoWait() : super(ratePerSecond: 20, burst: 1);

  @override
  Future<void> acquire() async {}
}

/// The archived SP Deputado Federal file, rewritten as if only [st] of its
/// sections were totalized (the signature no longer verifies; this tests
/// freshness, not signatures).
List<int> partialSpDeputados(int st) {
  final jws = File(
    '../fixtures/2026-1t/oficial/ele2026/6259/dados/sp/sp-c0006-e006259-u.jws',
  ).readAsStringSync().trim().split('.');
  final json =
      jsonDecode(
            utf8.decode(base64Url.decode(base64Url.normalize(jws[1]))),
          )
          as Map<String, dynamic>;
  (json['s'] as Map<String, dynamic>)['st'] = '$st';
  final payload = base64Url.encode(utf8.encode(jsonEncode(json)));
  return utf8.encode('${jws[0]}.${payload.replaceAll('=', '')}.${jws[2]}');
}

void main() {
  final ea11 = parseElections(
    File(
      '../fixtures/2026-1t/oficial/comum/config/ele-c.json',
    ).readAsBytesSync(),
  );

  withServerpod('Resultados', (sessionBuilder, endpoints) {
    late ArchiveTse tse;
    late DateTime clock;

    setUp(() {
      tse = ArchiveTse();
      clock = DateTime.utc(2026, 10, 10, 15);
      ResultadosEndpoint.service = ResultsService(
        client: TseClient(http: tse, bucket: _NoWait()),
        elections: () => ea11,
        now: () => clock,
      );
    });

    int fetches() =>
        tse.requested.where((p) => p.endsWith('sp-c0006-e006259-u.jws')).length;

    test(
      'an incomplete result is checked again after 30 s; a final one is not',
      () async {
        tse.overrides['sp-c0006-e006259-u.jws'] = partialSpDeputados(50);
        final partial = await endpoints.resultados.resultado(
          sessionBuilder,
          6259,
          6,
          'sp',
        );
        expect(partial.complete, isFalse);
        expect(partial.sectionsTotalized, 50);

        await endpoints.resultados.resultado(sessionBuilder, 6259, 6, 'sp');
        expect(fetches(), 1, reason: 'fresh enough: no new request');

        clock = clock.add(const Duration(seconds: 31));
        tse.overrides.clear();
        final done = await endpoints.resultados.resultado(
          sessionBuilder,
          6259,
          6,
          'sp',
        );
        expect(fetches(), 2);
        expect(done.complete, isTrue);
        expect(await ResultFile.db.count(sessionBuilder.build()), 2);

        clock = clock.add(const Duration(hours: 1));
        await endpoints.resultados.resultado(sessionBuilder, 6259, 6, 'sp');
        expect(fetches(), 2, reason: 'a final file is never asked again');
      },
    );

    test('if TSE fails during a refresh, the last version is served', () async {
      tse.overrides['sp-c0006-e006259-u.jws'] = partialSpDeputados(50);
      await endpoints.resultados.resultado(sessionBuilder, 6259, 6, 'sp');
      clock = clock.add(const Duration(seconds: 31));
      tse.failWith = 503;
      final r = await endpoints.resultados.resultado(
        sessionBuilder,
        6259,
        6,
        'sp',
      );
      expect(r.sectionsTotalized, 50);
      expect(r.complete, isFalse);
    });

    test('lists the ordinary elections with their offices', () async {
      final all = await endpoints.resultados.eleicoes(sessionBuilder);
      ElectionSummary by(int code) => all.singleWhere((e) => e.code == code);
      expect(by(6259).offices, [3, 5, 6, 7, 8]);
      expect(by(6259).level, 'state');
      expect(by(619).offices, [11, 13]);
      expect(by(619).allMunicipalities, isTrue);
      expect(by(620).municipalScopes, contains('sp71072'));
      expect(by(6257).level, 'federal');
      // Newest first.
      expect(all.first.day.isAfter(all.last.day), isTrue);
    });

    test('municipalities of a municipal election, from EA12', () async {
      final sp = await endpoints.resultados.municipios(
        sessionBuilder,
        619,
        'sp',
      );
      expect(
        sp.singleWhere((m) => m.codigo == 71072).nome,
        'SÃO PAULO',
      );
      expect(sp, hasLength(645));
    });

    test(
      'Deputado Federal SP: TSE result and our matching allocation',
      () async {
        final r = await endpoints.resultados.resultado(
          sessionBuilder,
          6259,
          6,
          'sp',
        );
        expect(r.proportional, isTrue);
        expect(r.seats, 70);
        expect(r.fileName, 'sp-c0006-e006259-u.jws');
        expect(r.signature, SignatureStatus.valid);
        expect(r.validVotes, 23674188);
        expect(r.seatCheck!.matches, isTrue);
        expect(r.seatCheck!.quotient, 338203);
        expect(r.lists.fold(0, (s, l) => s + l.tseSeats!), 70);
        expect(r.lists.fold(0, (s, l) => s + l.ourSeats!), 70);
        final elected = r.candidates.where((c) => c.elected).toList();
        expect(elected, hasLength(70));
        expect(elected.every((c) => c.ourSeat != null), isTrue);
        expect(r.candidates.first.votes, greaterThan(r.candidates.last.votes));
      },
    );

    test(
      'a result is fetched once, stored signed, then served from the DB',
      () async {
        await endpoints.resultados.resultado(sessionBuilder, 6259, 6, 'sp');
        await endpoints.resultados.resultado(sessionBuilder, 6259, 6, 'sp');
        expect(
          tse.requested.where((p) => p.endsWith('sp-c0006-e006259-u.jws')),
          hasLength(1),
        );
        final rows = await ResultFile.db.find(sessionBuilder.build());
        expect(rows, hasLength(1));
        expect(rows.single.jws, startsWith('ey'));
      },
    );

    test('Vereador São Paulo 2024 matches TSE too', () async {
      final r = await endpoints.resultados.resultado(
        sessionBuilder,
        619,
        13,
        'sp71072',
      );
      expect(r.seats, 55);
      expect(r.seatCheck!.matches, isTrue);
    });

    test('Prefeito: a majoritarian ranking, no seat check', () async {
      final r = await endpoints.resultados.resultado(
        sessionBuilder,
        619,
        11,
        'sp71072',
      );
      expect(r.proportional, isFalse);
      expect(r.seatCheck, isNull);
      expect(
        r.candidates.where((c) => c.tseStatus == '2º turno'),
        hasLength(2),
      );
    });

    test(
      'an office the scope does not elect is refused before any request',
      () async {
        await expectLater(
          endpoints.resultados.resultado(sessionBuilder, 6259, 13, 'sp'),
          throwsA(
            isA<ResultUnavailable>().having(
              (e) => e.reason,
              'reason',
              'invalidRequest',
            ),
          ),
        );
        await expectLater(
          endpoints.resultados.resultado(sessionBuilder, 6259, 6, 'xx'),
          throwsA(isA<ResultUnavailable>()),
        );
        expect(tse.requested, isEmpty);
      },
    );

    test(
      'an election whose polls have not closed is never requested',
      () async {
        // 2nd round, 25/10/2026: a 404 would pause every TSE request.
        await expectLater(
          endpoints.resultados.resultado(sessionBuilder, 6258, 1, 'br'),
          throwsA(
            isA<ResultUnavailable>().having(
              (e) => e.reason,
              'reason',
              'notPublished',
            ),
          ),
        );
        expect(tse.requested, isEmpty);
      },
    );

    test('a municipality EA12 does not list is never requested', () async {
      await expectLater(
        endpoints.resultados.resultado(sessionBuilder, 619, 11, 'sp99999'),
        throwsA(
          isA<ResultUnavailable>().having(
            (e) => e.reason,
            'reason',
            'invalidRequest',
          ),
        ),
      );
      expect(tse.requested.where((p) => p.contains('dados')), isEmpty);
    });

    test(
      'the Câmara: 513 seats, our count matching TSE in all 27 states',
      () async {
        final c = await endpoints.resultados.camara(sessionBuilder, 6259);
        expect(c.seats, 513);
        expect(c.states, 27);
        expect(c.matchingStates, 27);
        expect(c.differingStates, isEmpty);
        expect(c.lists.fold(0, (s, l) => s + l.tseSeats!), 513);
        expect(c.lists.fold(0, (s, l) => s + l.ourSeats!), 513);
        final pl = c.lists.singleWhere((l) => l.number == 'PL');
        expect(pl.tseSeats, greaterThan(0));
        // Largest bench first.
        expect(
          c.lists.first.tseSeats,
          greaterThanOrEqualTo(c.lists[1].tseSeats!),
        );
      },
    );
  });
}

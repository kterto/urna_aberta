import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/live/elections.dart';
import 'package:urna_aberta_server/src/reports/relatorios_endpoint.dart';
import 'package:urna_aberta_server/src/reports/report_builder.dart';
import 'package:urna_aberta_server/src/reports/report_plan.dart';
import 'package:urna_aberta_server/src/reports/report_service.dart';
import 'package:urna_aberta_server/src/results/resultados_endpoint.dart';
import 'package:urna_aberta_server/src/results/results_service.dart';
import 'package:urna_aberta_server/src/secao/secao_endpoint.dart';
import 'package:urna_aberta_server/src/secao/section_service.dart';
import 'package:urna_aberta_server/src/tse/ea12.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

import 'resultados_test.dart' show ArchiveTse;
import 'secao_test.dart' show fixtureDirectory;
import 'test_tools/serverpod_test_tools.dart';

class _NoWait extends TokenBucket {
  _NoWait() : super(ratePerSecond: 20, burst: 1);

  @override
  Future<void> acquire() async {}
}

final _ea12 = parseEa12(
  File(
    '../fixtures/2026-1t/oficial/ele2026/6257/config/mun-e006257-cm.json',
  ).readAsBytesSync(),
);

ReportSpec _spec(List<int> offices, ReportPlace place) => ReportSpec(
  elections: [6257, 6259],
  offices: offices,
  places: [place],
  breakdown: ReportBreakdown.none,
  language: 'pt',
);

void main() {
  final ea11 = parseElections(
    File(
      '../fixtures/2026-1t/oficial/comum/config/ele-c.json',
    ).readAsBytesSync(),
  );
  final now = DateTime.utc(2026, 10, 11, 12);

  withServerpod('relatorios', (sessionBuilder, endpoints) {
    late TestSessionBuilder ana;

    setUp(() async {
      final tse = TseClient(http: ArchiveTse(), bucket: _NoWait());
      final results = ResultadosEndpoint.service = ResultsService(
        client: tse,
        elections: () => ea11,
        now: () => now,
      );
      final sections = SecaoEndpoint.service = SectionService(
        client: tse,
        urls: TseUrls.oficial(),
        directory: fixtureDirectory,
        now: () => now,
      );
      RelatoriosEndpoint.service = ReportService(
        planner: ReportPlanner(
          elections: () => ea11,
          municipalities: (_) async => _ea12,
          sections: (pleito, year, uf) => fixtureDirectory(uf),
          now: () => now,
        ),
        builder: ReportBuilder.fromServices(results, (_, _) => sections),
        ratePerSecond: 20,
      );
      final user = await AuthUser.db.insertRow(
        sessionBuilder.build(),
        AuthUser(scopeNames: {}),
      );
      ana = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id!.uuid,
          {},
        ),
      );
    });

    final ac = ReportPlace(kind: ReportPlaceKind.uf, uf: 'ac');

    test('needs a signed-in viewer', () async {
      await expectLater(
        endpoints.relatorios.orcar(sessionBuilder, _spec([1], ac)),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test(
      'quotes the files a report reads and the time to fetch them',
      () async {
        final q = await endpoints.relatorios.orcar(ana, _spec([1, 3], ac));
        expect(
          [q.files, q.stored, q.seconds, q.limit, q.tables],
          [2, 0, 1, 3000, 2],
        );
      },
    );

    test('files already stored are counted as such', () async {
      await endpoints.resultados.resultado(ana, 6257, 1, 'ac');
      final q = await endpoints.relatorios.orcar(ana, _spec([1, 3], ac));
      expect([q.files, q.stored], [2, 1]);
    });

    test('a looked-up section counts its three files as stored', () async {
      await endpoints.secao.consultar(ana, 'ac', 1066, 4, 77);
      final q = await endpoints.relatorios.orcar(
        ana,
        _spec(
          [1],
          ReportPlace(
            kind: ReportPlaceKind.zona,
            uf: 'ac',
            municipio: 1066,
            zona: 4,
          ),
        ),
      );
      // Plus Brazil's file, for the candidates' names.
      expect([q.files, q.stored], [34 * 3 + 1, 3]);
    });

    test('a spec naming anything TSE does not list is refused', () async {
      await expectLater(
        endpoints.relatorios.orcar(
          ana,
          _spec([8], ReportPlace(kind: ReportPlaceKind.uf, uf: 'sp')),
        ),
        throwsA(isA<ReportRefused>()),
      );
    });

    group('building', () {
      Future<List<ReportTable>> build(
        List<int> offices,
        ReportPlace place,
        ReportBreakdown breakdown,
      ) => RelatoriosEndpoint.service.build(
        ana.build(),
        ReportSpec(
          elections: [6257, 6259],
          offices: offices,
          places: [place],
          breakdown: breakdown,
          language: 'pt',
        ),
      );

      String describe(List<ReportTable> tables) => [
        for (final t in tables)
          for (final d in t.check ?? const [])
            '${t.item.office.name} ${d.what}: TSE ${d.tse}, ours ${d.ours}',
      ].join('; ');

      test("the 22 AC cities add up to TSE's AC file", () async {
        final tables = await build([1], ac, ReportBreakdown.municipio);
        final t = tables.single;
        expect(t.breakdown, hasLength(22));
        expect(t.check, isEmpty, reason: describe(tables));
      });

      test(
        "every BU of Porto Walter's zone adds up to TSE's Porto Walter file",
        () async {
          final tables = await build(
            [1, 3],
            ReportPlace(
              kind: ReportPlaceKind.municipio,
              uf: 'ac',
              municipio: 1066,
            ),
            ReportBreakdown.zona,
          );
          expect(tables, hasLength(2));
          for (final t in tables) {
            final zone = t.breakdown.single.$2;
            expect(zone.sectionsCounted, 34);
            expect(zone.excluded, isEmpty);
            expect(zone.sources, hasLength(34 * 3));
          }
          expect(
            tables.map((t) => t.check),
            everyElement(isEmpty),
            reason: describe(tables),
          );
        },
      );

      test('a region is our sum, with no TSE total to compare', () async {
        final tables = await build(
          [1],
          ReportPlace(kind: ReportPlaceKind.regiao, regiao: 'n'),
          ReportBreakdown.uf,
        );
        expect(tables.single.check, isNull);
        expect(tables.single.tally.sources, hasLength(7));
      });

      test('progress counts every file read', () async {
        final seen = <(int, int)>[];
        await RelatoriosEndpoint.service.build(
          ana.build(),
          _spec([1], ac),
          onProgress: (done, total) => seen.add((done, total)),
        );
        expect(seen, [(1, 1)]);
      });
    });
  });
}

import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/live/elections.dart';
import 'package:urna_aberta_server/src/reports/relatorios_endpoint.dart';
import 'package:urna_aberta_server/src/reports/report_builder.dart';
import 'package:urna_aberta_server/src/reports/report_pdf.dart';
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
    late TestSessionBuilder bia;
    late ArchiveTse http;
    late int scheduled;
    late bool scheduleFails;

    Future<TestSessionBuilder> signedIn() async {
      final user = await AuthUser.db.insertRow(
        sessionBuilder.build(),
        AuthUser(scopeNames: {}),
      );
      return sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id!.uuid,
          {},
        ),
      );
    }

    setUp(() async {
      http = ArchiveTse();
      scheduled = 0;
      scheduleFails = false;
      final tse = TseClient(http: http, bucket: _NoWait());
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
        builder: ReportBuilder.fromServices(
          results,
          (_, _) => sections,
          retryAfter: const [Duration.zero],
        ),
        ratePerSecond: 20,
        schedule: () async {
          if (scheduleFails) {
            throw StateError('FutureCalls is not initialized.');
          }
          scheduled++;
        },
        now: () => now,
      );
      ana = await signedIn();
      bia = await signedIn();
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
          [2, 0, 1, 6000, 2],
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

      test(
        'a PDF longer than 20 pages is built (Brazil by city is ~140)',
        () async {
          final t = (await build([1], ac, ReportBreakdown.municipio)).single;
          const copies = 40;
          final long = ReportTable(
            item: ReportItem(
              election: t.item.election,
              office: t.item.office,
              place: t.item.place,
              results: t.item.results,
              sections: t.item.sections,
              placeName: t.item.placeName,
              breakdown: [
                for (var i = 0; i < copies; i++) ...t.item.breakdown,
              ],
            ),
            tally: t.tally,
            breakdown: [for (var i = 0; i < copies; i++) ...t.breakdown],
            check: t.check,
          );
          final pdf = await reportPdf(
            request: ReportRequest(
              id: 1,
              authUserId: UuidValue.fromString(
                '01a12af6-da8a-760a-8a4c-e6f599a9ac88',
              ),
              spec: _spec([1], ac),
              status: ReportStatus.running,
              filesDone: 0,
              filesTotal: 0,
              createdAt: now,
            ),
            tables: [long],
            dataSha256: '0' * 64,
            generatedAt: now,
            fonts: await ReportFonts.load(),
          );
          final pages = RegExp(
            r'/Type\s*/Page[^s]',
          ).allMatches(latin1.decode(pdf)).length;
          expect(pages, greaterThan(20));
        },
      );

      test(
        'files are read several at a time, never more than the pool',
        () async {
          final real = RelatoriosEndpoint.service.builder;
          var inFlight = 0, most = 0, done = 0;
          final builder = ReportBuilder(
            result: (session, need) async {
              most = max(most, ++inFlight);
              try {
                await Future<void>.delayed(const Duration(milliseconds: 5));
                return await real.result(session, need);
              } finally {
                inFlight--;
              }
            },
            section: real.section,
          );
          final plan = await RelatoriosEndpoint.service.planner.plan(
            ReportSpec(
              elections: [6257],
              offices: [1],
              places: [ac],
              breakdown: ReportBreakdown.municipio,
              language: 'pt',
            ),
          );
          final tables = await builder.build(
            ana.build(),
            plan,
            onProgress: (d, _) => done = d,
          );
          expect(most, greaterThan(1));
          expect(most, lessThanOrEqualTo(ReportBuilder.parallel));
          expect(done, plan.files);
          expect(tables.single.check, isEmpty);
        },
      );

      test('a file TSE did not answer is asked again', () async {
        final real = RelatoriosEndpoint.service.builder;
        final failed = <ResultNeed>{};
        final builder = ReportBuilder(
          result: (session, need) async {
            if (failed.add(need)) {
              throw ResultUnavailable(
                message: 'O TSE não respondeu.',
                reason: 'tseUnavailable',
              );
            }
            return real.result(session, need);
          },
          section: real.section,
          retryAfter: const [Duration.zero],
        );
        final plan = await RelatoriosEndpoint.service.planner.plan(
          _spec([1], ac),
        );
        final tables = await builder.build(ana.build(), plan);
        expect(tables, isNotEmpty);
        expect(failed, plan.results);
      });

      test('a file TSE does not publish is not asked again', () async {
        final real = RelatoriosEndpoint.service.builder;
        var calls = 0;
        final builder = ReportBuilder(
          result: (session, need) async {
            calls++;
            throw ResultUnavailable(
              message: 'O TSE não publicou este arquivo.',
              reason: 'notPublished',
            );
          },
          section: real.section,
          retryAfter: const [Duration.zero, Duration.zero],
        );
        final plan = await RelatoriosEndpoint.service.planner.plan(
          _spec([1], ac),
        );
        await expectLater(
          builder.build(ana.build(), plan),
          throwsA(isA<ResultUnavailable>()),
        );
        expect(calls, lessThanOrEqualTo(plan.results.length));
      });

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
          expect(tables, isNotEmpty);
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

    group('queue', () {
      final relatorios = endpoints.relatorios;
      final porto = ReportPlace(
        kind: ReportPlaceKind.municipio,
        uf: 'ac',
        municipio: 1066,
      );

      Future<void> drain() =>
          RelatoriosEndpoint.service.drain(sessionBuilder.build());

      test('a request is queued and the queue is woken', () async {
        final r = await relatorios.pedir(ana, _spec([1, 3], ac));
        expect(r.status, ReportStatus.queued);
        expect([r.filesDone, r.filesTotal], [0, 2]);
        expect(scheduled, 1);
        expect(await relatorios.listar(ana), [
          isA<ReportRequest>().having((r) => r.id, 'id', r.id),
        ]);
      });

      test(
        'if the queue cannot be woken, the request is dropped, so the viewer '
        'can ask again',
        () async {
          scheduleFails = true;
          await expectLater(
            relatorios.pedir(ana, _spec([1, 3], ac)),
            throwsA(isA<StateError>()),
          );
          expect(await relatorios.listar(ana), isEmpty);

          scheduleFails = false;
          final r = await relatorios.pedir(ana, _spec([1, 3], ac));
          expect(r.status, ReportStatus.queued);
        },
      );

      test('the queue builds the report and stores its CSV', () async {
        final r = await relatorios.pedir(ana, _spec([1, 3], ac));
        await drain();
        final done = (await relatorios.listar(ana)).single;
        expect(done.status, ReportStatus.ready);
        expect(done.filesDone, done.filesTotal);
        expect(done.sha256, hasLength(64));
        final bytes = Uint8List.sublistView(
          await relatorios.baixar(ana, r.id!, 'csv'),
        );
        // A BOM, so spreadsheet apps read the accents.
        expect(bytes.take(3), [0xEF, 0xBB, 0xBF]);
        final lines = utf8.decode(bytes).split('\n');
        expect(lines.first, startsWith('eleicao,turno,cargo,local'));
        expect(
          lines,
          contains(startsWith('6257,1,1,ac,AC,local,AC,tse,total,,,,488330')),
        );
        expect(lines.where((l) => l.startsWith('6259,1,3,ac,')), isNotEmpty);
      });

      test('a breakdown with a TSE total ends with its check', () async {
        final r = await relatorios.pedir(
          ana,
          ReportSpec(
            elections: [6257],
            offices: [1],
            places: [porto],
            breakdown: ReportBreakdown.zona,
            language: 'pt',
          ),
        );
        await drain();
        final csv = utf8.decode(
          Uint8List.sublistView(await relatorios.baixar(ana, r.id!, 'csv')),
        );
        expect(
          csv,
          contains(
            'ac01066z0004,"PORTO WALTER (AC), zona 4",soma,secoes_somadas,,,,34',
          ),
        );
        expect(csv, contains('conferencia,confere,,,,1,,'));
      });

      test(
        'the PDF is stored next to the CSV, in the asked language',
        () async {
          // REPORT_PDF_OUT=<dir> keeps the PDFs, to look at them.
          final out = Platform.environment['REPORT_PDF_OUT'];
          for (final (name, language, places, offices, breakdown) in [
            ('zona', 'pt', [porto], [1, 3], ReportBreakdown.zona),
            ('cidades', 'en', [ac], [1], ReportBreakdown.municipio),
            (
              'deputados',
              'pt',
              [ReportPlace(kind: ReportPlaceKind.regiao, regiao: 'n')],
              [6],
              ReportBreakdown.uf,
            ),
          ]) {
            final r = await relatorios.pedir(
              ana,
              ReportSpec(
                elections: [6257, 6259],
                offices: offices,
                places: places,
                breakdown: breakdown,
                language: language,
              ),
            );
            await drain();
            final pdf = Uint8List.sublistView(
              await relatorios.baixar(ana, r.id!, 'pdf'),
            );
            expect(ascii.decode(pdf.sublist(0, 5)), '%PDF-');
            expect(pdf.length, greaterThan(20000));
            if (out != null) {
              File('$out/relatorio-$name.pdf').writeAsBytesSync(pdf);
            }
          }
        },
      );

      test('reports are built one after another, oldest first', () async {
        final first = await relatorios.pedir(ana, _spec([1], ac));
        final second = await relatorios.pedir(bia, _spec([3], ac));
        await Future.wait([drain(), drain()]);
        final a = (await relatorios.listar(ana)).single;
        final b = (await relatorios.listar(bia)).single;
        expect([a.id, b.id], [first.id, second.id]);
        expect([a.status, b.status], everyElement(ReportStatus.ready));
        expect(b.startedAt!.isBefore(a.finishedAt!), isFalse);
      });

      test('one report in the queue per viewer', () async {
        await relatorios.pedir(ana, _spec([1], ac));
        await expectLater(
          relatorios.pedir(ana, _spec([3], ac)),
          throwsA(
            isA<ReportRefused>().having((e) => e.reason, 'reason', 'busy'),
          ),
        );
        await drain();
        await relatorios.pedir(ana, _spec([3], ac));
      });

      test('a spec over the limit is refused', () async {
        await expectLater(
          relatorios.pedir(
            ana,
            _spec([1], ReportPlace(kind: ReportPlaceKind.br))
              ..breakdown = ReportBreakdown.zona,
          ),
          throwsA(
            isA<ReportRefused>().having((e) => e.reason, 'reason', 'tooLarge'),
          ),
        );
      });

      test('when TSE fails, the report fails and the queue goes on', () async {
        http.failWith = 503;
        final failing = await relatorios.pedir(ana, _spec([1], ac));
        await drain();
        http.failWith = null;
        final r = (await relatorios.listar(ana)).single;
        expect(r.id, failing.id);
        expect(
          [r.status, r.errorReason],
          [
            ReportStatus.failed,
            'tseUnavailable',
          ],
        );
        await expectLater(
          relatorios.baixar(ana, r.id!, 'csv'),
          throwsA(isA<ReportRefused>()),
        );
        final next = await relatorios.pedir(ana, _spec([1], ac));
        await drain();
        expect(
          (await relatorios.listar(
            ana,
          )).singleWhere((r) => r.id == next.id).status,
          ReportStatus.ready,
        );
      });

      test('following a report streams it until it is ready', () async {
        final r = await relatorios.pedir(ana, _spec([1, 3], ac));
        final seen = <ReportStatus>[];
        final done = relatorios
            .acompanhar(ana, r.id!)
            .map((r) => r.status)
            .forEach(seen.add);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await drain();
        await done.timeout(const Duration(seconds: 10));
        expect(seen.first, ReportStatus.queued);
        expect(seen.last, ReportStatus.ready);
        expect(seen, contains(ReportStatus.running));
      });

      test('a finished report streams once and ends', () async {
        final r = await relatorios.pedir(ana, _spec([1], ac));
        await drain();
        expect(
          await relatorios.acompanhar(ana, r.id!).map((r) => r.status).toList(),
          [ReportStatus.ready],
        );
      });

      test(
        "nobody else can see, follow or download a viewer's report",
        () async {
          final r = await relatorios.pedir(ana, _spec([1], ac));
          await drain();
          expect(await relatorios.listar(bia), isEmpty);
          for (final call in [
            () => relatorios.baixar(bia, r.id!, 'csv'),
            () => relatorios.acompanhar(bia, r.id!).first,
            () => relatorios.publicar(bia, r.id!, true),
            () => relatorios.apagar(bia, r.id!),
          ]) {
            await expectLater(
              call(),
              throwsA(
                isA<ReportRefused>().having(
                  (e) => e.reason,
                  'reason',
                  'notFound',
                ),
              ),
            );
          }
        },
      );

      test('a published report is readable by its token, until '
          'unpublished', () async {
        final r = await relatorios.pedir(ana, _spec([1], ac));
        await drain();
        final service = RelatoriosEndpoint.service;
        final session = sessionBuilder.build();
        final published = await relatorios.publicar(ana, r.id!, true);
        final token = published.publicToken!;
        expect(token, hasLength(22));
        expect((await service.published(session, token))!.id, r.id);
        expect(await service.publishedFile(session, token, 'csv'), isNotNull);
        expect(await service.publishedFile(session, token, 'pdf'), isNotNull);
        expect(await service.publishedFile(session, token, 'doc'), isNull);

        await relatorios.publicar(ana, r.id!, false);
        expect(await service.published(session, token), isNull);
        expect(await service.publishedFile(session, token, 'csv'), isNull);
      });

      test('a request names its places', () async {
        final r = await relatorios.pedir(
          ana,
          ReportSpec(
            elections: [6257],
            offices: [1],
            places: [porto, ac],
            breakdown: ReportBreakdown.none,
            language: 'pt',
          ),
        );
        expect(r.placeNames, ['PORTO WALTER (AC)', 'AC']);
      });

      test('a download link serves the file for ten minutes', () async {
        final r = await relatorios.pedir(ana, _spec([1], ac));
        await drain();
        final service = RelatoriosEndpoint.service;
        final session = sessionBuilder.build();
        final link = Uri.parse(await relatorios.link(ana, r.id!, 'pdf'));
        expect(link.path, startsWith('/d/'));
        final token = link.pathSegments.last;
        expect(service.openLink(token), (r.id, 'pdf'));
        final pdf = await service.linkedFile(session, token);
        expect(ascii.decode(Uint8List.sublistView(pdf!, 0, 5)), '%PDF-');

        // Tampered: another report or format under the same signature.
        final [payload, signature] = token.split('.');
        final forged = base64Url
            .encode(utf8.encode('${r.id! + 1}.pdf.9999999999'))
            .replaceAll('=', '');
        expect(service.openLink('$forged.$signature'), isNull);
        expect(service.openLink('$payload.x$signature'), isNull);
        expect(service.openLink('garbage'), isNull);

        await expectLater(
          relatorios.link(bia, r.id!, 'pdf'),
          throwsA(isA<ReportRefused>()),
        );
      });

      test('a download link expires', () async {
        var clock = now;
        final service = ReportService(
          planner: RelatoriosEndpoint.service.planner,
          builder: RelatoriosEndpoint.service.builder,
          ratePerSecond: 20,
          now: () => clock,
        );
        RelatoriosEndpoint.service = service;
        final r = await relatorios.pedir(ana, _spec([1], ac));
        await drain();
        final token = Uri.parse(
          await relatorios.link(ana, r.id!, 'csv'),
        ).pathSegments.last;
        clock = now.add(const Duration(minutes: 9));
        expect(service.openLink(token), isNotNull);
        clock = now.add(const Duration(minutes: 11));
        expect(service.openLink(token), isNull);
      });

      test('the public link is the published page', () async {
        final r = await relatorios.pedir(ana, _spec([1], ac));
        await drain();
        expect(await relatorios.linkPublico(ana, r.id!), isNull);
        final p = await relatorios.publicar(ana, r.id!, true);
        expect(
          await relatorios.linkPublico(ana, r.id!),
          'http://localhost:8082/r/${p.publicToken}',
        );
      });

      test('only a ready report can be published', () async {
        final r = await relatorios.pedir(ana, _spec([1], ac));
        await expectLater(
          relatorios.publicar(ana, r.id!, true),
          throwsA(isA<ReportRefused>()),
        );
      });

      test('deleting a report deletes its files', () async {
        final r = await relatorios.pedir(ana, _spec([1], ac));
        await drain();
        await relatorios.apagar(ana, r.id!);
        expect(await relatorios.listar(ana), isEmpty);
        expect(
          await sessionBuilder.build().storage.fileExists(
            storageId: ReportService.storageId,
            path: ReportService.filePath(r.id!, 'csv'),
          ),
          isFalse,
        );
      });

      test(
        'a report whose server went quiet is queued again; '
        'one still being built is left alone',
        () async {
          final quiet = await relatorios.pedir(ana, _spec([1], ac));
          final alive = await relatorios.pedir(bia, _spec([1], ac));
          final session = sessionBuilder.build();
          await ReportRequest.db.updateRow(
            session,
            quiet.copyWith(
              status: ReportStatus.running,
              filesDone: 1,
              aliveAt: now.subtract(
                ReportService.staleAfter + const Duration(seconds: 1),
              ),
            ),
          );
          await ReportRequest.db.updateRow(
            session,
            alive.copyWith(
              status: ReportStatus.running,
              filesDone: 1,
              aliveAt: now.subtract(const Duration(seconds: 20)),
            ),
          );
          expect(await RelatoriosEndpoint.service.recover(session), isTrue);
          final q = (await relatorios.listar(ana)).single;
          expect([q.status, q.filesDone], [ReportStatus.queued, 0]);
          final a = (await relatorios.listar(bia)).single;
          expect([a.status, a.filesDone], [ReportStatus.running, 1]);
        },
      );

      test('deleting the account deletes its reports', () async {
        await relatorios.pedir(ana, _spec([1], ac));
        final session = sessionBuilder.build();
        await AuthUser.db.deleteWhere(
          session,
          where: (t) => t.id.notEquals(null),
        );
        expect(await ReportRequest.db.count(session), 0);
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/conta/conta_controller.dart';
import 'package:urna_aberta_flutter/relatorios/novo_relatorio_controller.dart';
import 'package:urna_aberta_flutter/resultados/resultados_controller.dart';
import 'package:urna_aberta_flutter/screens/conta_screen.dart';
import 'package:urna_aberta_flutter/screens/meus_relatorios_screen.dart';
import 'package:urna_aberta_flutter/screens/novo_relatorio_screen.dart';
import 'package:urna_aberta_flutter/secao/secao_controller.dart';

import '../conta/fake_conta_source.dart';
import '../relatorios/fake_relatorios_source.dart';
import '../resultados/fake_resultados_source.dart';
import '../secao/fake_secao_source.dart';
import '../support/test_app.dart';

final _acDraft = ReportDraft(
  day: DateTime.utc(2026, 10, 4),
  offices: {1},
  places: [ReportPlace(kind: ReportPlaceKind.uf, uf: 'ac')],
);

void main() {
  late FakeRelatoriosSource reports;
  late List<Uri> opened;

  setUp(() {
    reports = FakeRelatoriosSource();
    opened = [];
  });

  Future<void> pump(
    WidgetTester tester,
    Widget home, {
    bool signedIn = true,
    Locale locale = const Locale('pt'),
  }) async {
    tester.view.physicalSize = const Size(1280, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final conta = ContaController(FakeContaSource(signedIn: signedIn));
    await conta.start();
    await tester.pumpWidget(
      ResultadosScope(
        source: FakeResultadosSource(),
        child: SecaoScope(
          source: FakeSecaoSource(),
          child: testApp(
            locale: locale,
            conta: conta,
            relatorios: reports,
            home: home,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  NovoRelatorioScreen novo([ReportDraft draft = const ReportDraft()]) =>
      NovoRelatorioScreen(
        draft: draft,
        debounce: Duration.zero,
        now: () => DateTime.utc(2026, 10, 11, 12),
      );

  group('Novo relatório', () {
    testWidgets('signed out: asks to sign in and quotes nothing', (
      tester,
    ) async {
      await pump(tester, novo(_acDraft), signedIn: false);
      expect(find.text('Entre para montar relatórios'), findsOneWidget);
      expect(reports.quoted, isEmpty);
      final generate = tester.widget<ButtonStyleButton>(
        find.ancestor(
          of: find.text('Gerar relatório'),
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        ),
      );
      expect(generate.onPressed, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a draft is quoted, then queued into Meus relatórios', (
      tester,
    ) async {
      await pump(tester, novo(_acDraft));
      expect(find.text('Presidente'), findsWidgets);
      expect(find.widgetWithText(InputChip, 'AC'), findsOneWidget);
      expect(
        find.textContaining('Lê 23 arquivos do TSE, 1 já guardados aqui'),
        findsOneWidget,
      );
      await tester.tap(find.text('Gerar relatório'));
      // A queued report's progress bar keeps animating: no settling.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(reports.requested.single.offices, [1]);
      expect(find.text('Meus relatórios'), findsWidgets);
      expect(find.text('Na fila'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a report too large says so', (tester) async {
      reports.refuse = ReportRefused(message: 'x', reason: 'tooLarge');
      await pump(tester, novo(_acDraft));
      expect(find.textContaining('mais de 3.000 arquivos'), findsOneWidget);
    });

    testWidgets('in English', (tester) async {
      await pump(tester, novo(_acDraft), locale: const Locale('en'));
      expect(find.text('New report'), findsWidgets);
      expect(find.textContaining('Reads 23 TSE files'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('removing the only place asks for one', (tester) async {
      await pump(tester, novo(_acDraft));
      await tester.tap(find.byTooltip('Remover AC'));
      await tester.pumpAndSettle();
      expect(find.text('Nenhum local ainda.'), findsOneWidget);
      expect(
        find.text('Escolha ao menos uma eleição, um cargo e um local.'),
        findsOneWidget,
      );
    });
  });

  group('Meus relatórios', () {
    MeusRelatoriosScreen meus() =>
        MeusRelatoriosScreen(open: (u) async => opened.add(u));

    testWidgets('a ready report downloads and can be published', (
      tester,
    ) async {
      reports.reports = [sampleRequest(id: 5)];
      await pump(tester, meus());
      expect(find.text('Presidente · AC'), findsOneWidget);
      expect(find.text('Pronto'), findsOneWidget);
      await tester.tap(find.text('Baixar PDF'));
      await tester.pumpAndSettle();
      expect(opened.single.path, '/d/token-5-pdf');

      await tester.tap(find.text('Publicar link'));
      await tester.pumpAndSettle();
      expect(find.text('Copiar link'), findsOneWidget);
      expect(find.textContaining('qualquer pessoa com o link'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a running report shows its progress live', (tester) async {
      reports.reports = [
        sampleRequest(id: 6, status: ReportStatus.running, filesDone: 3),
      ];
      await pump(tester, meus());
      expect(find.text('Montando'), findsOneWidget);
      expect(find.text('3 de 23 arquivos'), findsOneWidget);
      reports.streams[6]!.add(sampleRequest(id: 6));
      await tester.pumpAndSettle();
      expect(find.text('Pronto'), findsOneWidget);
      expect(find.text('Baixar PDF'), findsOneWidget);
    });

    testWidgets('a failed report says why and can be retried', (
      tester,
    ) async {
      reports.reports = [
        sampleRequest(
          id: 8,
          status: ReportStatus.failed,
          errorReason: 'tseUnavailable',
        ),
      ];
      await pump(tester, meus());
      expect(find.text('Falhou'), findsOneWidget);
      expect(find.textContaining('O TSE não respondeu'), findsOneWidget);
      await tester.tap(find.text('Tentar de novo'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(reports.requested, hasLength(1));
      expect(find.text('Na fila'), findsOneWidget);
    });

    testWidgets('no reports yet', (tester) async {
      await pump(tester, meus());
      expect(
        find.text('Você ainda não pediu nenhum relatório.'),
        findsOneWidget,
      );
    });
  });

  testWidgets('Meu local links to reports when signed in', (tester) async {
    await pump(tester, const ContaScreen());
    expect(find.text('Relatórios'), findsOneWidget);
    await tester.tap(find.text('Novo relatório'));
    await tester.pumpAndSettle();
    expect(find.text('Novo relatório'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/resultados/resultados_controller.dart';
import 'package:urna_aberta_flutter/screens/resultados_screen.dart';

import '../resultados/fake_resultados_source.dart';
import '../support/test_app.dart';

final _now = DateTime.utc(2026, 10, 10, 15);

Future<void> pumpScreen(
  WidgetTester tester,
  FakeResultadosSource source, {
  Locale locale = const Locale('pt'),
  Size size = const Size(1300, 3000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    testApp(
      locale: locale,
      home: ResultadosScope(
        source: source,
        child: Scaffold(body: ResultadosScreen(now: () => _now)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pick(WidgetTester tester, Finder menu, String entry) async {
  await tester.tap(menu);
  await tester.pumpAndSettle();
  await tester.tap(find.text(entry).last);
  await tester.pumpAndSettle();
}

void main() {
  for (final size in const [Size(1300, 3000), Size(390, 3000)]) {
    final w = size.width.toInt();

    testWidgets('opens on Deputado Federal SP with the seat check ($w px)', (
      tester,
    ) async {
      await pumpScreen(tester, FakeResultadosSource(), size: size);
      expect(find.text('Resultados'), findsWidgets);
      expect(find.text('Deputado Federal'), findsWidgets);
      expect(find.text('Nossa conta confere com a do TSE'), findsOneWidget);
      expect(find.text('FEDERAÇÃO AZUL'), findsOneWidget);
      expect(find.text('ANA LIMA'), findsOneWidget);
      // Every plate's source line carries the TSE file code.
      expect(find.text('sp-c0006-e006259-u.jws'), findsNWidgets(3));
      expect(find.text('Assinatura válida'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a difference from TSE is said, not hidden', (tester) async {
    final source = FakeResultadosSource()
      ..report = (e, c, a) => proportionalReport(matches: false);
    await pumpScreen(tester, source);
    expect(
      find.text('Nossa conta difere da do TSE em 4 pontos'),
      findsOneWidget,
    );
    expect(find.text('nossa conta: 1'), findsOneWidget);
  });

  testWidgets('a municipal election: choose a municipality, see Prefeito', (
    tester,
  ) async {
    await pumpScreen(tester, FakeResultadosSource());
    await pick(
      tester,
      find.byType(DropdownMenu<ElectionSummary>),
      '2024 · 1º turno',
    );
    expect(
      find.text('Escolha o município para ver o resultado.'),
      findsOneWidget,
    );
    await pick(tester, find.byType(DropdownMenu<MunicipioRef>), 'SÃO PAULO');
    expect(find.text('CANDIDATO A'), findsOneWidget);
    expect(find.text('2º turno'), findsNWidgets(2));
    expect(find.text('Nossa conta confere com a do TSE'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a QP seat with no 10% candidate is explained', (tester) async {
    final r = proportionalReport();
    final source = FakeResultadosSource()
      ..report = (e, c, a) => r.copyWith(
        lists: [r.lists.first.copyWith(partyQuotient: 4), r.lists.last],
      );
    await pumpScreen(tester, source);
    expect(
      find.textContaining('2 vagas do QP sem candidato com 10%'),
      findsOneWidget,
    );
  });

  testWidgets('a vote not held yet says so', (tester) async {
    await pumpScreen(tester, FakeResultadosSource());
    await pick(
      tester,
      find.byType(DropdownMenu<ElectionSummary>),
      '2026 · 2º turno',
    );
    expect(find.textContaining('ainda não aconteceu'), findsOneWidget);
  });

  testWidgets('a result TSE has not published', (tester) async {
    final source = FakeResultadosSource()
      ..failWith = ResultUnavailable(message: 'x', reason: 'notPublished');
    await pumpScreen(tester, source);
    expect(
      find.text('O TSE ainda não publicou este resultado.'),
      findsOneWidget,
    );
  });

  testWidgets('search narrows the candidates', (tester) async {
    await pumpScreen(tester, FakeResultadosSource());
    await tester.enterText(find.byType(TextField).last, 'joao');
    await tester.pumpAndSettle();
    expect(find.text('JOÃO SOUZA'), findsOneWidget);
    expect(find.text('ANA LIMA'), findsNothing);
  });

  testWidgets('in English', (tester) async {
    await pumpScreen(
      tester,
      FakeResultadosSource(),
      locale: const Locale('en'),
    );
    expect(find.text('Results'), findsWidgets);
    expect(find.text('Federal Deputy'), findsWidgets);
    expect(find.text("Our count matches TSE's"), findsOneWidget);
    expect(find.text('2026 · round 1'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

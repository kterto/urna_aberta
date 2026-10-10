import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/design/theme.dart';
import 'package:urna_aberta_flutter/screens/secao_screen.dart';
import 'package:urna_aberta_flutter/secao/secao_controller.dart';

import '../secao/fake_secao_source.dart';

Future<void> pumpScreen(WidgetTester tester, FakeSecaoSource source) async {
  tester.view.physicalSize = const Size(1300, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: atlasTheme(Brightness.light),
      home: SecaoScope(
        source: source,
        child: const Scaffold(body: SecaoScreen()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> choose(WidgetTester tester, String field, String option) async {
  await tester.tap(find.widgetWithText(DropdownMenu<Object>, field));
  await tester.pumpAndSettle();
  await tester.tap(find.text(option).last);
  await tester.pumpAndSettle();
}

Future<void> lookUp77(WidgetTester tester) async {
  await choose(tester, 'UF', 'AC');
  await choose(tester, 'Município', 'PORTO WALTER');
  await choose(tester, 'Zona', '0004');
  await choose(tester, 'Seção', '0077');
  await tester.tap(find.text('Buscar boletim de urna'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('finds the section and shows the official BU, checked', (
    tester,
  ) async {
    await pumpScreen(tester, FakeSecaoSource());
    await lookUp77(tester);
    expect(find.text('22 · FLAVIO BOLSONARO'), findsOneWidget);
    expect(find.text('103'), findsWidgets);
    expect(find.text('Hash confere'), findsOneWidget);
    expect(find.text('Assinatura não verificada'), findsOneWidget);
    expect(find.textContaining('18:34'), findsWidgets);
    expect(find.text('Branco'), findsOneWidget);
  });

  testWidgets('a paper number that differs is flagged', (tester) async {
    await pumpScreen(tester, FakeSecaoSource());
    await lookUp77(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Papel').first,
      '100',
    );
    await tester.pump();
    expect(find.textContaining('Uma linha não confere'), findsOneWidget);
  });

  testWidgets('switches between offices on the BU', (tester) async {
    await pumpScreen(tester, FakeSecaoSource());
    await lookUp77(tester);
    await tester.tap(find.text('Governador'));
    await tester.pumpAndSettle();
    expect(find.text('11 · FULANO'), findsOneWidget);
  });

  testWidgets(
    'a BU that differs from the urna list shows a warning, no votes',
    (tester) async {
      final source = FakeSecaoSource()
        ..report = () => sampleReport(check: BuCheck.differs);
      await pumpScreen(tester, source);
      await lookUp77(tester);
      expect(find.textContaining('não confere com a lista'), findsOneWidget);
      expect(find.text('22 · FLAVIO BOLSONARO'), findsNothing);
    },
  );

  testWidgets('TSE unavailable: the message and a retry', (tester) async {
    final source = FakeSecaoSource()
      ..fail = SectionUnavailableException(
        message: 'O TSE não respondeu agora.',
      );
    await pumpScreen(tester, source);
    await lookUp77(tester);
    expect(find.text('O TSE não respondeu agora.'), findsOneWidget);
    source.fail = null;
    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();
    expect(find.text('22 · FLAVIO BOLSONARO'), findsOneWidget);
  });

  testWidgets('no files yet', (tester) async {
    final source = FakeSecaoSource()
      ..report = () =>
          sampleReport(check: BuCheck.missing, status: 'Aguardando');
    await pumpScreen(tester, source);
    await lookUp77(tester);
    expect(find.textContaining('ainda não publicou'), findsOneWidget);
  });
}

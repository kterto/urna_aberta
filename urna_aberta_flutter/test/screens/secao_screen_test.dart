import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/conta/conta_controller.dart';
import 'package:urna_aberta_flutter/screens/secao_screen.dart';
import 'package:urna_aberta_flutter/secao/secao_controller.dart';

import '../conta/fake_conta_source.dart';
import '../secao/fake_secao_source.dart';
import '../support/test_app.dart';

Future<void> pumpScreen(
  WidgetTester tester,
  FakeSecaoSource source, {
  Locale locale = const Locale('pt'),
  Size size = const Size(1300, 2600),
  ContaController? conta,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    testApp(
      locale: locale,
      conta: conta,
      home: SecaoScope(
        source: source,
        child: const Scaffold(body: SecaoScreen()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> openField(WidgetTester tester, String field) async {
  await tester.tap(find.widgetWithText(InkWell, field));
  await tester.pumpAndSettle();
}

Future<void> choose(WidgetTester tester, String field, String option) async {
  await openField(tester, field);
  final row = find.descendant(
    of: find.byType(ListView),
    matching: find.text(option),
  );
  await tester.scrollUntilVisible(
    row,
    96,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.ensureVisible(row);
  await tester.pumpAndSettle();
  await tester.tap(row);
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

Future<void> lookUp77InEnglish(WidgetTester tester) async {
  await choose(tester, 'State', 'AC');
  await choose(tester, 'Municipality', 'PORTO WALTER');
  await choose(tester, 'Zone', '0004');
  await choose(tester, 'Section', '0077');
  await tester.tap(find.text('Find the ballot box report'));
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
    expect(find.text('Assinatura da urna confere'), findsOneWidget);
    expect(find.textContaining('AC UE2022'), findsNothing);
    expect(find.textContaining('ainda não é verificada'), findsNothing);
    expect(find.textContaining('18:34'), findsWidgets);
    expect(find.text('Branco'), findsOneWidget);
  });

  testWidgets('an urna signature that does not check out is flagged', (
    tester,
  ) async {
    final source = FakeSecaoSource()
      ..report = () => sampleReport(signature: UrnaSignature.invalid);
    await pumpScreen(tester, source);
    await lookUp77(tester);
    expect(find.text('Assinatura da urna não confere'), findsOneWidget);
    expect(find.text('Assinatura da urna confere'), findsNothing);
    expect(
      find.textContaining('não veio de uma urna certificada'),
      findsOneWidget,
    );
  });

  testWidgets('older urna models are not claimed as checked', (tester) async {
    final source = FakeSecaoSource()
      ..report = () => sampleReport(signature: UrnaSignature.unsupported);
    await pumpScreen(tester, source);
    await lookUp77(tester);
    expect(find.text('Assinatura não conferida'), findsOneWidget);
    expect(find.text('Assinatura da urna confere'), findsNothing);
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
    // The server's own (Portuguese) message is not shown; the type is.
    expect(find.textContaining('O TSE não respondeu agora'), findsOneWidget);
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

  testWidgets('while a list loads, its field says so', (tester) async {
    final source = FakeSecaoSource()..hold = true;
    await pumpScreen(tester, source);
    await openField(tester, 'UF');
    await tester.tap(find.text('AC').last);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Carregando municípios…'), findsOneWidget);
    source.release('ac');
    await tester.pumpAndSettle();
    expect(find.text('Carregando municípios…'), findsNothing);
  });

  testWidgets('a long list filters as you type', (tester) async {
    await pumpScreen(tester, FakeSecaoSource());
    await choose(tester, 'UF', 'AC');
    await openField(tester, 'Município');
    await tester.enterText(find.byType(TextField).last, 'porto');
    await tester.pumpAndSettle();
    expect(find.text('CRUZEIRO DO SUL'), findsNothing);
    await tester.tap(find.text('PORTO WALTER').last);
    await tester.pumpAndSettle();
    await choose(tester, 'Zona', '0004');
    expect(find.text('0004'), findsOneWidget);
  });

  testWidgets('a long list builds only the rows on screen', (tester) async {
    await pumpScreen(tester, FakeSecaoSource());
    await choose(tester, 'UF', 'MG');
    await openField(tester, 'Município');
    expect(find.text('CIDADE 000'), findsOneWidget);
    // Not even built off screen, which an eager list would do.
    expect(find.text('CIDADE 899', skipOffstage: false), findsNothing);
    await tester.enterText(find.byType(TextField).last, '899');
    await tester.pumpAndSettle();
    expect(find.text('CIDADE 899'), findsOneWidget);
  });

  testWidgets('while the report loads, says TSE is being asked', (
    tester,
  ) async {
    final source = FakeSecaoSource()..holdReport = Completer<void>();
    await pumpScreen(tester, source);
    await choose(tester, 'UF', 'AC');
    await choose(tester, 'Município', 'PORTO WALTER');
    await choose(tester, 'Zona', '0004');
    await choose(tester, 'Seção', '0077');
    await tester.tap(find.text('Buscar boletim de urna'));
    await tester.pump();
    expect(find.textContaining('Buscando os arquivos'), findsOneWidget);
    source.holdReport!.complete();
    await tester.pumpAndSettle();
    expect(find.textContaining('Buscando os arquivos'), findsNothing);
    expect(find.text('22 · FLAVIO BOLSONARO'), findsOneWidget);
  });

  group('in English', () {
    const en = Locale('en');

    testWidgets('finds the section and shows the checked report', (
      tester,
    ) async {
      final source = FakeSecaoSource()
        ..report = () => sampleReport(aptos: 1289);
      await pumpScreen(tester, source, locale: en);
      expect(find.text('My polling section'), findsWidgets);
      await lookUp77InEnglish(tester);
      expect(find.text('Ballot box report: file vs paper'), findsOneWidget);
      expect(find.text('President'), findsOneWidget);
      expect(find.text('Governor'), findsOneWidget);
      expect(find.text('Blank'), findsOneWidget);
      expect(find.text('Hash matches'), findsOneWidget);
      expect(find.text('Ballot box signature valid'), findsOneWidget);
      expect(
        find.textContaining('1,289 eligible voters, 234 voted'),
        findsOneWidget,
      );
      expect(find.textContaining('ballot box clock'), findsOneWidget);
      expect(find.textContaining('18:34 (Brasília time)'), findsOneWidget);
    });

    testWidgets('Portuguese keeps its own number format', (tester) async {
      final source = FakeSecaoSource()
        ..report = () => sampleReport(aptos: 1289);
      await pumpScreen(tester, source);
      await lookUp77(tester);
      expect(find.textContaining('1.289 eleitores aptos'), findsOneWidget);
    });

    testWidgets('a differing paper number is flagged', (tester) async {
      await pumpScreen(tester, FakeSecaoSource(), locale: en);
      await lookUp77InEnglish(tester);
      await tester.enterText(
        find.widgetWithText(TextField, 'Paper').first,
        '100',
      );
      await tester.pump();
      expect(find.textContaining('One row does not match'), findsOneWidget);
    });

    testWidgets('TSE unavailable: localized message, not the server text', (
      tester,
    ) async {
      final source = FakeSecaoSource()
        ..fail = SectionUnavailableException(message: 'O TSE não respondeu.');
      await pumpScreen(tester, source, locale: en);
      await lookUp77InEnglish(tester);
      expect(find.textContaining('TSE did not respond'), findsOneWidget);
      expect(find.text('O TSE não respondeu.'), findsNothing);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('the picker search is in English', (tester) async {
      await pumpScreen(tester, FakeSecaoSource(), locale: en);
      await choose(tester, 'State', 'AC');
      await openField(tester, 'Municipality');
      expect(find.text('Search municipality'), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('Nothing found for “zzz”.'), findsOneWidget);
    });

    testWidgets('a phone fits the English report', (tester) async {
      await pumpScreen(
        tester,
        FakeSecaoSource(),
        locale: en,
        size: const Size(390, 3000),
      );
      await lookUp77InEnglish(tester);
      expect(find.text('Ballot box report: file vs paper'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('meu local', () {
    Future<ContaController> conta(FakeContaSource source) async =>
        ContaController(source)..start();

    testWidgets('the saved section opens and is read', (tester) async {
      final c = await conta(
        FakeContaSource(signedIn: true, place: portoWalter()),
      );
      await pumpScreen(tester, FakeSecaoSource(), conta: c);
      expect(find.text('22 · FLAVIO BOLSONARO'), findsOneWidget);
      expect(find.text('Este é o seu local'), findsOneWidget);
    });

    testWidgets('save the section looked up', (tester) async {
      final source = FakeContaSource(signedIn: true);
      await pumpScreen(tester, FakeSecaoSource(), conta: await conta(source));
      await lookUp77(tester);
      await tester.tap(find.text('Salvar como meu local'));
      await tester.pumpAndSettle();
      expect(source.saved, [('ac', 1066, 4, 77)]);
      expect(find.text('Este é o seu local'), findsOneWidget);
    });

    testWidgets('signed out, saving asks to sign in first', (tester) async {
      final source = FakeContaSource();
      await pumpScreen(tester, FakeSecaoSource(), conta: await conta(source));
      await lookUp77(tester);
      await tester.tap(find.text('Salvar como meu local'));
      await tester.pumpAndSettle();
      expect(find.text('[entrar]'), findsOneWidget);
      expect(source.saved, isEmpty);
    });

    testWidgets('without an account there is no save button', (tester) async {
      await pumpScreen(tester, FakeSecaoSource());
      await lookUp77(tester);
      expect(find.text('Salvar como meu local'), findsNothing);
    });
  });
}

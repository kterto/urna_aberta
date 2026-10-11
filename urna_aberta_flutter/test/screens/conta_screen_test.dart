import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_flutter/conta/conta_controller.dart';
import 'package:urna_aberta_flutter/screens/conta_screen.dart';

import '../conta/fake_conta_source.dart';
import '../support/test_app.dart';

Future<FakeContaSource> pumpConta(
  WidgetTester tester,
  FakeContaSource source, {
  Locale locale = const Locale('pt'),
  VoidCallback? onChoose,
}) async {
  final conta = ContaController(source);
  await conta.start();
  await tester.pumpWidget(
    testApp(
      locale: locale,
      conta: conta,
      home: ContaScreen(onChoose: onChoose),
    ),
  );
  await tester.pumpAndSettle();
  return source;
}

void main() {
  testWidgets('signed out: the sign-in form and what is kept', (tester) async {
    await pumpConta(tester, FakeContaSource());
    expect(find.text('[entrar]'), findsOneWidget);
    expect(find.textContaining('Guardamos só o local'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('signing in shows the saved place', (tester) async {
    final source = await pumpConta(
      tester,
      FakeContaSource(place: portoWalter()),
    );
    source.signIn();
    await tester.pumpAndSettle();
    expect(find.text('PORTO WALTER (AC)'), findsOneWidget);
    expect(find.text('Zona 4 · Seção 77'), findsOneWidget);
  });

  testWidgets('no place yet says how to save one', (tester) async {
    var chose = false;
    await pumpConta(
      tester,
      FakeContaSource(signedIn: true),
      onChoose: () => chose = true,
    );
    expect(find.textContaining('ainda não salvou'), findsOneWidget);
    expect(find.text('Apagar meu local'), findsNothing);
    await tester.tap(find.text('Escolher em Minha seção'));
    await tester.pumpAndSettle();
    expect(chose, isTrue);
  });

  testWidgets('delete the place', (tester) async {
    final source = await pumpConta(
      tester,
      FakeContaSource(signedIn: true, place: portoWalter()),
    );
    await tester.tap(find.text('Apagar meu local'));
    await tester.pumpAndSettle();
    expect(source.place, isNull);
    expect(find.text('Local apagado.'), findsOneWidget);
    expect(find.textContaining('ainda não salvou'), findsOneWidget);
  });

  testWidgets('sign out', (tester) async {
    await pumpConta(
      tester,
      FakeContaSource(signedIn: true, place: portoWalter()),
    );
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    expect(find.text('[entrar]'), findsOneWidget);
  });

  testWidgets('a municipality alone', (tester) async {
    await pumpConta(
      tester,
      FakeContaSource(
        signedIn: true,
        place: portoWalter(zona: null, secao: null),
      ),
      locale: const Locale('en'),
    );
    expect(find.text('PORTO WALTER (AC)'), findsOneWidget);
    expect(find.textContaining('Zone'), findsNothing);
    expect(find.text('Delete my place'), findsOneWidget);
  });
}

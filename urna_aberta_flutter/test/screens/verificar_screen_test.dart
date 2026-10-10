import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_flutter/design/theme.dart';
import 'package:urna_aberta_flutter/screens/verificar_screen.dart';
import 'package:urna_aberta_flutter/verificar/verificar_controller.dart';

import '../verificar/fake_verificar_source.dart';

Future<void> pumpScreen(
  WidgetTester tester,
  FakeVerificarSource source, {
  Size size = const Size(1300, 3000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: atlasTheme(Brightness.light),
      home: VerificarScope(
        source: source,
        child: const Scaffold(body: VerificarScreen()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('lists the stored files with the server result', (tester) async {
    await pumpScreen(tester, FakeVerificarSource());
    expect(find.text('Presidente · 3 arquivos'), findsOneWidget);
    expect(find.text('Brasil'), findsOneWidget);
    expect(find.text('Acre'), findsOneWidget);
    expect(find.text('br-c0001-e006257-u.jws'), findsOneWidget);
    expect(find.text('Assinatura válida'), findsNWidgets(3 + 1));
    expect(find.text('Não conferido'), findsNWidgets(3 + 1));
  });

  testWidgets('checks on the device and flags the swapped file', (
    tester,
  ) async {
    await pumpScreen(tester, FakeVerificarSource());
    await tester.tap(find.text('Conferir neste aparelho'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 2)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Outro arquivo'), findsNWidgets(1 + 1));
    expect(find.textContaining('Um arquivo não confere'), findsOneWidget);
    expect(find.text('Todos conferidos neste aparelho'), findsOneWidget);
  });

  testWidgets('a phone shows where each result comes from', (tester) async {
    await pumpScreen(
      tester,
      FakeVerificarSource(),
      size: const Size(390, 4000),
    );
    expect(find.text('Servidor: assinatura válida'), findsNWidgets(3));
    expect(find.text('Aparelho: não conferido'), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('server down: a message and a retry', (tester) async {
    final source = FakeVerificarSource()..fail = StateError('offline');
    await pumpScreen(tester, source);
    expect(find.textContaining('Não foi possível falar'), findsOneWidget);
    source.fail = null;
    await tester.tap(find.text('Tentar de novo'));
    await tester.pumpAndSettle();
    expect(find.text('Brasil'), findsOneWidget);
  });
}

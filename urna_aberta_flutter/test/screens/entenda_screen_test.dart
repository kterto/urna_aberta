import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_flutter/screens/entenda_screen.dart';

import '../support/test_app.dart';

Future<void> pumpEntenda(WidgetTester tester, Locale locale, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    testApp(
      locale: locale,
      home: const Scaffold(body: EntendaScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final size in const [Size(1300, 2400), Size(390, 2400)]) {
    final w = size.width.toInt();

    testWidgets('Portuguese chapter index ($w px)', (tester) async {
      await pumpEntenda(tester, const Locale('pt'), size);
      expect(find.text('Entenda o processo'), findsWidgets);
      expect(find.text('O que este app prova'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('English chapter index ($w px)', (tester) async {
      await pumpEntenda(tester, const Locale('en'), size);
      expect(find.text('Understand the process'), findsWidgets);
      expect(find.text('What this app proves'), findsOneWidget);
      expect(find.text('Entenda o processo'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('English pause chapter ($w px)', (tester) async {
      await pumpEntenda(tester, const Locale('en'), size);
      await tester.tap(find.text('October 4, 2026'));
      await tester.pumpAndSettle();
      expect(find.text('Chapter 6'), findsOneWidget);
      expect(find.textContaining('64.81%'), findsOneWidget);
      expect(find.text('Sources'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

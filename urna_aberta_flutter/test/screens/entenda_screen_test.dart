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

    testWidgets('how seats are distributed, sourced ($w px)', (tester) async {
      await pumpEntenda(tester, const Locale('pt'), size);
      await tester.tap(find.text('Como as vagas são distribuídas'));
      await tester.pumpAndSettle();
      expect(find.text('Capítulo 7'), findsOneWidget);
      expect(find.textContaining('10% do quociente eleitoral'), findsOneWidget);
      expect(find.textContaining('80%'), findsOneWidget);
      expect(find.textContaining('STF'), findsWidgets);
      expect(find.textContaining('Código Eleitoral'), findsWidgets);
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

    testWidgets('pause chapter follows TSE\'s note ($w px)', (tester) async {
      await pumpEntenda(tester, const Locale('pt'), size);
      await tester.tap(find.text('4 de outubro de 2026'));
      await tester.pumpAndSettle();
      // TSE, Fato ou Boato, 06/10/2026: 19:14 to 20:04, at 64.81%.
      expect(find.textContaining('19h14'), findsOneWidget);
      expect(find.textContaining('20h04'), findsOneWidget);
      expect(
        find.textContaining('exceto por um breve momento'),
        findsOneWidget,
      );
      expect(find.textContaining('84%'), findsNothing);
      expect(find.textContaining('Fato ou Boato'), findsOneWidget);
      expect(
        find.text('Rascunho · revisar fontes'.toUpperCase()),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });

    for (final locale in const [Locale('pt'), Locale('en')]) {
      for (var n = 1; n <= 8; n++) {
        testWidgets(
          'chapter $n is written and sourced (${locale.languageCode}, $w px)',
          (tester) async {
            await pumpEntenda(tester, locale, size);
            await tester.tap(find.byIcon(Icons.chevron_right).at(n - 1));
            await tester.pumpAndSettle();
            final pt = locale.languageCode == 'pt';
            expect(
              find.text(pt ? 'Capítulo $n' : 'Chapter $n'),
              findsOneWidget,
            );
            expect(
              find.textContaining(pt ? 'em produção' : 'being written'),
              findsNothing,
            );
            expect(
              find.text(
                (pt
                        ? 'Rascunho · revisar fontes'
                        : 'Draft · sources under review')
                    .toUpperCase(),
              ),
              findsNothing,
            );
            expect(find.byType(TextButton), findsAtLeastNWidgets(1));
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}

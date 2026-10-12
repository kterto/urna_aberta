import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_flutter/design/widgets/atlas_page.dart';

import '../support/test_app.dart';

void main() {
  Future<void> pull(WidgetTester tester) async {
    await tester.fling(find.text('Conteúdo'), const Offset(0, 400), 1000);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'pulling a short page down from the top reloads it',
    (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var refreshed = 0;
      await tester.pumpWidget(
        testApp(
          home: Scaffold(
            body: AtlasPage(
              title: 'Página',
              onRefresh: () async => refreshed++,
              children: const [Text('Conteúdo')],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await pull(tester);
      expect(refreshed, 1);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  testWidgets('a page with nothing to reload cannot be pulled', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        home: const Scaffold(
          body: AtlasPage(title: 'Página', children: [Text('Conteúdo')]),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(RefreshIndicator), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_flutter/app/app.dart';
import 'package:urna_aberta_flutter/app/router.dart';
import 'package:urna_aberta_flutter/l10n/l10n.dart';
import 'package:urna_aberta_flutter/design/geo/brasil_geo.dart';
import 'package:urna_aberta_flutter/design/tokens.dart';
import 'package:urna_aberta_flutter/replay/replay_controller.dart';
import 'package:urna_aberta_flutter/resultados/resultados_controller.dart';

import 'package:urna_aberta_flutter/secao/secao_controller.dart';
import 'package:urna_aberta_flutter/verificar/verificar_controller.dart';

import 'screens/apuracao_screen_test.dart' show StubSource;
import 'resultados/fake_resultados_source.dart';
import 'secao/fake_secao_source.dart';
import 'verificar/fake_verificar_source.dart';
import 'support/test_app.dart';

Widget _app(Brightness b) => TallyScope(
  source: StubSource(),
  child: SecaoScope(
    source: FakeSecaoSource(),
    child: VerificarScope(
      source: FakeVerificarSource(),
      child: ResultadosScope(
        source: FakeResultadosSource(),
        child: testApp(brightness: b, router: appRouter()),
      ),
    ),
  ),
);

void main() {
  test('totalization ramp has five 20-point classes', () {
    const p = AtlasPalette.light;
    expect(p.totalizacao(0), p.totalizacaoRamp[0]);
    expect(p.totalizacao(19.9), p.totalizacaoRamp[0]);
    expect(p.totalizacao(20), p.totalizacaoRamp[1]);
    expect(p.totalizacao(100), p.totalizacaoRamp[4]);
  });

  testWidgets('IBGE geometry loads 27 UFs in five regions', (tester) async {
    final geo = await tester.runAsync(BrasilGeo.load);
    expect(geo!.ufs, hasLength(27));
    expect(geo.regionPaths.keys.toSet(), Regiao.values.toSet());
    expect(geo.bySigla('BA').regiao, Regiao.nordeste);
    expect(geo.bySigla('DF').regiao, Regiao.centroOeste);
  });

  for (final b in Brightness.values) {
    testWidgets('shell renders and navigates (${b.name})', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(b));
      await tester.pump();
      expect(find.text('Apuração'), findsWidgets);
      await tester.tap(find.text('Minha seção').last);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Localizar seção'), findsOneWidget);
      await tester.tap(find.text('Verificar').last);
      await tester.pump(const Duration(milliseconds: 500));
      // A section is built the first time it is opened.
      await tester.pump();
      expect(find.text('Conferir neste aparelho'), findsOneWidget);
    });
  }

  testWidgets('the language menu switches the whole app to English', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(() => localeNotifier.value = null);
    localeNotifier.value = const Locale('pt');
    await tester.pumpWidget(
      UrnaAbertaApp(
        tallySource: StubSource(),
        secaoSource: FakeSecaoSource(),
        verificarSource: FakeVerificarSource(),
        resultadosSource: FakeResultadosSource(),
      ),
    );
    await tester.pump();
    expect(find.text('Minha seção'), findsWidgets);
    await tester.tap(find.byTooltip('Idioma').first);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.widgetWithText(CheckedPopupMenuItem<int>, 'English'));
    await tester.pump(const Duration(milliseconds: 600));
    expect(localeNotifier.value, const Locale('en'));
    expect(find.text('My section'), findsWidgets);
    expect(find.text('Minha seção'), findsNothing);
  });
}

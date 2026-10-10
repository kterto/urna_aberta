import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_flutter/app/shell.dart';
import 'package:urna_aberta_flutter/design/geo/brasil_geo.dart';
import 'package:urna_aberta_flutter/design/theme.dart';
import 'package:urna_aberta_flutter/design/tokens.dart';
import 'package:urna_aberta_flutter/replay/replay_controller.dart';

import 'package:urna_aberta_flutter/secao/secao_controller.dart';
import 'package:urna_aberta_flutter/verificar/verificar_controller.dart';

import 'screens/apuracao_screen_test.dart' show StubSource;
import 'secao/fake_secao_source.dart';
import 'verificar/fake_verificar_source.dart';

Widget _app(Brightness b) => TallyScope(
  source: StubSource(),
  child: SecaoScope(
    source: FakeSecaoSource(),
    child: VerificarScope(
      source: FakeVerificarSource(),
      child: MaterialApp(theme: atlasTheme(b), home: const AppShell()),
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
      expect(find.text('Conferir neste aparelho'), findsOneWidget);
    });
  }
}

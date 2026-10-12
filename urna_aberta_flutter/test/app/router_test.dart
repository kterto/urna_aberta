import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:urna_aberta_flutter/app/router.dart';
import 'package:urna_aberta_flutter/conta/conta_controller.dart';
import 'package:urna_aberta_flutter/replay/replay_controller.dart';
import 'package:urna_aberta_flutter/resultados/resultados_controller.dart';
import 'package:urna_aberta_flutter/secao/secao_controller.dart';
import 'package:urna_aberta_flutter/verificar/verificar_controller.dart';

import '../conta/fake_conta_source.dart';
import '../relatorios/fake_relatorios_source.dart';
import '../resultados/fake_resultados_source.dart';
import '../screens/apuracao_screen_test.dart' show StubSource;
import '../secao/fake_secao_source.dart';
import '../support/test_app.dart';
import '../verificar/fake_verificar_source.dart';

void main() {
  late GoRouter router;
  late FakeRelatoriosSource reports;

  /// The app opened at [location], as a refresh or a shared link does.
  Future<void> open(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final conta = ContaController(FakeContaSource(signedIn: true));
    await conta.start();
    reports = FakeRelatoriosSource()
      ..reports = [sampleRequest(id: 7), sampleRequest(id: 8)];
    router = appRouter(initialLocation: location);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      TallyScope(
        source: StubSource(),
        child: SecaoScope(
          source: FakeSecaoSource(),
          child: VerificarScope(
            source: FakeVerificarSource(),
            child: ResultadosScope(
              source: FakeResultadosSource(),
              child: testApp(router: router, conta: conta, relatorios: reports),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  String at() => router.state.uri.toString();

  Future<void> back(WidgetTester tester) async {
    await tester.tap(find.byType(BackButton).last);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('a section opens at its address and its tab is selected', (
    tester,
  ) async {
    await open(tester, '/verificar');
    expect(find.text('Conferir neste aparelho'), findsOneWidget);
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 3);
  });

  testWidgets('choosing a section changes the address', (tester) async {
    await open(tester, '/');
    await tester.tap(find.text('Minha seção').last);
    await tester.pump();
    expect(at(), '/secao');
  });

  testWidgets('Meus relatórios opens at its address; back goes home', (
    tester,
  ) async {
    await open(tester, '/relatorios');
    expect(find.text('Meus relatórios'), findsWidgets);
    await back(tester);
    expect(at(), '/');
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('the marked report is kept in the address', (tester) async {
    await open(tester, '/relatorios?destaque=8');
    expect(find.text('Meus relatórios'), findsWidgets);
    expect(at(), '/relatorios?destaque=8');
  });

  testWidgets('Novo relatório opens empty; back goes to Meus relatórios', (
    tester,
  ) async {
    await open(tester, '/relatorios/novo');
    expect(find.text('Novo relatório'), findsWidgets);
    await back(tester);
    expect(at(), '/relatorios');
    expect(find.text('Meus relatórios'), findsWidgets);
  });

  testWidgets('Meu local opened from a section goes back to it', (
    tester,
  ) async {
    await open(tester, '/resultados');
    router.push(Paths.conta);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(at(), '/conta');
    await back(tester);
    expect(at(), '/resultados');
  });

  testWidgets('a chapter opens over Entenda; back goes to the index', (
    tester,
  ) async {
    await open(tester, '/entenda/2');
    expect(find.text('Capítulo 2'), findsOneWidget);
    await back(tester);
    expect(at(), '/entenda');
    expect(find.text('O que este app prova'), findsOneWidget);
  });

  testWidgets('an address that names nothing goes to the nearest screen', (
    tester,
  ) async {
    await open(tester, '/entenda/99');
    expect(at(), '/entenda');
    await open(tester, '/nada');
    expect(at(), '/');
  });
}

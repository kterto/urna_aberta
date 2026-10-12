import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../relatorios/novo_relatorio_controller.dart';
import '../screens/apuracao_screen.dart';
import '../screens/conta_screen.dart';
import '../screens/entenda_screen.dart';
import '../screens/meus_relatorios_screen.dart';
import '../screens/novo_relatorio_screen.dart';
import '../screens/resultados_screen.dart';
import '../screens/secao_screen.dart';
import '../screens/verificar_screen.dart';
import 'shell.dart';

/// Where each screen lives in the address bar (under the `/app/` base on
/// the web), so a refresh or a shared link opens the same screen.
abstract final class Paths {
  /// The sections, in [Section] order.
  static const sections = [
    '/',
    '/resultados',
    '/secao',
    '/verificar',
    '/entenda',
  ];

  static const conta = '/conta';
  static const relatorios = '/relatorios';
  static const novoRelatorio = '/relatorios/novo';

  /// Entenda's chapter [index], counted from 0; the address counts from 1.
  static String chapter(int index) => '/entenda/${index + 1}';

  /// Meus relatórios with report [id] shown first and marked.
  static String relatorio(int id) => '$relatorios?destaque=$id';
}

/// Pages opened over the sections, from anywhere: pushed, so the section
/// underneath keeps its state.
final pageRoutes = <RouteBase>[
  GoRoute(path: Paths.conta, builder: (_, _) => const ContaScreen()),
  GoRoute(
    path: Paths.relatorios,
    builder: (_, state) => MeusRelatoriosScreen(
      highlight: int.tryParse(state.uri.queryParameters['destaque'] ?? ''),
    ),
    routes: [
      GoRoute(
        path: 'novo',
        // A draft comes from the screen that opened it; a refresh starts
        // an empty one.
        builder: (_, state) => NovoRelatorioScreen(
          draft: state.extra is ReportDraft
              ? state.extra! as ReportDraft
              : const ReportDraft(),
        ),
      ),
    ],
  ),
];

/// Entenda's chapter, under `/entenda`; [parent] shows it over the shell.
GoRoute chapterRoute({GlobalKey<NavigatorState>? parent}) => GoRoute(
  path: ':capitulo',
  parentNavigatorKey: parent,
  redirect: (_, state) {
    final n = int.tryParse(state.pathParameters['capitulo']!);
    return n == null || n < 1 || n > EntendaScreen.chapters
        ? Paths.sections[Section.entenda]
        : null;
  },
  builder: (_, state) => EntendaChapterScreen(
    index: int.parse(state.pathParameters['capitulo']!) - 1,
  ),
);

/// The app's routes: the five sections, each keeping its own state, and
/// the pages over them.
GoRouter appRouter({String? initialLocation}) {
  // Pushed pages show in the address bar too.
  GoRouter.optionURLReflectsImperativeAPIs = true;
  final root = GlobalKey<NavigatorState>();
  Widget Function(BuildContext, GoRouterState) screen(Widget w) =>
      (_, _) => w;
  return GoRouter(
    navigatorKey: root,
    initialLocation: initialLocation,
    onException: (_, _, router) => router.go(Paths.sections.first),
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          for (final (path, page) in [
            (Paths.sections[Section.apuracao], const ApuracaoScreen()),
            (Paths.sections[Section.resultados], const ResultadosScreen()),
            (Paths.sections[Section.secao], const SecaoScreen()),
            (Paths.sections[Section.verificar], const VerificarScreen()),
          ])
            StatefulShellBranch(
              routes: [GoRoute(path: path, builder: screen(page))],
            ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Paths.sections[Section.entenda],
                builder: screen(const EntendaScreen()),
                routes: [
                  chapterRoute(parent: root),
                ],
              ),
            ],
          ),
        ],
      ),
      ...pageRoutes,
    ],
  );
}

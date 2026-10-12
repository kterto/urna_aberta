import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:urna_aberta_flutter/app/router.dart';
import 'package:urna_aberta_flutter/app/shell.dart';
import 'package:urna_aberta_flutter/conta/conta_controller.dart';
import 'package:urna_aberta_flutter/design/theme.dart';
import 'package:urna_aberta_flutter/l10n/l10n.dart';
import 'package:urna_aberta_flutter/relatorios/relatorios_source.dart';

/// The app's theme and localizations around [home] at `/`, with the app's
/// pages over it and each other section a stand-in naming its path;
/// Portuguese by default. [router] replaces all of that (the whole app's
/// routes, say). With [conta] or [relatorios], they are provided as in the
/// app.
Widget testApp({
  Widget? home,
  GoRouter? router,
  Brightness brightness = Brightness.light,
  Locale locale = const Locale('pt'),
  ContaController? conta,
  RelatoriosSource? relatorios,
}) => MaterialApp.router(
  routerConfig:
      router ??
      GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => home!),
          for (final path in Paths.sections.skip(1))
            GoRoute(
              path: path,
              builder: (_, _) => Text('section $path'),
              routes: [
                if (path == Paths.sections[Section.entenda]) chapterRoute(),
              ],
            ),
          ...pageRoutes,
        ],
      ),
  theme: atlasTheme(brightness),
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  builder: (context, child) {
    var app = child!;
    if (relatorios != null) {
      app = RelatoriosScope(source: relatorios, child: app);
    }
    return conta == null ? app : ContaScope(controller: conta, child: app);
  },
);

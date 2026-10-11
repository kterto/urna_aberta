import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../conta/conta_controller.dart';
import '../design/theme.dart';
import '../l10n/l10n.dart';
import '../relatorios/relatorios_source.dart';
import '../replay/replay_controller.dart';
import '../resultados/resultados_controller.dart';
import '../secao/secao_controller.dart';
import '../verificar/verificar_controller.dart';
import 'shell.dart';

/// Theme choice: follows the system by default; the web masthead can pin it.
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

class UrnaAbertaApp extends StatelessWidget {
  const UrnaAbertaApp({
    super.key,
    required this.tallySource,
    required this.secaoSource,
    required this.verificarSource,
    required this.resultadosSource,
    this.conta,
    this.relatoriosSource,
  });

  final TallySource tallySource;
  final SecaoSource secaoSource;
  final VerificarSource verificarSource;
  final ResultadosSource resultadosSource;

  /// The viewer's account; none in builds without sign-in.
  final ContaController? conta;

  /// Reports; their screens and buttons are hidden without it.
  final RelatoriosSource? relatoriosSource;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeModeNotifier, localeNotifier]),
      builder: (context, _) => TallyScope(
        source: tallySource,
        child: SecaoScope(
          source: secaoSource,
          child: VerificarScope(
            source: verificarSource,
            child: ResultadosScope(
              source: resultadosSource,
              child: MaterialApp(
                title: 'Urna Aberta',
                locale: localeNotifier.value,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                theme: atlasTheme(Brightness.light),
                darkTheme: atlasTheme(Brightness.dark),
                themeMode: themeModeNotifier.value,
                home: const AppShell(),
                builder: (context, child) {
                  var app = child!;
                  if (relatoriosSource case final source?) {
                    app = RelatoriosScope(source: source, child: app);
                  }
                  return conta == null
                      ? app
                      : ContaScope(controller: conta!, child: app);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

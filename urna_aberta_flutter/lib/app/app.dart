import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../design/theme.dart';
import '../l10n/l10n.dart';
import '../replay/replay_controller.dart';
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
  });

  final TallySource tallySource;
  final SecaoSource secaoSource;
  final VerificarSource verificarSource;

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
            ),
          ),
        ),
      ),
    );
  }
}

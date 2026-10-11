import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:urna_aberta_flutter/conta/conta_controller.dart';
import 'package:urna_aberta_flutter/design/theme.dart';
import 'package:urna_aberta_flutter/l10n/l10n.dart';
import 'package:urna_aberta_flutter/relatorios/relatorios_source.dart';

/// The app's theme and localizations around [home]; Portuguese by default.
/// With [conta] or [relatorios], they are provided as in the app.
Widget testApp({
  required Widget home,
  Brightness brightness = Brightness.light,
  Locale locale = const Locale('pt'),
  ContaController? conta,
  RelatoriosSource? relatorios,
}) => MaterialApp(
  theme: atlasTheme(brightness),
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  home: home,
  builder: (context, child) {
    var app = child!;
    if (relatorios != null) {
      app = RelatoriosScope(source: relatorios, child: app);
    }
    return conta == null ? app : ContaScope(controller: conta, child: app);
  },
);

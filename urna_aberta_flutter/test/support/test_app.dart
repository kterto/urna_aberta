import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:urna_aberta_flutter/design/theme.dart';
import 'package:urna_aberta_flutter/l10n/l10n.dart';

/// The app's theme and localizations around [home]; Portuguese by default.
Widget testApp({
  required Widget home,
  Brightness brightness = Brightness.light,
  Locale locale = const Locale('pt'),
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
);

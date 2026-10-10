import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../design/theme.dart';
import '../l10n/l10n.dart';
import 'design_system_screen.dart';

/// Design-system gallery, kept out of the app: `flutter run -t lib/showcase/main.dart`.
void main() => runApp(
  MaterialApp(
    title: 'Urna Aberta · Sistema',
    locale: const Locale('pt'),
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
    home: const DesignSystemScreen(),
  ),
);

import 'package:flutter/material.dart';

import '../design/theme.dart';
import '../replay/replay_controller.dart';
import 'shell.dart';

/// Theme choice: follows the system by default; the web masthead can pin it.
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

class UrnaAbertaApp extends StatelessWidget {
  const UrnaAbertaApp({super.key, required this.tallySource});

  final TallySource tallySource;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) => TallyScope(
        source: tallySource,
        child: MaterialApp(
          title: 'Urna Aberta',
          debugShowCheckedModeBanner: false,
          theme: atlasTheme(Brightness.light),
          darkTheme: atlasTheme(Brightness.dark),
          themeMode: mode,
          home: const AppShell(),
        ),
      ),
    );
  }
}

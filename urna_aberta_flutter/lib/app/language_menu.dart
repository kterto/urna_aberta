import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../design/platform.dart';
import '../l10n/l10n.dart';

/// Language choice for app bars: an action sheet on iOS, a menu elsewhere.
class LanguageMenu extends StatelessWidget {
  const LanguageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = <(Locale?, String)>[
      (null, l.languageDevice),
      (const Locale('pt'), l.languagePortuguese),
      (const Locale('en'), l.languageEnglish),
    ];
    final icon = Icon(AtlasIcons.language(context));
    if (shellKindOf(context) == ShellKind.ios) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => showCupertinoModalPopup<void>(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
            title: Text(l.language),
            actions: [
              for (final (locale, label) in options)
                CupertinoActionSheetAction(
                  isDefaultAction: localeNotifier.value == locale,
                  onPressed: () {
                    localeNotifier.value = locale;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(label),
                ),
            ],
          ),
        ),
        child: Semantics(label: l.language, child: icon),
      );
    }
    return PopupMenuButton<int>(
      tooltip: l.language,
      icon: icon,
      onSelected: (i) => localeNotifier.value = options[i].$1,
      itemBuilder: (_) => [
        for (final (i, (locale, label)) in options.indexed)
          CheckedPopupMenuItem(
            value: i,
            checked: localeNotifier.value == locale,
            child: Text(label),
          ),
      ],
    );
  }
}

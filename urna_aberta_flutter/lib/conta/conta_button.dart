import 'package:flutter/material.dart';

import '../app/shell.dart';
import '../design/platform.dart';
import '../design/tokens.dart';
import '../l10n/l10n.dart';
import '../screens/conta_screen.dart';
import 'conta_controller.dart';

/// Opens Meu local. On the web masthead it names the saved municipality, or
/// offers to sign in; in app bars it is an icon.
class ContaButton extends StatelessWidget {
  const ContaButton({super.key, this.onShell = false});

  final bool onShell;

  @override
  Widget build(BuildContext context) {
    final conta = ContaScope.maybeOf(context);
    final route = ModalRoute.of(context)?.settings.name;
    if (conta == null || route == ContaScreen.routeName) {
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    final go = ShellScope.of(context)?.go;
    void open() => ContaScreen.open(
      context,
      onChoose: go == null ? null : () => go(Section.secao),
    );
    final label = !conta.signedIn
        ? l.contaSignIn
        : conta.place?.municipioNome ?? l.contaTitle;
    if (!onShell) {
      return IconButton(
        tooltip: label,
        icon: Icon(AtlasIcons.account(context)),
        onPressed: open,
      );
    }
    final p = context.atlas;
    return TextButton.icon(
      onPressed: open,
      style: TextButton.styleFrom(
        foregroundColor: p.onShellMuted,
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      icon: Icon(AtlasIcons.account(context), size: 18),
      label: Text(label, overflow: TextOverflow.ellipsis),
    );
  }
}

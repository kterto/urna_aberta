import 'package:flutter/material.dart';

import '../conta/conta_controller.dart';
import '../design/tokens.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../l10n/l10n.dart';

/// Meu local: sign in, see and delete the saved polling place.
class ContaScreen extends StatelessWidget {
  const ContaScreen({super.key, this.onChoose});

  static const routeName = '/conta';

  /// Goes to Minha seção to pick the place.
  final VoidCallback? onChoose;

  static Future<void> open(BuildContext context, {VoidCallback? onChoose}) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          settings: const RouteSettings(name: routeName),
          builder: (_) => ContaScreen(onChoose: onChoose),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final conta = ContaScope.of(context);
    final l = context.l10n;
    return Scaffold(
      body: AtlasPage(
        title: l.contaTitle,
        lede: conta.signedIn ? null : l.contaLede,
        maxWidth: 680,
        showBack: true,
        children: [
          if (!conta.signedIn) _signIn(context, conta) else _place(context),
        ],
      ),
    );
  }

  Widget _signIn(BuildContext context, ContaController conta) {
    final l = context.l10n;
    return Plate(
      title: l.contaSignIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          conta.source.signInForm(context),
          const SizedBox(height: Space.x4),
          _Muted(l.contaPrivacy),
        ],
      ),
    );
  }

  Widget _place(BuildContext context) {
    final conta = ContaScope.of(context);
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final place = conta.place;
    return Plate(
      title: l.contaPlacePlate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (conta.error != null)
            Text(l.contaLoadError, style: t.bodyMedium)
          else if (place == null)
            Text(l.contaNoPlace, style: t.bodyMedium)
          else ...[
            Text(
              l.contaPlaceMunicipio(
                place.municipioNome,
                place.uf.toUpperCase(),
              ),
              style: t.titleLarge,
            ),
            if (place.zona != null) ...[
              const SizedBox(height: Space.x1),
              Text(
                place.secao == null
                    ? l.contaPlaceZona('${place.zona}')
                    : l.contaPlaceSecao('${place.zona}', '${place.secao}'),
                style: t.bodyMedium,
              ),
            ],
          ],
          const SizedBox(height: Space.x4),
          Wrap(
            spacing: Space.x3,
            runSpacing: Space.x2,
            children: [
              if (onChoose != null)
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onChoose!();
                  },
                  child: Text(l.contaChoose),
                ),
              if (place != null)
                OutlinedButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await conta.apagar();
                    messenger.showSnackBar(
                      SnackBar(content: Text(l.contaDeleted)),
                    );
                  },
                  child: Text(l.contaDelete),
                ),
              TextButton(onPressed: conta.sair, child: Text(l.contaSignOut)),
            ],
          ),
          const SizedBox(height: Space.x4),
          _Muted(l.contaPrivacy),
        ],
      ),
    );
  }
}

class _Muted extends StatelessWidget {
  const _Muted(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: context.atlas.inkMuted),
  );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router.dart';
import '../app/shell.dart';
import '../conta/conta_controller.dart';
import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../l10n/l10n.dart';
import '../relatorios/relatorios_source.dart';
import 'meus_relatorios_screen.dart';
import 'novo_relatorio_screen.dart';

/// Meu local: sign in, see and delete the saved polling place.
class ContaScreen extends StatelessWidget {
  const ContaScreen({super.key});

  static const routeName = Paths.conta;

  static Future<void> open(BuildContext context) =>
      context.push<void>(Paths.conta);

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
          if (conta.signedIn && RelatoriosScope.maybeOf(context) != null) ...[
            const SizedBox(height: Space.x4),
            _reports(context),
          ],
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
              FilledButton(
                onPressed: () => context.go(Paths.sections[Section.secao]),
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

Widget _reports(BuildContext context) {
  final l = context.l10n;
  return Plate(
    title: l.relatoriosPlate,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.relatoriosPlateBody),
        const SizedBox(height: Space.x4),
        Wrap(
          spacing: Space.x3,
          runSpacing: Space.x2,
          children: [
            FilledButton.icon(
              onPressed: () => NovoRelatorioScreen.open(context),
              icon: Icon(AtlasIcons.report(context), size: 18),
              label: Text(l.relatoriosNew),
            ),
            OutlinedButton(
              onPressed: () => MeusRelatoriosScreen.push(context),
              child: Text(l.relatoriosMine),
            ),
          ],
        ),
      ],
    ),
  );
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

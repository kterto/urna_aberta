import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import '../design/geo/uf_nomes.dart';
import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../replay/replay_controller.dart' show brasilia;
import '../verificar/device_check.dart';
import '../verificar/verificar_controller.dart';

/// Signature status of every stored TSE result file, checked by the server
/// and, on request, again on this device with the key the app carries.
class VerificarScreen extends StatefulWidget {
  const VerificarScreen({super.key});

  @override
  State<VerificarScreen> createState() => _VerificarScreenState();
}

class _VerificarScreenState extends State<VerificarScreen> {
  VerificarController? _c;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _c ??= VerificarController(VerificarScope.of(context))..load();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _c!;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) => AtlasPage(
        title: 'Verificar',
        lede:
            'O TSE assina cada arquivo de resultado que publica. A Urna Aberta confere a assinatura ao guardar o arquivo, e este aparelho pode conferir de novo por conta própria, sem confiar no nosso servidor.',
        maxWidth: 1040,
        children: [
          if (c.files case final files?) ...[
            _Summary(controller: c, files: files),
            const SizedBox(height: Space.x5),
            for (final (code, nome) in const [
              (1, 'Presidente'),
              (3, 'Governador'),
              (5, 'Senador'),
            ])
              if (_byName(files.where((f) => f.officeCode == code))
                  case final group when group.isNotEmpty) ...[
                _FilesPlate(title: nome, files: group, controller: c),
                const SizedBox(height: Space.x5),
              ],
            const _YourselfPlate(),
            const SizedBox(height: Space.x5),
            const _MeaningPlate(),
          ] else if (c.error != null)
            _LoadError(onRetry: c.load)
          else
            const Padding(
              padding: EdgeInsets.all(Space.x6),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

/// Brasil first, then UFs by name, exterior last.
List<FileVerification> _byName(Iterable<FileVerification> files) {
  int rank(String c) => switch (c) {
    'br' => 0,
    'zz' => 2,
    _ => 1,
  };
  return files.toList()..sort((a, b) {
    final r = rank(a.scopeCode).compareTo(rank(b.scopeCode));
    return r != 0
        ? r
        : scopeNome(a.scopeCode).compareTo(scopeNome(b.scopeCode));
  });
}

String _when(DateTime utc) {
  final b = brasilia(utc);
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(b.day)}/${two(b.month)} ${two(b.hour)}:${two(b.minute)}';
}

class _Summary extends StatelessWidget {
  const _Summary({required this.controller, required this.files});

  final VerificarController controller;
  final List<FileVerification> files;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    final serverValid = files
        .where((f) => f.signature == SignatureStatus.valid)
        .length;
    final deviceValid = files
        .where((f) => c.deviceResult(f.snapshotId) == DeviceCheck.valid)
        .length;
    final deviceBad = files.where((f) {
      final r = c.deviceResult(f.snapshotId);
      return r != null && r != DeviceCheck.valid;
    }).length;
    final allChecked = c.checkedCount == files.length;

    Widget figure(String value, String label) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: t.headlineMedium),
        Text(label, style: t.bodySmall?.copyWith(color: p.inkSecondary)),
      ],
    );

    return Plate(
      title: 'Assinaturas dos arquivos de resultado',
      fonte: const FonteLine(
        plateNumber: 11,
        source:
            'Assinatura JWS (EdDSA, Ed25519) conforme o Manual de verificação dos arquivos JWS do TSE. Chave pública do ambiente oficial, Apêndice B.',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: Space.x6,
            runSpacing: Space.x4,
            children: [
              figure('${files.length}', 'arquivos guardados'),
              figure('$serverValid', 'válidos no servidor'),
              figure(
                '$deviceValid',
                allChecked ? 'válidos neste aparelho' : 'conferidos aqui',
              ),
            ],
          ),
          const SizedBox(height: Space.x4),
          if (deviceBad > 0) ...[
            Text(
              deviceBad == 1
                  ? 'Um arquivo não confere neste aparelho. Não use os números dele.'
                  : '$deviceBad arquivos não conferem neste aparelho. Não use os números deles.',
              style: t.bodyMedium?.copyWith(
                color: p.status(VerificationStatus.invalid),
              ),
            ),
            const SizedBox(height: Space.x3),
          ],
          Row(
            children: [
              Flexible(
                child: FilledButton(
                  onPressed: c.checkingAll || allChecked ? null : c.checkAll,
                  child: Text(
                    allChecked
                        ? 'Todos conferidos neste aparelho'
                        : 'Conferir neste aparelho',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (c.checkingAll) ...[
                const SizedBox(width: Space.x3),
                const _Spinner(),
                const SizedBox(width: Space.x2),
                Flexible(
                  flex: 2,
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      'Conferindo ${c.checkedCount} de ${files.length}…',
                      style: t.bodySmall?.copyWith(color: p.inkMuted),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: Space.x2),
          Text(
            'Baixa cada arquivo assinado e confere a assinatura com a chave do TSE que vem dentro do app.',
            style: t.bodySmall?.copyWith(color: p.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _FilesPlate extends StatelessWidget {
  const _FilesPlate({
    required this.title,
    required this.files,
    required this.controller,
  });

  final String title;
  final List<FileVerification> files;
  final VerificarController controller;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final wide = isWideLayout(context);
    final generated = files
        .map((f) => f.tseGeneratedAt)
        .reduce(
          (a, b) => a.isAfter(b) ? a : b,
        );
    return Plate(
      title: '$title · ${files.length} arquivos',
      padding: EdgeInsets.zero,
      fonte: FonteLine(
        plateNumber: 12,
        source:
            'Arquivos finais do TSE, o mais recente gerado em ${_when(generated)} (Brasília).',
      ),
      child: Column(
        children: [
          if (wide)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.x4,
                Space.x2,
                Space.x4,
                Space.x2,
              ),
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  for (final h in const ['No servidor', 'Neste aparelho'])
                    SizedBox(
                      width: _badgeColumn,
                      child: Text(
                        h,
                        style: t.labelSmall?.copyWith(color: p.inkMuted),
                      ),
                    ),
                ],
              ),
            ),
          for (final f in files)
            _FileRow(file: f, controller: controller, wide: wide),
        ],
      ),
    );
  }
}

const _badgeColumn = 230.0;

String _cap(String s) => s[0].toUpperCase() + s.substring(1);

class _FileRow extends StatelessWidget {
  const _FileRow({
    required this.file,
    required this.controller,
    required this.wide,
  });

  final FileVerification file;
  final VerificarController controller;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final f = file;
    final name = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(scopeNome(f.scopeCode), style: t.titleSmall),
        const SizedBox(height: Space.x1),
        Wrap(
          spacing: Space.x2,
          runSpacing: Space.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FileCode(f.fileName, url: Uri.parse(f.url)),
            Text(
              'gerado ${_when(f.tseGeneratedAt)}',
              style: t.bodySmall?.copyWith(color: p.inkMuted),
            ),
          ],
        ),
      ],
    );
    final server = _serverBadge(f.signature, wide: wide);
    final device = _deviceBadge(context, wide: wide);
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.rule)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Space.x4,
        vertical: Space.x3,
      ),
      child: wide
          ? Row(
              children: [
                Expanded(child: name),
                SizedBox(
                  width: _badgeColumn,
                  child: Align(alignment: Alignment.centerLeft, child: server),
                ),
                SizedBox(
                  width: _badgeColumn,
                  child: Align(alignment: Alignment.centerLeft, child: device),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                name,
                const SizedBox(height: Space.x2),
                Wrap(
                  spacing: Space.x2,
                  runSpacing: Space.x2,
                  children: [server, device],
                ),
              ],
            ),
    );
  }

  /// On a phone there is no column header, so each badge says where.
  static Widget _serverBadge(SignatureStatus? s, {required bool wide}) {
    String where(String text) => wide ? _cap(text) : 'Servidor: $text';
    return switch (s) {
      SignatureStatus.valid => StatusBadge(
        VerificationStatus.valid,
        label: where('assinatura válida'),
      ),
      SignatureStatus.invalid => StatusBadge(
        VerificationStatus.invalid,
        label: where('assinatura inválida'),
      ),
      SignatureStatus.unknownKey => StatusBadge(
        VerificationStatus.pending,
        label: where('chave desconhecida'),
      ),
      null => StatusBadge(
        VerificationStatus.pending,
        label: where('sem assinatura'),
      ),
    };
  }

  Widget _deviceBadge(BuildContext context, {required bool wide}) {
    final id = file.snapshotId;
    String where(String text) => wide ? _cap(text) : 'Aparelho: $text';
    if (controller.isChecking(id)) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Spinner(),
          const SizedBox(width: Space.x2),
          Text(
            where('conferindo…'),
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: context.atlas.inkMuted),
          ),
        ],
      );
    }
    if (controller.downloadFailed(id)) {
      return StatusBadge(
        VerificationStatus.pending,
        label: where('não foi possível baixar'),
      );
    }
    return switch (controller.deviceResult(id)) {
      DeviceCheck.valid => StatusBadge(
        VerificationStatus.valid,
        label: where('assinatura válida'),
      ),
      DeviceCheck.invalid => StatusBadge(
        VerificationStatus.invalid,
        label: where('assinatura inválida'),
      ),
      DeviceCheck.differentFile => StatusBadge(
        VerificationStatus.invalid,
        label: where('outro arquivo'),
      ),
      DeviceCheck.unknownKey => StatusBadge(
        VerificationStatus.pending,
        label: where('chave desconhecida'),
      ),
      DeviceCheck.unreadable => StatusBadge(
        VerificationStatus.invalid,
        label: where('arquivo ilegível'),
      ),
      null => StatusBadge(
        VerificationStatus.pending,
        label: where('não conferido'),
      ),
    };
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => shellKindOf(context) == ShellKind.ios
      ? const CupertinoActivityIndicator(radius: 8)
      : const SizedBox.square(
          dimension: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
}

/// The same check without Urna Aberta: the key, and a shell recipe that
/// needs only OpenSSL 3.
class _YourselfPlate extends StatelessWidget {
  const _YourselfPlate();

  static const _pem =
      '-----BEGIN PUBLIC KEY-----\n'
      'MCowBQYDK2VwAyEAkWlpNHjuws1csyQZwzn3Fhzbi3RD435RbpThtSr4hMc=\n'
      '-----END PUBLIC KEY-----';

  static const _script = r'''f=br-c0001-e006257-u.jws
b64url() { s=$(tr -d '\n' | tr '_-' '/+'); while [ $(( ${#s} % 4 )) -ne 0 ]; do s="$s="; done; printf '%s' "$s" | base64 -d; }
cut -d. -f1,2 "$f" | tr -d '\n' > assinado.txt
cut -d. -f3 "$f" | b64url > assinatura.bin
openssl pkeyutl -verify -pubin -inkey tse.pem -rawin -in assinado.txt -sigfile assinatura.bin
cut -d. -f2 "$f" | b64url > conteudo.json''';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    Widget step(String n, String text) => Padding(
      padding: const EdgeInsets.only(bottom: Space.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 24, child: Text(n, style: t.titleSmall)),
          Expanded(child: Text(text, style: t.bodyMedium)),
        ],
      ),
    );
    return Plate(
      title: 'Confira você mesmo',
      fonte: const FonteLine(
        plateNumber: 13,
        source:
            'Chave: TSE, Manual de verificação dos arquivos JWS, Apêndice B. Receita testada com OpenSSL 3 em 10/10/2026.',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Não precisa confiar na Urna Aberta. Cada arquivo .jws traz o próprio conteúdo e a assinatura do TSE; com a chave pública abaixo, qualquer computador confere.',
            style: t.bodyMedium,
          ),
          const SizedBox(height: Space.x4),
          HashRow(label: 'Chave (kid)', hash: tseKeyId),
          const SizedBox(height: Space.x2),
          HashRow(label: 'Ed25519 (x)', hash: tsePublicKey),
          const SizedBox(height: Space.x4),
          step(
            '1',
            'Baixe um arquivo .jws pelo link de qualquer linha acima (o mesmo nome do .json, com outra terminação).',
          ),
          step('2', 'Salve a chave abaixo como tse.pem.'),
          step(
            '3',
            'Rode os comandos no terminal. "Signature Verified Successfully" quer dizer que confere; conteudo.json é o arquivo que o TSE assinou.',
          ),
          const SizedBox(height: Space.x2),
          _CodeBlock(label: 'tse.pem', code: _pem),
          const SizedBox(height: Space.x3),
          _CodeBlock(label: 'Terminal (macOS ou Linux)', code: _script),
          const SizedBox(height: Space.x2),
          Text(
            'A chave fica dentro do app e do servidor, nunca é lida do próprio arquivo: uma chave que viesse junto com o arquivo não provaria nada.',
            style: t.bodySmall?.copyWith(color: p.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.label, required this.code});

  final String label;
  final String code;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.plateSunk,
        border: Border.all(color: p.rule),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Space.x3, Space.x1, 0, 0),
            child: Row(
              children: [
                Expanded(child: Text(label, style: t.labelMedium)),
                IconButton(
                  tooltip: 'Copiar',
                  icon: Icon(AtlasIcons.copy(context), size: 18),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    selectionHaptic();
                    if (context.mounted) {
                      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                        const SnackBar(content: Text('Copiado')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(
              Space.x3,
              0,
              Space.x3,
              Space.x3,
            ),
            child: SelectableText(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontFamilyFallback: const ['Menlo', 'Roboto Mono', 'Courier'],
                fontSize: 12.5,
                height: 1.5,
                color: p.inkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeaningPlate extends StatelessWidget {
  const _MeaningPlate();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    return Plate(
      title: 'O que cada estado significa',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (s, label, text) in const [
            (
              VerificationStatus.valid,
              'Assinatura válida',
              'O arquivo é exatamente o que o TSE assinou: veio do TSE e não foi alterado no caminho.',
            ),
            (
              VerificationStatus.invalid,
              'Assinatura inválida',
              'A assinatura não confere com o conteúdo. Não use estes números.',
            ),
            (
              VerificationStatus.invalid,
              'Outro arquivo',
              'A assinatura confere, mas o arquivo não é o que o servidor da Urna Aberta disse ter usado.',
            ),
            (
              VerificationStatus.pending,
              'Não conferido',
              'Este aparelho ainda não conferiu o arquivo. O resultado do servidor continua valendo, mas depende de você confiar nele.',
            ),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: Space.x3),
              child: Wrap(
                spacing: Space.x3,
                runSpacing: Space.x1,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 190,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: StatusBadge(s, label: label),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(text, style: t.bodyMedium),
                  ),
                ],
              ),
            ),
          Text(
            'A assinatura prova a origem e a integridade do arquivo publicado. Ela não prova nada sobre o funcionamento da urna nem sobre a totalização.',
            style: t.bodySmall?.copyWith(color: p.inkSecondary),
          ),
          const SizedBox(height: Space.x2),
          Text(
            'Os arquivos de cada urna (boletim de urna) têm outra assinatura, conferida em Minha seção pelo hash; a assinatura da própria urna ainda não é verificada pela Urna Aberta.',
            style: t.bodySmall?.copyWith(color: p.inkSecondary),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Space.x6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Não foi possível falar com o servidor da Urna Aberta.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: Space.x4),
        FilledButton(onPressed: onRetry, child: const Text('Tentar de novo')),
      ],
    ),
  );
}

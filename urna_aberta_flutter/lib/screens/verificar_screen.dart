import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import '../design/geo/uf_nomes.dart';
import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../l10n/format.dart';
import '../l10n/l10n.dart';
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
    final l = context.l10n;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) => AtlasPage(
        title: l.verificarTitle,
        lede: l.verificarLede,
        onRefresh: c.load,
        maxWidth: 1040,
        children: [
          if (c.files case final files?) ...[
            _Summary(controller: c, files: files),
            const SizedBox(height: Space.x5),
            for (final (code, nome) in [
              (1, l.verificarOfficePresidente),
              (3, l.verificarOfficeGovernador),
              (5, l.verificarOfficeSenador),
            ])
              if (_byName(files.where((f) => f.officeCode == code), l)
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
List<FileVerification> _byName(
  Iterable<FileVerification> files,
  AppLocalizations l,
) {
  int rank(String c) => switch (c) {
    'br' => 0,
    'zz' => 2,
    _ => 1,
  };
  return files.toList()..sort((a, b) {
    final r = rank(a.scopeCode).compareTo(rank(b.scopeCode));
    return r != 0
        ? r
        : scopeNome(a.scopeCode, l).compareTo(scopeNome(b.scopeCode, l));
  });
}

class _Summary extends StatelessWidget {
  const _Summary({required this.controller, required this.files});

  final VerificarController controller;
  final List<FileVerification> files;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final l = context.l10n;
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
      title: l.verificarSummaryTitle,
      fonte: FonteLine(plateNumber: 11, source: l.verificarSummarySource),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: Space.x6,
            runSpacing: Space.x4,
            children: [
              figure(context.integer(files.length), l.verificarFilesStored),
              figure(context.integer(serverValid), l.verificarValidOnServer),
              figure(
                context.integer(deviceValid),
                allChecked ? l.verificarValidOnDevice : l.verificarCheckedHere,
              ),
            ],
          ),
          const SizedBox(height: Space.x4),
          if (deviceBad > 0) ...[
            Text(
              l.verificarDeviceBad(deviceBad),
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
                        ? l.verificarAllChecked
                        : l.verificarCheckOnDevice,
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
                      l.verificarChecking(
                        context.integer(c.checkedCount),
                        context.integer(files.length),
                      ),
                      style: t.bodySmall?.copyWith(color: p.inkMuted),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: Space.x2),
          Text(
            l.verificarCheckExplain,
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
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final wide = isWideLayout(context);
    final generated = files
        .map((f) => f.tseGeneratedAt)
        .reduce(
          (a, b) => a.isAfter(b) ? a : b,
        );
    return Plate(
      title: l.verificarGroupTitle(title, files.length),
      padding: EdgeInsets.zero,
      fonte: FonteLine(
        plateNumber: 12,
        source: l.verificarGroupSource(context.dayHm(generated)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  for (final h in [
                    l.verificarColumnServer,
                    l.verificarColumnDevice,
                  ])
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
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final f = file;
    final name = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(scopeNome(f.scopeCode, l), style: t.titleSmall),
        const SizedBox(height: Space.x1),
        Wrap(
          spacing: Space.x2,
          runSpacing: Space.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FileCode(f.fileName, url: Uri.parse(f.url)),
            Text(
              l.verificarGenerated(context.dayHm(f.tseGeneratedAt)),
              style: t.bodySmall?.copyWith(color: p.inkMuted),
            ),
          ],
        ),
      ],
    );
    final server = _serverBadge(f.signature, l, wide: wide);
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
  static Widget _serverBadge(
    SignatureStatus? s,
    AppLocalizations l, {
    required bool wide,
  }) {
    String where(String text) => wide ? _cap(text) : l.verificarOnServer(text);
    return switch (s) {
      SignatureStatus.valid => StatusBadge(
        VerificationStatus.valid,
        label: where(l.verificarStatusValid),
      ),
      SignatureStatus.invalid => StatusBadge(
        VerificationStatus.invalid,
        label: where(l.verificarStatusInvalid),
      ),
      SignatureStatus.unknownKey => StatusBadge(
        VerificationStatus.pending,
        label: where(l.verificarStatusUnknownKey),
      ),
      null => StatusBadge(
        VerificationStatus.pending,
        label: where(l.verificarStatusUnsigned),
      ),
    };
  }

  Widget _deviceBadge(BuildContext context, {required bool wide}) {
    final id = file.snapshotId;
    final l = context.l10n;
    String where(String text) => wide ? _cap(text) : l.verificarOnDevice(text);
    if (controller.isChecking(id)) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Spinner(),
          const SizedBox(width: Space.x2),
          Text(
            where(l.verificarStatusChecking),
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
        label: where(l.verificarStatusDownloadFailed),
      );
    }
    return switch (controller.deviceResult(id)) {
      DeviceCheck.valid => StatusBadge(
        VerificationStatus.valid,
        label: where(l.verificarStatusValid),
      ),
      DeviceCheck.invalid => StatusBadge(
        VerificationStatus.invalid,
        label: where(l.verificarStatusInvalid),
      ),
      DeviceCheck.differentFile => StatusBadge(
        VerificationStatus.invalid,
        label: where(l.verificarStatusDifferentFile),
      ),
      DeviceCheck.unknownKey => StatusBadge(
        VerificationStatus.pending,
        label: where(l.verificarStatusUnknownKey),
      ),
      DeviceCheck.unreadable => StatusBadge(
        VerificationStatus.invalid,
        label: where(l.verificarStatusUnreadable),
      ),
      null => StatusBadge(
        VerificationStatus.pending,
        label: where(l.verificarStatusNotChecked),
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
    final l = context.l10n;
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
      title: l.verificarYourselfTitle,
      fonte: FonteLine(plateNumber: 13, source: l.verificarYourselfSource),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.verificarYourselfIntro, style: t.bodyMedium),
          const SizedBox(height: Space.x4),
          HashRow(label: l.verificarKeyId, hash: tseKeyId),
          const SizedBox(height: Space.x2),
          HashRow(label: 'Ed25519 (x)', hash: tsePublicKey),
          const SizedBox(height: Space.x4),
          step('1', l.verificarStep1),
          step('2', l.verificarStep2),
          step('3', l.verificarStep3),
          const SizedBox(height: Space.x2),
          _CodeBlock(label: 'tse.pem', code: _pem),
          const SizedBox(height: Space.x3),
          _CodeBlock(label: l.verificarTerminal, code: _script),
          const SizedBox(height: Space.x2),
          Text(
            l.verificarKeyNote,
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
    final l = context.l10n;
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
                  tooltip: l.verificarCopy,
                  icon: Icon(AtlasIcons.copy(context), size: 18),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    selectionHaptic();
                    if (context.mounted) {
                      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                        SnackBar(content: Text(l.verificarCopied)),
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
    final l = context.l10n;
    return Plate(
      title: l.verificarMeaningTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (s, label, text) in [
            (
              VerificationStatus.valid,
              l.verificarMeaningValidLabel,
              l.verificarMeaningValid,
            ),
            (
              VerificationStatus.invalid,
              l.verificarMeaningInvalidLabel,
              l.verificarMeaningInvalid,
            ),
            (
              VerificationStatus.invalid,
              l.verificarMeaningDifferentLabel,
              l.verificarMeaningDifferent,
            ),
            (
              VerificationStatus.pending,
              l.verificarMeaningNotCheckedLabel,
              l.verificarMeaningNotChecked,
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
            l.verificarProves,
            style: t.bodySmall?.copyWith(color: p.inkSecondary),
          ),
          const SizedBox(height: Space.x2),
          Text(
            l.verificarUrnaNote,
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
          context.l10n.verificarLoadError,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: Space.x4),
        FilledButton(
          onPressed: onRetry,
          child: Text(context.l10n.verificarRetry),
        ),
      ],
    ),
  );
}

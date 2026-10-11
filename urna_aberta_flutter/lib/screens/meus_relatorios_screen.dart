import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../l10n/format.dart';
import '../l10n/l10n.dart';
import '../relatorios/meus_relatorios_controller.dart';
import '../relatorios/relatorios_source.dart';
import 'novo_relatorio_screen.dart';
import 'resultados_screen.dart' show officeName;

Future<void> _launch(Uri uri) async {
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Meus relatórios: every report the viewer asked for, followed live while
/// it is built; ready ones download as PDF or CSV and can be published.
class MeusRelatoriosScreen extends StatefulWidget {
  const MeusRelatoriosScreen({super.key, this.highlight, this.open});

  static const routeName = '/relatorios';

  /// The report just asked for, shown first and marked.
  final int? highlight;

  /// Opens download links; the browser by default.
  final Future<void> Function(Uri)? open;

  static Future<void> push(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const MeusRelatoriosScreen(),
    ),
  );

  @override
  State<MeusRelatoriosScreen> createState() => _MeusRelatoriosScreenState();
}

class _MeusRelatoriosScreenState extends State<MeusRelatoriosScreen> {
  MeusRelatoriosController? _c;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_c != null) return;
    _c = MeusRelatoriosController(
      RelatoriosScope.maybeOf(context)!,
      open: widget.open ?? _launch,
    )..load();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = _c!;
    return Scaffold(
      body: ListenableBuilder(
        listenable: c,
        builder: (context, _) => AtlasPage(
          title: l.relatoriosMine,
          lede: l.relatoriosMineLede,
          maxWidth: 880,
          showBack: true,
          actions: [
            TextButton.icon(
              onPressed: () => NovoRelatorioScreen.open(context),
              icon: Icon(AtlasIcons.report(context), size: 18),
              label: Text(l.relatoriosNew),
            ),
          ],
          children: [
            if (c.loading && c.reports.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (c.error != null)
              Text(l.relatoriosLoadError)
            else if (c.reports.isEmpty)
              Text(l.relatoriosEmpty)
            else
              for (final r in c.reports) ...[
                _ReportCard(
                  report: r,
                  c: c,
                  highlighted: r.id == widget.highlight,
                ),
                const SizedBox(height: Space.x4),
              ],
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.report,
    required this.c,
    required this.highlighted,
  });

  final ReportRequest report;
  final MeusRelatoriosController c;
  final bool highlighted;

  String _title(AppLocalizations l) {
    final offices = report.spec.offices.map((o) => officeName(l, o));
    final places = report.placeNames ?? const <String>[];
    final where = places.length > 3
        ? '${places.take(3).join(', ')}…'
        : places.join(', ');
    return '${offices.join(', ')} · $where';
  }

  Future<void> _act(
    BuildContext context,
    Future<void> Function() action, {
    String? done,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    try {
      await action();
      if (done != null) {
        messenger.showSnackBar(SnackBar(content: Text(done)));
      }
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.relatoriosActionFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    final r = report;
    final busy = c.busy(r.id!);
    final breakdown = switch (r.spec.breakdown) {
      ReportBreakdown.none => null,
      ReportBreakdown.uf => l.relatoriosBreakdownUf,
      ReportBreakdown.municipio => l.relatoriosBreakdownMunicipio,
      ReportBreakdown.zona => l.relatoriosBreakdownZona,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        border: highlighted
            ? Border(left: BorderSide(color: p.shell, width: 3))
            : null,
      ),
      child: Plate(
        title: _title(l),
        trailing: _StatusChip(report: r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              [
                l.relatoriosRequestedAt(context.dayHm(r.createdAt)),
                ?breakdown,
                r.spec.language.toUpperCase(),
              ].join(' · '),
              style: t.bodySmall?.copyWith(color: p.inkMuted),
            ),
            if (r.status == ReportStatus.running ||
                r.status == ReportStatus.queued) ...[
              const SizedBox(height: Space.x3),
              LinearProgressIndicator(
                value: r.filesTotal == 0 || r.status == ReportStatus.queued
                    ? null
                    : r.filesDone / r.filesTotal,
              ),
              const SizedBox(height: Space.x1),
              Semantics(
                liveRegion: true,
                child: Text(
                  l.relatoriosProgress(
                    context.integer(r.filesDone),
                    context.integer(r.filesTotal),
                  ),
                  style: t.bodySmall,
                ),
              ),
            ],
            if (r.status == ReportStatus.failed) ...[
              const SizedBox(height: Space.x3),
              Text(
                r.errorReason == 'tseUnavailable'
                    ? l.relatoriosFailedTse
                    : l.relatoriosFailedOther,
                style: t.bodyMedium,
              ),
            ],
            if (r.status == ReportStatus.ready && r.sha256 != null) ...[
              const SizedBox(height: Space.x2),
              SelectableText(
                l.relatoriosSha(r.sha256!),
                style: t.bodySmall?.copyWith(color: p.inkMuted),
              ),
            ],
            if (r.publicToken != null) ...[
              const SizedBox(height: Space.x2),
              Row(
                children: [
                  Icon(
                    AtlasIcons.link(context),
                    size: 16,
                    color: p.inkSecondary,
                  ),
                  const SizedBox(width: Space.x2),
                  Expanded(
                    child: Text(
                      l.relatoriosPublicNote,
                      style: t.bodySmall?.copyWith(color: p.inkSecondary),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: Space.x4),
            Wrap(
              spacing: Space.x2,
              runSpacing: Space.x2,
              children: [
                if (r.status == ReportStatus.ready) ...[
                  FilledButton.icon(
                    onPressed: busy
                        ? null
                        : () => _act(context, () => c.download(r, 'pdf')),
                    icon: Icon(AtlasIcons.download(context), size: 18),
                    label: Text(l.relatoriosDownloadPdf),
                  ),
                  OutlinedButton(
                    onPressed: busy
                        ? null
                        : () => _act(context, () => c.download(r, 'csv')),
                    child: Text(l.relatoriosDownloadCsv),
                  ),
                  if (r.publicToken == null)
                    TextButton(
                      onPressed: busy
                          ? null
                          : () => _act(context, () => c.publish(r, true)),
                      child: Text(l.relatoriosPublish),
                    )
                  else ...[
                    TextButton.icon(
                      onPressed: busy
                          ? null
                          : () => _act(context, () async {
                              final link = await c.publicLink(r);
                              if (link != null) {
                                await Clipboard.setData(
                                  ClipboardData(text: link),
                                );
                              }
                            }, done: l.relatoriosLinkCopied),
                      icon: Icon(AtlasIcons.copy(context), size: 16),
                      label: Text(l.relatoriosCopyLink),
                    ),
                    TextButton(
                      onPressed: busy
                          ? null
                          : () => _act(context, () => c.publish(r, false)),
                      child: Text(l.relatoriosUnpublish),
                    ),
                  ],
                ],
                if (r.status == ReportStatus.failed)
                  FilledButton(
                    onPressed: () => _act(context, () => c.retry(r)),
                    child: Text(l.relatoriosRetry),
                  ),
                if (r.status != ReportStatus.running)
                  TextButton(
                    onPressed: busy
                        ? null
                        : () => _act(
                            context,
                            () => c.delete(r),
                            done: l.relatoriosDeleted,
                          ),
                    child: Text(l.relatoriosDelete),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Status, always icon + label.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.report});

  final ReportRequest report;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.atlas;
    final (status, label) = switch (report.status) {
      ReportStatus.queued => (
        VerificationStatus.pending,
        l.relatoriosStatusQueued,
      ),
      ReportStatus.running => (
        VerificationStatus.pending,
        l.relatoriosStatusRunning,
      ),
      ReportStatus.ready => (VerificationStatus.valid, l.relatoriosStatusReady),
      ReportStatus.failed => (
        VerificationStatus.invalid,
        l.relatoriosStatusFailed,
      ),
    };
    final color = p.status(status);
    final icon = switch (status) {
      VerificationStatus.valid => AtlasIcons.valid(context),
      VerificationStatus.invalid => AtlasIcons.invalid(context),
      VerificationStatus.pending => AtlasIcons.pending(context),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}

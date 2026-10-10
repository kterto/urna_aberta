import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../platform.dart';
import '../tokens.dart';
import '../typography.dart';

/// Every figure is a plate: cut-paper surface, 1px rule, title, body, and a
/// Fonte line carrying the plate number, source and catalog code.
class Plate extends StatelessWidget {
  const Plate({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.fonte,
    this.padding = const EdgeInsets.all(Space.x4),
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final FonteLine? fonte;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return Semantics(
      container: true,
      label: title,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: p.plate,
          border: Border.all(color: p.rule),
          borderRadius: BorderRadius.circular(Corner.plate),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.x4,
                Space.x4,
                Space.x4,
                0,
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: Space.x3,
                runSpacing: Space.x2,
                children: [
                  Text(
                    title,
                    style: AtlasType.plateTitle.copyWith(color: p.ink),
                  ),
                  ?trailing,
                ],
              ),
            ),
            Padding(padding: padding, child: child),
            ?fonte,
          ],
        ),
      ),
    );
  }
}

class FonteLine extends StatelessWidget {
  const FonteLine({
    super.key,
    required this.plateNumber,
    required this.source,
    this.codes = const [],
    this.simulation = false,
  });

  final int plateNumber;
  final String source;
  final List<FileCode> codes;
  final bool simulation;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final style = AtlasType.source.copyWith(color: p.inkMuted);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.rule)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.x4,
          Space.x2,
          Space.x4,
          Space.x3,
        ),
        child: Wrap(
          spacing: Space.x3,
          runSpacing: Space.x2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Prancha $plateNumber',
              style: style.copyWith(
                color: p.inkSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(source, style: style),
            ...codes,
            if (simulation) const SimulationStamp(),
          ],
        ),
      ),
    );
  }
}

/// The catalog number on every figure: a TSE file code. Tapping opens the
/// file when [url] is given.
class FileCode extends StatelessWidget {
  const FileCode(this.code, {super.key, this.url});

  final String code;
  final Uri? url;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final chip = DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: p.ruleStrong),
        borderRadius: BorderRadius.circular(Corner.key + 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                code,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AtlasType.fileCode.copyWith(color: p.inkSecondary),
              ),
            ),
            if (url != null) ...[
              const SizedBox(width: 4),
              Icon(
                AtlasIcons.external(context),
                size: 12,
                color: p.inkSecondary,
              ),
            ],
          ],
        ),
      ),
    );
    if (url == null) {
      return Semantics(label: 'Arquivo $code', child: chip);
    }
    return Semantics(
      link: true,
      label: 'Abrir arquivo $code',
      child: Tooltip(
        message: url.toString(),
        child: InkWell(
          onTap: () => launchUrl(url!, mode: LaunchMode.externalApplication),
          borderRadius: BorderRadius.circular(Corner.key + 1),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 32),
            child: Center(widthFactor: 1, child: chip),
          ),
        ),
      ),
    );
  }
}

/// Required stamp on any data that is not official TSE data.
class SimulationStamp extends StatelessWidget {
  const SimulationStamp({super.key, this.label = 'Simulação'});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return Semantics(
      label: '$label: dados não oficiais',
      child: CustomPaint(
        painter: _DashedRectPainter(p.statusPending),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: Text(
            label.toUpperCase(),
            style: AtlasType.fileCode.copyWith(
              color: p.statusPending,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  _DashedRectPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dash = 4.0, gap = 3.0;
    void line(Offset a, Offset b) {
      final len = (b - a).distance;
      final dir = (b - a) / len;
      for (var d = 0.0; d < len; d += dash + gap) {
        final end = (d + dash).clamp(0, len).toDouble();
        canvas.drawLine(a + dir * d, a + dir * end, paint);
      }
    }

    final r = Offset.zero & size;
    line(r.topLeft, r.topRight);
    line(r.topRight, r.bottomRight);
    line(r.bottomRight, r.bottomLeft);
    line(r.bottomLeft, r.topLeft);
  }

  @override
  bool shouldRepaint(_DashedRectPainter old) => old.color != color;
}

/// Verification state, always icon + label + color.
class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key, this.label});

  final VerificationStatus status;
  final String? label;

  static String defaultLabel(VerificationStatus s) => switch (s) {
    VerificationStatus.valid => 'Assinatura válida',
    VerificationStatus.invalid => 'Assinatura inválida',
    VerificationStatus.pending => 'Não verificado',
  };

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final c = p.status(status);
    final icon = switch (status) {
      VerificationStatus.valid => AtlasIcons.valid(context),
      VerificationStatus.invalid => AtlasIcons.invalid(context),
      VerificationStatus.pending => AtlasIcons.pending(context),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.alphaBlend(c.withValues(alpha: 0.08), p.plate),
        border: Border.all(color: c),
        borderRadius: BorderRadius.circular(Corner.plate),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(7, 5, 9, 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: c),
            const SizedBox(width: 6),
            // Wraps inside a narrow column instead of overflowing it.
            Flexible(
              child: Text(
                label ?? defaultLabel(status),
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: c),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when the TSE national file lags the independent sum of states.
class DivergenceBanner extends StatelessWidget {
  const DivergenceBanner({super.key, this.onLearnMore, this.compact = false});

  final VoidCallback? onLearnMore;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final link = onLearnMore == null
        ? null
        : TextButton(
            onPressed: onLearnMore,
            style: TextButton.styleFrom(foregroundColor: p.alertInk),
            child: const Text('Entenda por quê'),
          );
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: p.alertGround,
          border: Border.all(color: p.alertRule),
          borderRadius: BorderRadius.circular(Corner.plate),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Space.x3,
            Space.x3,
            Space.x3,
            link == null || compact ? Space.x3 : Space.x1,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(AtlasIcons.warning(context), size: 20, color: p.alertInk),
              const SizedBox(width: Space.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A divulgação nacional está atrás dos estados.',
                      style: t.titleSmall?.copyWith(color: p.alertInk),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'A contagem continua: os arquivos por UF seguem sendo atualizados.',
                      style: t.bodySmall?.copyWith(color: p.alertInk),
                    ),
                    if (link != null && !compact) link,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selectable hash with a copy action.
class HashRow extends StatelessWidget {
  const HashRow({super.key, required this.label, required this.hash});

  final String label;
  final String hash;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.plateSunk,
        border: Border.all(color: p.rule),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.x3,
          Space.x2,
          Space.x1,
          Space.x2,
        ),
        child: Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(width: Space.x3),
            Expanded(
              child: SelectableText(
                hash,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontFamilyFallback: const ['Menlo', 'Roboto Mono', 'Courier'],
                  fontSize: 12.5,
                  color: p.inkSecondary,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Copiar hash',
              icon: Icon(AtlasIcons.copy(context), size: 18),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: hash));
                selectionHaptic();
                if (context.mounted) {
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    const SnackBar(content: Text('Hash copiado')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Segmented control: Cupertino sliding control on iOS, Material elsewhere.
class AtlasSegmented<T extends Object> extends StatelessWidget {
  const AtlasSegmented({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final Map<T, String> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    if (shellKindOf(context) == ShellKind.ios) {
      return CupertinoSlidingSegmentedControl<T>(
        groupValue: selected,
        children: {
          for (final e in segments.entries)
            e.key: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.x3),
              child: Text(e.value),
            ),
        },
        onValueChanged: (v) {
          if (v != null) {
            selectionHaptic();
            onChanged(v);
          }
        },
      );
    }
    return SegmentedButton<T>(
      showSelectedIcon: false,
      segments: [
        for (final e in segments.entries)
          ButtonSegment(value: e.key, label: Text(e.value)),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onChanged(s.first),
    );
  }
}

/// Square legend key, used as a filter control (the signature move).
class LegendKey extends StatelessWidget {
  const LegendKey({
    super.key,
    required this.color,
    required this.label,
    this.trailing,
    this.selected = false,
    this.onTap,
  });

  final Color color;
  final String label;
  final String? trailing;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: [label, ?trailing].join(', '),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap == null
            ? null
            : () {
                selectionHaptic();
                onTap!();
              },
        borderRadius: BorderRadius.circular(Corner.plate),
        child: AnimatedContainer(
          duration: Motion.of(context, Motion.quick),
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: Space.x2),
          decoration: BoxDecoration(
            color: selected ? p.plateSunk : null,
            border: Border.all(color: selected ? p.ink : Colors.transparent),
            borderRadius: BorderRadius.circular(Corner.plate),
          ),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: p.ink.withValues(alpha: 0.25)),
                  borderRadius: BorderRadius.circular(Corner.key),
                ),
              ),
              const SizedBox(width: Space.x3),
              Expanded(child: Text(label, style: t.bodyMedium)),
              if (trailing != null)
                Text(
                  trailing!,
                  style: AtlasType.tableFigure.copyWith(
                    color: p.inkMuted,
                    fontSize: 12.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section opener used inside screens: heading plus a lede, no eyebrow.
class SectionHead extends StatelessWidget {
  const SectionHead({super.key, required this.title, this.lede});

  final String title;
  final String? lede;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: Space.x6, bottom: Space.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.headlineMedium),
          if (lede != null) ...[
            const SizedBox(height: Space.x2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                lede!,
                style: t.bodyLarge?.copyWith(color: p.inkSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

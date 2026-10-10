import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens.dart';
import '../typography.dart';
import 'atlas_components.dart';

String fmtPct(double v, [int digits = 2]) =>
    v.toStringAsFixed(digits).replaceAll('.', ',');

String fmtInt(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

/// The two sources mirrored on one center rule: TSE national file on the
/// left growing leftward, independent sum of states on the right growing
/// rightward. Equal and opposite, never stacked as winner and loser.
class SourceDuo extends StatelessWidget {
  const SourceDuo({
    super.key,
    required this.national,
    required this.states,
    required this.nationalNote,
    required this.statesNote,
    this.compact = false,
  });

  final double national;
  final double states;
  final String nationalNote;
  final String statesNote;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final fig = (compact ? AtlasType.figureL : AtlasType.figureXL).copyWith(
      color: p.ink,
    );
    Widget side(bool left) {
      final v = left ? national : states;
      final color = left ? p.sourceNational : p.sourceStates;
      final label = left ? 'Arquivo nacional do TSE' : 'Soma dos estados';
      final swatch = Container(width: 10, height: 10, color: color);
      return Column(
        crossAxisAlignment: left
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: left
                ? [
                    Flexible(
                      child: Text(
                        label,
                        style: t.labelMedium?.copyWith(color: p.inkSecondary),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(width: 6),
                    swatch,
                  ]
                : [
                    swatch,
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        label,
                        style: t.labelMedium?.copyWith(color: p.inkSecondary),
                      ),
                    ),
                  ],
          ),
          const SizedBox(height: Space.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(compact ? fmtPct(v) : '${fmtPct(v)}%', style: fig),
          ),
          Text(
            left ? nationalNote : statesNote,
            style: t.bodySmall?.copyWith(color: p.inkMuted),
          ),
          const SizedBox(height: Space.x2),
          Container(
            height: compact ? 6 : 10,
            color: p.plateSunk,
            child: FractionallySizedBox(
              alignment: left ? Alignment.centerRight : Alignment.centerLeft,
              widthFactor: (v / 100).clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: Space.x2),
            FileCode(
              left ? 'EA20 · c0001 · br' : 'Σ EA20 · c0001 · 27 UF + ZZ',
            ),
          ],
        ],
      );
    }

    return Semantics(
      label:
          'Arquivo nacional do TSE ${fmtPct(national)} por cento; '
          'soma dos estados ${fmtPct(states)} por cento',
      excludeSemantics: true,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: side(true)),
                SizedBox(width: compact ? Space.x3 : Space.x5),
                Container(width: 1, color: p.ink),
                SizedBox(width: compact ? Space.x3 : Space.x5),
                Expanded(child: side(false)),
              ],
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: Space.x3),
            Text.rich(
              TextSpan(
                style: t.bodySmall?.copyWith(color: p.inkSecondary),
                children: [
                  const TextSpan(text: 'Diferença: '),
                  TextSpan(
                    text: '${fmtPct((states - national).abs())} p.p.',
                    style: AtlasType.tableFigure.copyWith(
                      color: p.ink,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const TextSpan(text: ' de seções totalizadas'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MirroredRow {
  const MirroredRow(this.label, this.left, this.right);

  final String label;
  final int left;
  final int right;
}

/// Population-pyramid comparison of votes per candidacy in both sources.
/// Every candidacy uses the same neutral inks.
class MirroredBars extends StatelessWidget {
  const MirroredBars({super.key, required this.rows, this.compact = false});

  final List<MirroredRow> rows;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final max = rows.map((r) => math.max(r.left, r.right)).fold(1, math.max);
    final scale = compact ? 0.96 : 1.0;
    // Compact keeps a short label between the bars; the full layout puts
    // each name on its own line above the pair, which meet at a center rule.
    final center = compact ? 28.0 : 1.0;
    // Room beside each bar for its value, so the longest count never clips.
    final valueRoom = compact ? 0.0 : 84.0;

    Widget bar(int v, bool left) {
      final w = v / max * scale;
      return LayoutBuilder(
        builder: (context, c) {
          final px = math.max(0.0, c.maxWidth - valueRoom) * w;
          final value = Text(
            compact ? '' : fmtInt(v),
            maxLines: 1,
            overflow: TextOverflow.clip,
            softWrap: false,
            style: AtlasType.tableFigure.copyWith(
              color: p.inkSecondary,
              fontSize: 12,
            ),
          );
          final mark = Container(
            width: px,
            height: 16,
            decoration: BoxDecoration(
              color: left ? p.sourceNational : p.sourceStates,
              borderRadius: left
                  ? const BorderRadius.horizontal(left: Radius.circular(3))
                  : const BorderRadius.horizontal(right: Radius.circular(3)),
            ),
          );
          return SizedBox(
            height: 28,
            child: Row(
              mainAxisAlignment: left
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: left
                  ? [Flexible(child: value), const SizedBox(width: 6), mark]
                  : [mark, const SizedBox(width: 6), Flexible(child: value)],
            ),
          );
        },
      );
    }

    return Semantics(
      label: 'Votos por candidatura nas duas fontes',
      child: Column(
        children: [
          if (!compact)
            Container(
              padding: const EdgeInsets.only(bottom: Space.x2),
              margin: const EdgeInsets.only(bottom: Space.x2),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: p.rule)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Arquivo nacional',
                      textAlign: TextAlign.end,
                      style: t.labelSmall?.copyWith(color: p.inkSecondary),
                    ),
                  ),
                  const SizedBox(width: Space.x4),
                  Expanded(
                    child: Text(
                      'Soma dos estados',
                      style: t.labelSmall?.copyWith(color: p.inkSecondary),
                    ),
                  ),
                ],
              ),
            ),
          for (final r in rows)
            MergeSemantics(
              child: Semantics(
                label:
                    '${r.label}: ${fmtInt(r.left)} no arquivo nacional, ${fmtInt(r.right)} na soma dos estados',
                excludeSemantics: true,
                child: Column(
                  children: [
                    if (!compact)
                      Padding(
                        padding: const EdgeInsets.only(top: Space.x2),
                        child: Text(
                          r.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: t.labelMedium,
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(child: bar(r.left, true)),
                        if (compact)
                          SizedBox(
                            width: center,
                            child: Text(
                              r.label.replaceFirst('Candidatura ', ''),
                              textAlign: TextAlign.center,
                              style: t.labelMedium,
                            ),
                          )
                        else
                          Container(width: center, height: 28, color: p.ink),
                        Expanded(child: bar(r.right, false)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TimelineSample {
  const TimelineSample(this.time, this.national, this.states);

  final DateTime time;
  final double national;
  final double states;
}

/// % sections totalized over the night, both sources on one 0–100 axis.
/// A shaded band marks the freeze. Crosshair on hover, scrub on drag,
/// arrow keys when focused.
class TimelineChart extends StatefulWidget {
  const TimelineChart({
    super.key,
    required this.samples,
    this.freezeStart,
    this.freezeEnd,
    this.freezeValue,
    this.now,
    this.height = 260,
  });

  /// Replay position: samples after it render faded.
  final int? now;

  final List<TimelineSample> samples;
  final DateTime? freezeStart;
  final DateTime? freezeEnd;
  final double? freezeValue;
  final double height;

  @override
  State<TimelineChart> createState() => _TimelineChartState();
}

class _TimelineChartState extends State<TimelineChart> {
  int? _index;
  final _focus = FocusNode(debugLabel: 'TimelineChart');

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  static const _m = EdgeInsets.fromLTRB(40, 16, 16, 28);

  int _indexAt(double x, double width) {
    final f = ((x - _m.left) / (width - _m.horizontal)).clamp(0.0, 1.0);
    return (f * (widget.samples.length - 1)).round();
  }

  String _hhmm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final s = widget.samples;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: Space.x4,
          children: [
            _legendLine(context, p.sourceNational, 'Arquivo nacional'),
            _legendLine(context, p.sourceStates, 'Soma dos estados'),
          ],
        ),
        const SizedBox(height: Space.x2),
        Focus(
          focusNode: _focus,
          onKeyEvent: (node, e) {
            if (e is! KeyDownEvent) return KeyEventResult.ignored;
            final i = _index ?? s.length - 1;
            if (e.logicalKey == LogicalKeyboardKey.arrowRight) {
              setState(() => _index = math.min(s.length - 1, i + 1));
              return KeyEventResult.handled;
            }
            if (e.logicalKey == LogicalKeyboardKey.arrowLeft) {
              setState(() => _index = math.max(0, i - 1));
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          onFocusChange: (f) =>
              setState(() => _index = f ? s.length - 1 : null),
          child: Semantics(
            label: _index == null
                ? 'Linha do tempo das duas fontes. Use as setas para explorar.'
                : '${_hhmm(s[_index!].time)}: arquivo nacional ${fmtPct(s[_index!].national)}%, soma dos estados ${fmtPct(s[_index!].states)}%',
            child: LayoutBuilder(
              builder: (context, c) {
                final size = Size(c.maxWidth, widget.height);
                final i = _index;
                double xOf(int k) =>
                    _m.left + k / (s.length - 1) * (size.width - _m.horizontal);
                double yOf(double v) =>
                    _m.top + (1 - v / 100) * (size.height - _m.vertical);
                return MouseRegion(
                  onHover: (e) => setState(
                    () => _index = _indexAt(e.localPosition.dx, size.width),
                  ),
                  onExit: (_) => setState(() => _index = null),
                  child: GestureDetector(
                    onHorizontalDragUpdate: (d) => setState(
                      () => _index = _indexAt(d.localPosition.dx, size.width),
                    ),
                    onHorizontalDragEnd: (_) => setState(() => _index = null),
                    onTapDown: (d) {
                      _focus.requestFocus();
                      setState(
                        () => _index = _indexAt(d.localPosition.dx, size.width),
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CustomPaint(
                          size: size,
                          painter: _TimelinePainter(
                            samples: s,
                            palette: p,
                            index: i,
                            freezeStart: widget.freezeStart,
                            freezeEnd: widget.freezeEnd,
                            freezeValue: widget.freezeValue,
                            now: widget.now,
                            margin: _m,
                          ),
                        ),
                        if (i != null)
                          Positioned(
                            left: (xOf(i) - 90).clamp(0, size.width - 180),
                            top: math.max(
                              0,
                              yOf(math.max(s[i].national, s[i].states)) - 86,
                            ),
                            child: IgnorePointer(
                              child: Container(
                                width: 180,
                                padding: const EdgeInsets.all(Space.x2),
                                decoration: BoxDecoration(
                                  color: p.ink,
                                  borderRadius: BorderRadius.circular(
                                    Corner.control,
                                  ),
                                ),
                                child: DefaultTextStyle(
                                  style: AtlasType.tableFigure.copyWith(
                                    color: p.paper,
                                    fontSize: 12.5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        _hhmm(s[i].time) +
                                            (_frozen(s[i].time)
                                                ? ' · nacional parado'
                                                : ''),
                                        style: t.labelMedium?.copyWith(
                                          color: p.paper,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      _tipRow(
                                        'Arquivo nacional',
                                        '${fmtPct(s[i].national)}%',
                                      ),
                                      _tipRow(
                                        'Soma dos estados',
                                        '${fmtPct(s[i].states)}%',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  bool _frozen(DateTime t) =>
      widget.freezeStart != null &&
      !t.isBefore(widget.freezeStart!) &&
      t.isBefore(widget.freezeEnd!);

  Widget _tipRow(String a, String b) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(a), Text(b)],
  );

  Widget _legendLine(BuildContext context, Color c, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 18, height: 2, color: c),
      const SizedBox(width: 7),
      Text(
        label,
        style: AtlasType.legend.copyWith(color: context.atlas.inkSecondary),
      ),
    ],
  );
}

class _TimelinePainter extends CustomPainter {
  _TimelinePainter({
    required this.samples,
    required this.palette,
    required this.index,
    required this.freezeStart,
    required this.freezeEnd,
    required this.freezeValue,
    required this.now,
    required this.margin,
  });

  final int? now;

  final List<TimelineSample> samples;
  final AtlasPalette palette;
  final int? index;
  final DateTime? freezeStart;
  final DateTime? freezeEnd;
  final double? freezeValue;
  final EdgeInsets margin;

  @override
  void paint(Canvas canvas, Size size) {
    final t0 = samples.first.time, t1 = samples.last.time;
    final span = t1.difference(t0).inSeconds.toDouble();
    double xt(DateTime t) =>
        margin.left +
        t.difference(t0).inSeconds / span * (size.width - margin.horizontal);
    double xi(int k) => xt(samples[k].time);
    double y(double v) =>
        margin.top + (1 - v / 100) * (size.height - margin.vertical);

    TextPainter text(String s, {Color? color, FontWeight? w}) => TextPainter(
      text: TextSpan(
        text: s,
        style: AtlasType.source.copyWith(
          color: color ?? palette.inkMuted,
          fontSize: 11,
          fontWeight: w,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    if (freezeStart != null && freezeEnd != null) {
      final a = xt(freezeStart!), b = xt(freezeEnd!);
      canvas.drawRect(
        Rect.fromLTRB(a, margin.top, b, size.height - margin.bottom),
        Paint()..color = palette.alertGround,
      );
      canvas.drawLine(
        Offset(a, margin.top),
        Offset(a, size.height - margin.bottom),
        Paint()
          ..color = palette.alertRule
          ..strokeWidth = 1.5,
      );
      text(
        'Nacional parado · ${freezeEnd!.difference(freezeStart!).inMinutes} min',
        color: palette.alertInk,
        w: FontWeight.w600,
      ).paint(canvas, Offset(a + 6, margin.top + 4));
    }

    for (final v in [0, 25, 50, 75, 100]) {
      canvas.drawLine(
        Offset(margin.left, y(v.toDouble())),
        Offset(size.width - margin.right, y(v.toDouble())),
        Paint()
          ..color = v == 0 ? palette.ink : palette.rule
          ..strokeWidth = v == 0 ? 1 : 0.8,
      );
      final tp = text('$v%');
      tp.paint(
        canvas,
        Offset(margin.left - 8 - tp.width, y(v.toDouble()) - tp.height / 2),
      );
    }
    // Whole hours from t0 to t1, in t0's zone kind; the night crosses
    // midnight, so step by hours rather than by hour-of-day.
    final firstHour = t0.isUtc
        ? DateTime.utc(t0.year, t0.month, t0.day, t0.hour)
        : DateTime(t0.year, t0.month, t0.day, t0.hour);
    for (
      var at = firstHour;
      !at.isAfter(t1);
      at = at.add(const Duration(hours: 1))
    ) {
      if (at.isBefore(t0)) continue;
      final tp = text('${at.hour}h');
      tp.paint(
        canvas,
        Offset(xt(at) - tp.width / 2, size.height - margin.bottom + 8),
      );
    }

    final last = now ?? samples.length - 1;
    Path line(double Function(TimelineSample) f, int from, int to) {
      final path = Path()..moveTo(xi(from), y(f(samples[from])));
      for (var k = from + 1; k <= to; k++) {
        path.lineTo(xi(k), y(f(samples[k])));
      }
      return path;
    }

    Paint stroke(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = Stroke.data
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final end = samples.length - 1;
    if (last < end) {
      canvas.drawPath(
        line((e) => e.states, last, end),
        stroke(palette.sourceStates.withValues(alpha: 0.25)),
      );
      canvas.drawPath(
        line((e) => e.national, last, end),
        stroke(palette.sourceNational.withValues(alpha: 0.25)),
      );
      canvas.drawLine(
        Offset(xi(last), margin.top),
        Offset(xi(last), size.height - margin.bottom),
        Paint()
          ..color = palette.ink
          ..strokeWidth = 1,
      );
    }
    if (last > 0) {
      canvas.drawPath(
        line((e) => e.states, 0, last),
        stroke(palette.sourceStates),
      );
      canvas.drawPath(
        line((e) => e.national, 0, last),
        stroke(palette.sourceNational),
      );
    }

    if (freezeValue != null && freezeStart != null) {
      final tp = text(
        '${fmtPct(freezeValue!)}%',
        color: palette.ink,
        w: FontWeight.w700,
      );
      tp.paint(
        canvas,
        Offset(xt(freezeStart!) - 6 - tp.width, y(freezeValue!) + 6),
      );
    }

    final i = index;
    if (i != null) {
      final x = xi(i);
      final dash = Paint()
        ..color = palette.inkMuted
        ..strokeWidth = 1;
      for (var d = margin.top; d < size.height - margin.bottom; d += 6) {
        canvas.drawLine(Offset(x, d), Offset(x, d + 3), dash);
      }
      for (final (v, c) in [
        (samples[i].national, palette.sourceNational),
        (samples[i].states, palette.sourceStates),
      ]) {
        canvas.drawCircle(Offset(x, y(v)), 6.5, Paint()..color = palette.plate);
        canvas.drawCircle(Offset(x, y(v)), 4.5, Paint()..color = c);
      }
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter old) =>
      old.index != index ||
      old.now != now ||
      old.palette != palette ||
      old.samples != samples;
}

/// One mini curve per UF, all on the same 0–100 scale, grouped by region.
class UfSmallMultiples extends StatelessWidget {
  const UfSmallMultiples({
    super.key,
    required this.ufsByRegion,
    required this.finalPct,
    required this.curve,
  });

  final Map<Regiao, List<String>> ufsByRegion;
  final Map<String, double> finalPct;
  final List<double> Function(String sigla) curve;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return LayoutBuilder(
      builder: (context, c) {
        final stacked = c.maxWidth < 640;
        return Column(
          children: [
            for (final r in Regiao.values)
              Container(
                padding: const EdgeInsets.symmetric(vertical: Space.x3),
                decoration: BoxDecoration(
                  border: r == Regiao.values.first
                      ? null
                      : Border(top: BorderSide(color: p.rule)),
                ),
                child: Flex(
                  direction: stacked ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: stacked ? null : 150,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: Space.x2,
                          top: Space.x1,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: p.region(r),
                            ),
                            const SizedBox(width: Space.x2),
                            Text(
                              r.nomePt.toUpperCase(),
                              style: AtlasType.mapRegionLabel.copyWith(
                                color: p.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (stacked)
                      _cells(context, ufsByRegion[r]!)
                    else
                      Expanded(child: _cells(context, ufsByRegion[r]!)),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _cells(BuildContext context, List<String> ufs) {
    final p = context.atlas;
    return Wrap(
      spacing: Space.x2,
      runSpacing: Space.x2,
      children: [
        for (final uf in ufs)
          Semantics(
            label: '$uf: ${fmtPct(finalPct[uf]!, 1)}% das seções totalizadas',
            excludeSemantics: true,
            child: Container(
              width: 96,
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
              decoration: BoxDecoration(
                color: p.plate,
                border: Border.all(color: p.rule),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        uf,
                        style: AtlasType.mapLabel.copyWith(
                          color: p.ink,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        fmtPct(finalPct[uf]!, 1),
                        style: AtlasType.tableFigure.copyWith(
                          color: p.inkSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  CustomPaint(
                    size: const Size(double.infinity, 34),
                    painter: _MiniCurvePainter(curve(uf), p),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _MiniCurvePainter extends CustomPainter {
  _MiniCurvePainter(this.values, this.palette);

  final List<double> values;
  final AtlasPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    double y(double v) => size.height - v / 100 * (size.height - 2);
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      Paint()
        ..color = palette.inkMuted
        ..strokeWidth = 1,
    );
    for (var x = 0.0; x < size.width; x += 4) {
      canvas.drawLine(
        Offset(x, y(100)),
        Offset(x + 2, y(100)),
        Paint()
          ..color = palette.rule
          ..strokeWidth = 1,
      );
    }
    final path = Path()..moveTo(0, y(values.first));
    for (var i = 1; i < values.length; i++) {
      path.lineTo(i / (values.length - 1) * size.width, y(values[i]));
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = palette.sourceStates
        ..style = PaintingStyle.stroke
        ..strokeWidth = Stroke.data,
    );
  }

  @override
  bool shouldRepaint(_MiniCurvePainter old) =>
      old.values != values || old.palette != palette;
}

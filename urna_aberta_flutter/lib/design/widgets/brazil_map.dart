import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../l10n/format.dart';
import '../../l10n/l10n.dart';
import '../geo/brasil_geo.dart';
import '../platform.dart';
import '../tokens.dart';
import '../typography.dart';
import 'atlas_components.dart' show RegiaoName;

enum MapLayer { regioes, totalizacao }

/// What the legend has focused: a region, or a totalization class (0–4).
@immutable
sealed class MapFocus {
  const MapFocus();
  bool includes(UfShape uf, double pct);
}

class RegionFocus extends MapFocus {
  const RegionFocus(this.regiao);
  final Regiao regiao;
  @override
  bool includes(UfShape uf, double pct) => uf.regiao == regiao;
  @override
  bool operator ==(Object other) =>
      other is RegionFocus && other.regiao == regiao;
  @override
  int get hashCode => regiao.hashCode;
}

class ClassFocus extends MapFocus {
  const ClassFocus(this.index);
  final int index;
  @override
  bool includes(UfShape uf, double pct) => classOf(pct) == index;
  @override
  bool operator ==(Object other) => other is ClassFocus && other.index == index;
  @override
  int get hashCode => index.hashCode;

  static int classOf(double pct) => (pct.clamp(0, 99.999) / 20).floor();
}

/// The atlas plate map of Brazil by UF. Region outlines sit over the UF
/// fills; unfocused UFs drop to half-tone; the selected UF takes a heavy rule.
class BrazilMap extends StatefulWidget {
  const BrazilMap({
    super.key,
    required this.geo,
    required this.pct,
    this.layer = MapLayer.regioes,
    this.focus,
    this.selected,
    this.onSelect,
    this.furniture = true,
    this.labels = true,
  });

  final BrasilGeo geo;

  /// % sections totalized per UF sigla.
  final Map<String, double> pct;
  final MapLayer layer;
  final MapFocus? focus;
  final String? selected;
  final ValueChanged<String?>? onSelect;

  /// Graticule, north arrow and scale bar.
  final bool furniture;
  final bool labels;

  @override
  State<BrazilMap> createState() => _BrazilMapState();
}

class _BrazilMapState extends State<BrazilMap> {
  String? _hover;
  late final FocusNode _focus = FocusNode(debugLabel: 'BrazilMap');

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  EdgeInsets get _pad => widget.furniture
      ? const EdgeInsets.fromLTRB(40, 16, 120, 44)
      : EdgeInsets.zero;

  Matrix4 _transform(Size box) {
    final g = widget.geo.size;
    final w = g.width + _pad.horizontal, h = g.height + _pad.vertical;
    final s = (box.width / w) < (box.height / h)
        ? box.width / w
        : box.height / h;
    final dx = (box.width - w * s) / 2 + _pad.left * s;
    final dy = (box.height - h * s) / 2 + _pad.top * s;
    return Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(s, s, 1, 1);
  }

  String? _hit(Offset local, Size box) {
    final inv = Matrix4.tryInvert(_transform(box));
    if (inv == null) return null;
    final p = MatrixUtils.transformPoint(inv, local);
    for (final uf in widget.geo.ufs) {
      if (uf.path.contains(p)) return uf.sigla;
    }
    return null;
  }

  void _select(String? sigla) {
    if (widget.onSelect == null) return;
    selectionHaptic();
    widget.onSelect!(sigla == widget.selected ? null : sigla);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent || widget.onSelect == null) {
      return KeyEventResult.ignored;
    }
    final ufs = widget.geo.ufs;
    final i = ufs.indexWhere((u) => u.sigla == widget.selected);
    int? next;
    if (e.logicalKey == LogicalKeyboardKey.arrowRight ||
        e.logicalKey == LogicalKeyboardKey.arrowDown) {
      next = (i + 1) % ufs.length;
    } else if (e.logicalKey == LogicalKeyboardKey.arrowLeft ||
        e.logicalKey == LogicalKeyboardKey.arrowUp) {
      next = i <= 0 ? ufs.length - 1 : i - 1;
    } else if (e.logicalKey == LogicalKeyboardKey.escape) {
      widget.onSelect!(null);
      return KeyEventResult.handled;
    }
    if (next == null) return KeyEventResult.ignored;
    widget.onSelect!(ufs[next].sigla);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final g = widget.geo.size;
    final aspect = (g.width + _pad.horizontal) / (g.height + _pad.vertical);
    return Focus(
      focusNode: _focus,
      onKeyEvent: _onKey,
      child: AspectRatio(
        aspectRatio: aspect,
        child: LayoutBuilder(
          builder: (context, c) {
            final box = c.biggest;
            final painter = _MapPainter(
              geo: widget.geo,
              pct: widget.pct,
              layer: widget.layer,
              focus: widget.focus,
              selected: widget.selected,
              hover: _hover,
              palette: p,
              transform: _transform(box),
              furniture: widget.furniture,
              labels: widget.labels,
              onSelect: widget.onSelect == null ? null : _select,
              l10n: context.l10n,
              pctText: (v) => context.percent(v, 1),
              regionName: (r) => r.nome(context),
            );
            return MouseRegion(
              cursor: _hover != null && widget.onSelect != null
                  ? SystemMouseCursors.click
                  : MouseCursor.defer,
              onHover: (e) {
                final h = _hit(e.localPosition, box);
                if (h != _hover) setState(() => _hover = h);
              },
              onExit: (_) => setState(() => _hover = null),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (d) {
                  _focus.requestFocus();
                  _select(_hit(d.localPosition, box));
                },
                child: Tooltip(
                  message: _hover == null
                      ? ''
                      : '${widget.geo.bySigla(_hover!).nome} · '
                            '${context.percent(widget.pct[_hover] ?? 0, 1)}',
                  child: CustomPaint(size: box, painter: painter),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.geo,
    required this.pct,
    required this.layer,
    required this.focus,
    required this.selected,
    required this.hover,
    required this.palette,
    required this.transform,
    required this.furniture,
    required this.labels,
    required this.onSelect,
    required this.l10n,
    required this.pctText,
    required this.regionName,
  });

  final BrasilGeo geo;
  final Map<String, double> pct;
  final MapLayer layer;
  final MapFocus? focus;
  final String? selected;
  final String? hover;
  final AtlasPalette palette;
  final Matrix4 transform;
  final bool furniture;
  final bool labels;
  final ValueChanged<String?>? onSelect;
  final AppLocalizations l10n;
  final String Function(double) pctText;
  final String Function(Regiao) regionName;

  double get _scale => transform.storage[0];

  Color _fill(UfShape uf) => layer == MapLayer.regioes
      ? palette.region(uf.regiao)
      : palette.totalizacao(pct[uf.sigla] ?? 0);

  bool _inFocus(UfShape uf) =>
      focus == null || focus!.includes(uf, pct[uf.sigla] ?? 0);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.transform(transform.storage);
    final s = _scale;

    if (furniture) _paintGraticule(canvas, s);

    final fill = Paint()..style = PaintingStyle.fill;
    final seam = Paint()
      ..style = PaintingStyle.stroke
      ..color = palette.plate
      ..strokeWidth = 1.1 / s
      ..strokeJoin = StrokeJoin.round;
    for (final uf in geo.ufs) {
      final c = _fill(uf);
      fill.color = _inFocus(uf) ? c : c.withValues(alpha: palette.halftone);
      canvas.drawPath(uf.path, fill);
      canvas.drawPath(uf.path, seam);
    }

    final region = Paint()
      ..style = PaintingStyle.stroke
      ..color = palette.ink.withValues(alpha: 0.7)
      ..strokeWidth = Stroke.regionBorder / s
      ..strokeJoin = StrokeJoin.round;
    for (final path in geo.regionPaths.values) {
      canvas.drawPath(path, region);
    }

    for (final sigla in [hover, selected]) {
      if (sigla == null) continue;
      canvas.drawPath(
        geo.bySigla(sigla).path,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = palette.ink
          ..strokeWidth = (sigla == selected ? 2.6 : 1.6) / s
          ..strokeJoin = StrokeJoin.round,
      );
    }

    if (labels) _paintLabels(canvas, s);
    if (furniture) _paintFurniture(canvas, s);
    canvas.restore();
  }

  void _paintGraticule(Canvas canvas, double s) {
    final line = Paint()
      ..color = palette.graticule
      ..strokeWidth = 1 / s;
    final key = Paint()
      ..color = palette.ruleStrong
      ..strokeWidth = 1 / s;
    final w = geo.size.width, h = geo.size.height;
    for (var lon = -70; lon <= -35; lon += 5) {
      final x = geo.project(lon.toDouble(), 0).dx;
      canvas.drawLine(Offset(x, -6), Offset(x, h + 6), line);
      _text(
        canvas,
        l10n.mapLongitudeWest(-lon),
        Offset(x, h + 24),
        s,
        center: true,
        muted: true,
      );
    }
    for (var lat = 5; lat >= -30; lat -= 5) {
      final y = geo.project(0, lat.toDouble()).dy;
      if (y < -6 || y > h + 6) continue;
      _dashed(
        canvas,
        Offset(-6, y),
        Offset(w + 6, y),
        lat == 0 ? key : line,
        s,
        lat == 0,
      );
      _text(
        canvas,
        lat == 0 ? '0°' : l10n.mapLatitudeSouth(-lat),
        Offset(-10, y),
        s,
        alignRight: true,
        muted: true,
      );
    }
    final ty = geo.project(0, -23.44).dy;
    _dashed(canvas, Offset(-6, ty), Offset(w + 6, ty), key, s, true);
    _text(canvas, l10n.mapTropic, Offset(w + 8, ty), s, muted: true);
    _text(
      canvas,
      l10n.mapEquator,
      Offset(w + 8, geo.project(0, 0).dy),
      s,
      muted: true,
    );
  }

  void _dashed(Canvas c, Offset a, Offset b, Paint p, double s, bool dashed) {
    if (!dashed) {
      c.drawLine(a, b, p);
      return;
    }
    final len = (b - a).distance, dir = (b - a) / len;
    const dash = 6.0, gap = 5.0;
    for (var d = 0.0; d < len; d += dash + gap) {
      c.drawLine(a + dir * d, a + dir * (d + dash).clamp(0, len), p);
    }
  }

  void _paintLabels(Canvas canvas, double s) {
    final lead = Paint()
      ..color = palette.inkMuted
      ..strokeWidth = 0.9 / s;
    for (final uf in geo.ufs) {
      var at = uf.label;
      final off = BrasilGeo.calloutOffsets[uf.sigla];
      final dim = !_inFocus(uf);
      Color color;
      if (off != null) {
        final to = at + off;
        canvas.drawLine(at, to - const Offset(14, 0), lead);
        canvas.drawCircle(at, 2.2, Paint()..color = palette.inkMuted);
        at = to;
        color = palette.ink;
      } else {
        final f = _fill(uf);
        color = f.computeLuminance() > 0.3
            ? const Color(0xFF16252B)
            : const Color(0xFFFFFFFF);
      }
      if (dim) color = color.withValues(alpha: 0.35);
      final tp = TextPainter(
        text: TextSpan(
          text: uf.sigla,
          style: AtlasType.mapLabel.copyWith(
            color: color,
            fontSize: (12 / s).clamp(13, 30).toDouble(),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, at - Offset(tp.width / 2, tp.height / 2));
    }
  }

  void _paintFurniture(Canvas canvas, double s) {
    final w = geo.size.width, h = geo.size.height;
    final ink = Paint()..color = palette.ink;
    final north = Offset(w - 40, h - 150);
    canvas.drawPath(
      Path()
        ..moveTo(north.dx, north.dy - 26)
        ..lineTo(north.dx + 9, north.dy + 6)
        ..lineTo(north.dx, north.dy)
        ..lineTo(north.dx - 9, north.dy + 6)
        ..close(),
      ink,
    );
    _text(canvas, 'N', north + const Offset(0, -38), s, center: true);
    final u500 = 500 / geo.kmPerUnit;
    final o = Offset(w - u500 - 30, h - 40);
    canvas.drawRect(Rect.fromLTWH(o.dx, o.dy, u500 / 2, 6), ink);
    canvas.drawRect(
      Rect.fromLTWH(o.dx + u500 / 2, o.dy, u500 / 2, 6),
      Paint()
        ..color = palette.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 / s,
    );
    _text(canvas, '0', o + const Offset(0, 20), s, center: true);
    _text(canvas, '250', o + Offset(u500 / 2, 20), s, center: true);
    _text(canvas, '500 km', o + Offset(u500, 20), s, center: true);
  }

  void _text(
    Canvas canvas,
    String text,
    Offset at,
    double s, {
    bool center = false,
    bool alignRight = false,
    bool muted = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: AtlasType.source.copyWith(
          fontSize: (11 / s).clamp(11, 26).toDouble(),
          color: muted ? palette.inkMuted : palette.ink,
          fontWeight: muted ? FontWeight.w500 : FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = center
        ? at.dx - tp.width / 2
        : alignRight
        ? at.dx - tp.width
        : at.dx;
    tp.paint(canvas, Offset(dx, at.dy - tp.height / 2));
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder => (size) {
    return [
      for (final uf in geo.ufs)
        CustomPainterSemantics(
          rect: MatrixUtils.transformRect(transform, uf.path.getBounds()),
          properties: SemanticsProperties(
            label: l10n.mapUfSemantics(
              uf.nome,
              regionName(uf.regiao),
              pctText(pct[uf.sigla] ?? 0),
            ),
            selected: uf.sigla == selected,
            button: onSelect != null,
            textDirection: TextDirection.ltr,
            onTap: onSelect == null ? null : () => onSelect!(uf.sigla),
          ),
        ),
    ];
  };

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.layer != layer ||
      old.focus != focus ||
      old.selected != selected ||
      old.hover != hover ||
      old.palette != palette ||
      old.l10n != l10n ||
      old.transform != transform ||
      old.pct != pct;

  @override
  bool shouldRebuildSemantics(_MapPainter old) =>
      old.selected != selected ||
      old.transform != transform ||
      old.l10n != l10n;
}

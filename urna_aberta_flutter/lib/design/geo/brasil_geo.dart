import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../tokens.dart';

/// One federative unit with its projected outline (atlas units).
class UfShape {
  UfShape({
    required this.code,
    required this.sigla,
    required this.nome,
    required this.regiao,
    required this.path,
    required this.label,
  });

  /// IBGE code (e.g. 29 for Bahia).
  final int code;
  final String sigla;
  final String nome;
  final Regiao regiao;
  final Path path;
  final Offset label;
}

/// Brazil outlines from IBGE's mesh API, projected once at build time.
class BrasilGeo {
  BrasilGeo._(
    this.size,
    this.ufs,
    this.regionPaths,
    this.source,
    this._proj,
  );

  final Size size;
  final Map<String, double> _proj;

  /// Atlas units for a lon/lat pair (same projection as the outlines).
  Offset project(double lon, double lat) => Offset(
    (lon * _proj['k']! - _proj['minx']!) * _proj['s']!,
    (-lat - _proj['miny']!) * _proj['s']!,
  );

  /// Approximate kilometres per atlas unit, for the scale bar.
  double get kmPerUnit => _proj['kmPerUnit']!;
  final List<UfShape> ufs;
  final Map<Regiao, Path> regionPaths;
  final String source;

  /// Small states whose siglas sit outside the outline, on a leader line.
  static const calloutOffsets = <String, Offset>{
    'RN': Offset(60, -24),
    'PB': Offset(74, -4),
    'PE': Offset(82, 16),
    'AL': Offset(66, 30),
    'SE': Offset(56, 46),
    'DF': Offset(60, -46),
    'ES': Offset(62, 10),
    'RJ': Offset(44, 52),
  };

  UfShape bySigla(String sigla) => ufs.firstWhere((u) => u.sigla == sigla);

  static Future<BrasilGeo>? _cache;

  static Future<BrasilGeo> load([AssetBundle? bundle]) {
    return _cache ??= _load(bundle ?? rootBundle);
  }

  static Future<BrasilGeo> _load(AssetBundle bundle) async {
    final raw =
        jsonDecode(await bundle.loadString('assets/geo/brasil_uf.json'))
            as Map<String, dynamic>;
    final ufs = [
      for (final u in raw['ufs'] as List)
        UfShape(
          code: u['code'] as int,
          sigla: u['sigla'] as String,
          nome: u['nome'] as String,
          regiao: Regiao.fromSigla(u['regiao'] as String),
          path: _path(u['rings'] as List),
          label: Offset(
            (u['label'][0] as num).toDouble(),
            (u['label'][1] as num).toDouble(),
          ),
        ),
    ];
    final regions = {
      for (final r in raw['regioes'] as List)
        _ibgeRegion[r['code'] as int]!: _path(r['rings'] as List),
    };
    return BrasilGeo._(
      Size(
        (raw['width'] as num).toDouble(),
        (raw['height'] as num).toDouble(),
      ),
      ufs,
      regions,
      raw['source'] as String,
      {
        for (final e in (raw['proj'] as Map<String, dynamic>).entries)
          e.key: (e.value as num).toDouble(),
      },
    );
  }

  static const _ibgeRegion = {
    1: Regiao.norte,
    2: Regiao.nordeste,
    3: Regiao.sudeste,
    4: Regiao.sul,
    5: Regiao.centroOeste,
  };

  static Path _path(List rings) {
    final path = Path()..fillType = PathFillType.evenOdd;
    for (final ring in rings) {
      final pts = (ring as List).cast<num>();
      path.moveTo(pts[0].toDouble(), pts[1].toDouble());
      for (var i = 2; i < pts.length; i += 2) {
        path.lineTo(pts[i].toDouble(), pts[i + 1].toDouble());
      }
      path.close();
    }
    return path;
  }
}

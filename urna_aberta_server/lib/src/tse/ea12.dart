/// EA12: the municipalities of one election (`mun-e<election>-cm`).
library;

import 'dart:convert';

class Municipio {
  const Municipio({
    required this.uf,
    required this.code,
    required this.ibge,
    required this.name,
    required this.capital,
    required this.zones,
  });

  final String uf;

  /// TSE's 5-digit code, used in file names.
  final int code;
  final int ibge;
  final String name;
  final bool capital;
  final List<int> zones;
}

class Municipalities {
  Municipalities(this.byUf);

  final Map<String, List<Municipio>> byUf;

  Iterable<Municipio> get all => byUf.values.expand((m) => m);

  Municipio? byCode(String uf, int code) =>
      byUf[uf.toLowerCase()]?.where((m) => m.code == code).firstOrNull;
}

/// Parses the JSON payload. Throws [FormatException] when it cannot be read.
Municipalities parseEa12(List<int> bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException catch (e) {
    throw FormatException('EA12 ilegível: ${e.message}');
  }
  if (json case {'abr': final List<Object?> abr}) {
    return Municipalities({
      for (final a in abr)
        if (a case {'cd': final String uf, 'mu': final List<Object?> mus})
          uf.toLowerCase(): [for (final m in mus) _municipio(uf, m)],
    });
  }
  throw const FormatException('EA12 sem lista de UFs (abr)');
}

Municipio _municipio(String uf, Object? m) {
  if (m case {
    'cd': final String cd,
    'cdi': final String cdi,
    'nm': final String nm,
    'c': final String c,
  }) {
    return Municipio(
      uf: uf.toLowerCase(),
      code: int.parse(cd),
      ibge: int.parse(cdi),
      name: nm,
      capital: c == 's',
      zones: [
        if (m['z'] case final List<Object?> z)
          for (final zone in z) int.parse('$zone'),
      ],
    );
  }
  throw FormatException('EA12: município ilegível em $uf');
}

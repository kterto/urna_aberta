/// EA16: the polling sections of one UF, read from its section-config file.
library;

import 'dart:convert';

import '../tse/tse_time.dart';
import '../tse/tse_urls.dart';

class Municipio {
  const Municipio(this.codigo, this.nome);

  final int codigo;
  final String nome;
}

class SectionDirectory {
  SectionDirectory._(this.uf, this._municipios, this._sections);

  final String uf;
  final List<Municipio> _municipios;

  /// municipality → zone → section → aux generation time (UTC), or null
  /// when no urna files arrived.
  final Map<int, Map<int, Map<int, DateTime?>>> _sections;

  /// Municipalities sorted by name.
  List<Municipio> get municipios => _municipios;

  List<int> zonas(int municipio) =>
      (_sections[municipio]?.keys.toList() ?? <int>[])..sort();

  List<int> secoes(int municipio, int zona) =>
      (_sections[municipio]?[zona]?.keys.toList() ?? <int>[])..sort();

  /// Whether TSE lists this section. Lookups outside the list are never
  /// sent to TSE, since a 404 counts toward an IP block.
  bool contains(SectionId id) =>
      id.uf == uf &&
      (_sections[id.municipio]?[id.zona]?.containsKey(id.secao) ?? false);

  /// When TSE generated the section's aux file (EA16 `da`/`ha`), in UTC; null
  /// when none exists yet.
  DateTime? auxGeneratedAt(SectionId id) =>
      id.uf == uf ? (_sections[id.municipio]?[id.zona]?[id.secao]) : null;

  int get sectionCount =>
      _sections.values.expand((z) => z.values).fold(0, (n, s) => n + s.length);
}

/// Reads `<uf>-p<pleito>-cs.json`: abr[].mu[].zon[].sec[] with `ns` and,
/// once the aux file exists, `da`/`ha`. Throws [FormatException] when the
/// file does not have that shape.
SectionDirectory parseSectionConfig(List<int> bytes) {
  final json = jsonDecode(utf8.decode(bytes));
  final abr = json is Map<String, dynamic> ? json['abr'] : null;
  if (abr is! List || abr.length != 1) {
    throw const FormatException('EA16: expected one UF in abr');
  }
  final u = abr.single as Map<String, dynamic>;
  final municipios = <Municipio>[];
  final sections = <int, Map<int, Map<int, DateTime?>>>{};
  for (final m in (u['mu'] as List).cast<Map<String, dynamic>>()) {
    final codigo = _int(m['cd'], 'mu.cd');
    municipios.add(Municipio(codigo, m['nm'] as String));
    final zonas = sections[codigo] = {};
    for (final z in (m['zon'] as List).cast<Map<String, dynamic>>()) {
      final secoes = zonas[_int(z['cd'], 'zon.cd')] = {};
      for (final s in (z['sec'] as List).cast<Map<String, dynamic>>()) {
        secoes[_int(s['ns'], 'sec.ns')] = s['da'] == null
            ? null
            : parseTseDateTime(s['da'], s['ha'], what: 'EA16 da/ha');
      }
    }
  }
  municipios.sort((a, b) => a.nome.compareTo(b.nome));
  return SectionDirectory._(
    (u['cd'] as String).toLowerCase(),
    municipios,
    sections,
  );
}

int _int(Object? v, String field) =>
    (v is String ? int.tryParse(v) : null) ??
    (throw FormatException('EA16: $field "$v" is not a code'));

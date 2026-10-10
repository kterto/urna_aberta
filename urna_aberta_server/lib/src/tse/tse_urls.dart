/// Office codes used in TSE result file names (`c0001`, `c0003`, `c0005`).
enum Office {
  presidente(1),
  governador(3),
  senador(5);

  const Office(this.code);

  final int code;

  String get fileCode => 'c${code.toString().padLeft(4, '0')}';
}

/// Geographic scope of a published file: Brazil (`br`), a UF, or exterior
/// (`zz`). Construction validates the code so no URL can point at a file
/// that does not exist.
class Scope {
  Scope.brazil() : code = 'br';

  Scope.uf(String uf) : code = uf.toLowerCase() {
    if (!ufs.contains(code)) {
      throw ArgumentError.value(uf, 'uf', 'not a UF or exterior (ZZ)');
    }
  }

  /// The 27 federative units plus exterior.
  static const ufs = <String>[
    'ac', 'al', 'ap', 'am', 'ba', 'ce', 'df', 'es', 'go', 'ma', //
    'mt', 'ms', 'mg', 'pa', 'pb', 'pr', 'pe', 'pi', 'rj', 'rn', //
    'rs', 'ro', 'rr', 'sc', 'sp', 'se', 'to', 'zz',
  ];

  final String code;

  bool get isBrazil => code == 'br';
  bool get isExterior => code == 'zz';

  @override
  String toString() => code;
}

/// One polling section: UF (or exterior), municipality, zone and section
/// codes, validated against the widths TSE uses in file names.
class SectionId {
  SectionId({
    required String uf,
    required this.municipio,
    required this.zona,
    required this.secao,
  }) : uf = Scope.uf(uf).code {
    _range(municipio, 'municipio', 99999);
    _range(zona, 'zona', 9999);
    _range(secao, 'secao', 9999);
  }

  final String uf;
  final int municipio;
  final int zona;
  final int secao;

  String get municipio5 => municipio.toString().padLeft(5, '0');
  String get zona4 => zona.toString().padLeft(4, '0');
  String get secao4 => secao.toString().padLeft(4, '0');

  static void _range(int v, String name, int max) {
    if (v < 1 || v > max) {
      throw ArgumentError.value(v, name, 'must be 1 to $max');
    }
  }

  @override
  bool operator ==(Object other) =>
      other is SectionId &&
      other.uf == uf &&
      other.municipio == municipio &&
      other.zona == zona &&
      other.secao == secao;

  @override
  int get hashCode => Object.hash(uf, municipio, zona, secao);

  @override
  String toString() => '$uf/$municipio5/$zona4/$secao4';
}

/// Builds TSE result-publication URLs exactly. TSE files cannot be listed
/// and repeated 404s can get the IP blocked, so every input is validated
/// before a URL exists.
///
/// Patterns from the official simulation docs (HANDOFF.md §2); validate them
/// against the TSE "Instruções para download" PDF before relying on them.
class TseUrls {
  TseUrls({
    required this.host,
    required this.environment,
    required this.cycle,
  });

  TseUrls.oficial()
    : this(
        host: 'resultados.tse.jus.br',
        environment: 'oficial',
        cycle: 'ele2026',
      );

  TseUrls.simulado()
    : this(
        host: 'resultados-sim.tse.jus.br',
        environment: 'simulado',
        cycle: 'simulado2026',
      );

  final String host;
  final String environment;
  final String cycle;

  /// EA11: elections config. Source of the cycle/election/pleito codes.
  Uri electionsConfig() => _uri(['comum', 'config', 'ele-c.json']);

  /// EA12: municipalities config for an election.
  Uri municipalitiesConfig(int election) => _uri([
    cycle,
    '$election',
    'config',
    'mun-e${_election6(election)}-cm.json',
  ]);

  /// EA14: Brazil tracking file, used to detect which UFs changed.
  Uri brazilTracking(int election) => _uri([
    cycle,
    '$election',
    'dados',
    'br',
    'br-e${_election6(election)}-ab.json',
  ]);

  /// EA15: UF tracking file, used to detect which municipalities changed.
  Uri ufTracking(int election, String uf) {
    final scope = Scope.uf(uf);
    return _uri([
      cycle,
      '$election',
      'dados',
      scope.code,
      '${scope.code}-e${_election6(election)}-ab.json',
    ]);
  }

  /// EA16: polling-section config for one UF, with each section's urna-file
  /// arrival date/time (`da`/`ha`). Keyed by pleito, not election.
  Uri sectionConfig(int pleito, String uf) {
    final scope = Scope.uf(uf);
    return _uri([
      cycle,
      'arquivo-urna',
      '$pleito',
      'config',
      scope.code,
      '${scope.code}-p${_election6(pleito)}-cs.json',
    ]);
  }

  /// EA18: one section's aux file, listing the urna files received for it.
  Uri sectionAux(int pleito, SectionId id) => _uri([
    ..._sectionDir(pleito, id),
    'p${_election6(pleito)}-${id.uf}-m${id.municipio5}'
        '-z${id.zona4}-s${id.secao4}-aux.json',
  ]);

  /// A urna file (BU, signatures, RDV, log) named in an aux file. The name
  /// must embed this pleito and section, so an aux entry can never point
  /// the client at another section's folder.
  Uri urnaFile(int pleito, SectionId id, String hash, String name) {
    if (!_hex.hasMatch(hash)) {
      throw ArgumentError.value(hash, 'hash', 'not an even-length hex string');
    }
    final prefix =
        'o${pleito.toString().padLeft(5, '0')}${id.uf}'
        '${id.municipio5}${id.zona4}${id.secao4}-';
    if (!name.startsWith(prefix) ||
        !_urnaSuffix.hasMatch(name.substring(prefix.length))) {
      throw ArgumentError.value(name, 'name', 'not a urna file of $id');
    }
    return _uri([..._sectionDir(pleito, id), hash, name]);
  }

  static final _hex = RegExp(r'^(?:[0-9a-f]{2})+$');
  static final _urnaSuffix = RegExp(r'^[a-z]+\.[a-z]+$');

  List<String> _sectionDir(int pleito, SectionId id) => [
    cycle,
    'arquivo-urna',
    '$pleito',
    'dados',
    id.uf,
    id.municipio5,
    id.zona4,
    id.secao4,
  ];

  /// EA20: unified result file for a scope and office.
  Uri result(int election, Scope scope, Office office) {
    if (scope.isBrazil && office != Office.presidente) {
      throw ArgumentError.value(
        office,
        'office',
        'Brazil scope is President only',
      );
    }
    if (scope.isExterior && office != Office.presidente) {
      throw ArgumentError.value(
        office,
        'office',
        'exterior votes for President only',
      );
    }
    return _uri([
      cycle,
      '$election',
      'dados',
      scope.code,
      '${scope.code}-${office.fileCode}-e${_election6(election)}-u.json',
    ]);
  }

  Uri _uri(List<String> segments) => Uri(
    scheme: 'https',
    host: host,
    pathSegments: [environment, ...segments],
  );

  static String _election6(int election) {
    if (election <= 0 || election > 999999) {
      throw ArgumentError.value(
        election,
        'election',
        'must have 1 to 6 digits',
      );
    }
    return election.toString().padLeft(6, '0');
  }
}

import 'package:flutter/widgets.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

/// What Minha seção needs from the server; [ServerSecaoSource] wraps the
/// generated client.
abstract interface class SecaoSource {
  Future<List<MunicipioRef>> municipios(String uf);
  Future<List<int>> zonas(String uf, int municipio);
  Future<List<int>> secoes(String uf, int municipio, int zona);
  Future<SectionReport> consultar(
    String uf,
    int municipio,
    int zona,
    int secao,
  );
}

class ServerSecaoSource implements SecaoSource {
  ServerSecaoSource(this._client);

  final Client _client;

  @override
  Future<List<MunicipioRef>> municipios(String uf) =>
      _client.secao.municipios(uf);

  @override
  Future<List<int>> zonas(String uf, int municipio) =>
      _client.secao.zonas(uf, municipio);

  @override
  Future<List<int>> secoes(String uf, int municipio, int zona) =>
      _client.secao.secoes(uf, municipio, zona);

  @override
  Future<SectionReport> consultar(
    String uf,
    int municipio,
    int zona,
    int secao,
  ) => _client.secao.consultar(uf, municipio, zona, secao);
}

/// Provides the [SecaoSource] to the screens below it.
class SecaoScope extends InheritedWidget {
  const SecaoScope({super.key, required this.source, required super.child});

  final SecaoSource source;

  static SecaoSource of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SecaoScope>();
    assert(scope != null, 'No SecaoScope above this widget');
    return scope!.source;
  }

  @override
  bool updateShouldNotify(SecaoScope old) => source != old.source;
}

/// UF → município → zona → seção, each list loaded from the server's copy of
/// TSE's section config, then the section's official files.
class SecaoController extends ChangeNotifier {
  SecaoController(this._source);

  final SecaoSource _source;

  /// The 27 UFs and exterior (ZZ), in TSE's lowercase codes.
  static const ufs = [
    'ac', 'al', 'ap', 'am', 'ba', 'ce', 'df', 'es', 'go', 'ma', //
    'mt', 'ms', 'mg', 'pa', 'pb', 'pr', 'pe', 'pi', 'rj', 'rn', //
    'rs', 'ro', 'rr', 'sc', 'sp', 'se', 'to', 'zz',
  ];

  String? _uf;
  List<MunicipioRef> _municipios = const [];
  MunicipioRef? _municipio;
  List<int> _zonas = const [];
  int? _zona;
  List<int> _secoes = const [];
  int? _secao;
  SectionReport? _report;
  Object? _error;
  int _pending = 0;

  /// Bumped on every choice; a response for an older choice is dropped.
  int _generation = 0;

  String? get uf => _uf;
  List<MunicipioRef> get municipios => _municipios;
  MunicipioRef? get municipio => _municipio;
  List<int> get zonas => _zonas;
  int? get zona => _zona;
  List<int> get secoes => _secoes;
  int? get secao => _secao;

  /// A list or the report is loading.
  bool get busy => _pending > 0;
  SectionReport? get report => _report;
  Object? get error => _error;

  bool get canConsult =>
      _uf != null && _municipio != null && _zona != null && _secao != null;

  Future<void> selectUf(String uf) async {
    _uf = uf;
    _municipios = const [];
    _clearFromMunicipio();
    await _load(() => _source.municipios(uf), (v) => _municipios = v);
  }

  Future<void> selectMunicipio(MunicipioRef m) async {
    _municipio = m;
    _clearFromZona();
    await _load(() => _source.zonas(_uf!, m.codigo), (v) => _zonas = v);
  }

  Future<void> selectZona(int zona) async {
    _zona = zona;
    _clearFromSecao();
    await _load(
      () => _source.secoes(_uf!, _municipio!.codigo, zona),
      (v) => _secoes = v,
    );
  }

  void selectSecao(int secao) {
    _secao = secao;
    _report = null;
    _error = null;
    _generation++;
    notifyListeners();
  }

  Future<void> consultar() async {
    if (!canConsult) return;
    _report = null;
    await _load(
      () => _source.consultar(_uf!, _municipio!.codigo, _zona!, _secao!),
      (v) => _report = v,
      bump: false,
    );
  }

  void _clearFromMunicipio() {
    _municipio = null;
    _clearFromZona();
  }

  void _clearFromZona() {
    _zonas = const [];
    _zona = null;
    _clearFromSecao();
  }

  void _clearFromSecao() {
    _secoes = const [];
    _secao = null;
    _report = null;
    _error = null;
  }

  Future<void> _load<T>(
    Future<T> Function() request,
    void Function(T) apply, {
    bool bump = true,
  }) async {
    final generation = bump ? ++_generation : _generation;
    _error = null;
    _pending++;
    notifyListeners();
    try {
      final value = await request();
      if (generation == _generation) apply(value);
    } catch (e) {
      if (generation == _generation) _error = e;
    } finally {
      _pending--;
      notifyListeners();
    }
  }
}

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

/// What Resultados needs from the server; [ServerResultadosSource] wraps the
/// generated client.
abstract interface class ResultadosSource {
  Future<List<ElectionSummary>> eleicoes();
  Future<List<MunicipioRef>> municipios(int eleicao, String uf);
  Future<OfficeReport> resultado(int eleicao, int cargo, String abrangencia);
  Future<ChamberReport> camara(int eleicao);
}

class ServerResultadosSource implements ResultadosSource {
  ServerResultadosSource(this._client);

  final Client _client;

  @override
  Future<List<ElectionSummary>> eleicoes() => _client.resultados.eleicoes();

  @override
  Future<List<MunicipioRef>> municipios(int eleicao, String uf) =>
      _client.resultados.municipios(eleicao, uf);

  @override
  Future<OfficeReport> resultado(int eleicao, int cargo, String abrangencia) =>
      _client.resultados.resultado(eleicao, cargo, abrangencia);

  @override
  Future<ChamberReport> camara(int eleicao) =>
      _client.resultados.camara(eleicao);
}

/// Provides the [ResultadosSource] to the screens below it.
class ResultadosScope extends InheritedWidget {
  const ResultadosScope({
    super.key,
    required this.source,
    required super.child,
  });

  final ResultadosSource source;

  static ResultadosSource of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ResultadosScope>();
    assert(scope != null, 'No ResultadosScope above this widget');
    return scope!.source;
  }

  @override
  bool updateShouldNotify(ResultadosScope old) => source != old.source;
}

/// TSE office codes this app knows, in ballot order.
abstract final class Cargo {
  static const presidente = 1,
      governador = 3,
      senador = 5,
      deputadoFederal = 6,
      deputadoEstadual = 7,
      deputadoDistrital = 8,
      prefeito = 11,
      vereador = 13;

  static bool municipal(int code) => code == prefeito || code == vereador;
}

enum ResultadosLoad { elections, municipios, report }

/// Election → office → UF (→ municipality), then the office's result.
class ResultadosController extends ChangeNotifier {
  ResultadosController(
    this._source, {
    DateTime Function()? now,
    this.autoRefresh = true,
  }) : _now = now ?? DateTime.now;

  final ResultadosSource _source;
  final DateTime Function() _now;

  /// While a count is on, reload every [refreshEvery] (tests turn it off
  /// and call [reload]).
  final bool autoRefresh;
  static const refreshEvery = Duration(seconds: 30);
  Timer? _timer;

  /// The 27 UFs in TSE's lowercase codes.
  static const ufs = [
    'ac', 'al', 'ap', 'am', 'ba', 'ce', 'df', 'es', 'go', 'ma', //
    'mt', 'ms', 'mg', 'pa', 'pb', 'pr', 'pe', 'pi', 'rj', 'rn', //
    'rs', 'ro', 'rr', 'sc', 'sp', 'se', 'to',
  ];

  /// Opening UF: the largest electorate, so the page is never empty.
  static const openingUf = 'sp';

  List<ElectionSummary> _elections = const [];
  ElectionSummary? _election;
  int? _office;
  String? _uf;
  List<MunicipioRef> _municipios = const [];
  MunicipioRef? _municipio;
  OfficeReport? _report;
  ChamberReport? _chamber;
  Object? _error;
  ResultadosLoad? _loading;
  String _query = '';
  int _generation = 0;

  List<ElectionSummary> get elections => _elections;
  ElectionSummary? get election => _election;
  int? get office => _office;
  String? get uf => _uf;
  List<MunicipioRef> get municipios => _municipios;
  MunicipioRef? get municipio => _municipio;
  OfficeReport? get report => _report;

  /// Deputado Federal for Brazil: the Câmara, the 27 state races summed.
  ChamberReport? get chamber => _chamber;
  Object? get error => _error;
  ResultadosLoad? get loading => _loading;
  String get query => _query;

  /// TSE publishes from 17:00 Brasília on election day.
  bool isHeld(ElectionSummary e) =>
      !_now().isBefore(e.day.add(const Duration(hours: 20)));

  bool get notHeldYet => _election != null && !isHeld(_election!);

  /// The result shown is still being counted: TSE will publish more.
  bool get live =>
      _report != null &&
      !_report!.complete &&
      _election != null &&
      isHeld(_election!);

  /// Reads the current result again, keeping it on screen meanwhile.
  Future<void> reload() async {
    final e = _election, s = scope, office = _office;
    if (e == null || s == null || office == null || _report == null) return;
    final generation = _generation;
    try {
      final r = await _source.resultado(e.code, office, s);
      if (generation != _generation) return;
      _report = r;
      notifyListeners();
    } on Object {
      // Keep the last numbers; the next reload tries again.
    }
    _schedule();
  }

  void _schedule() {
    _timer?.cancel();
    _timer = autoRefresh && live ? Timer(refreshEvery, reload) : null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// One entry per voting day (newest first): TSE splits a day into
  /// several elections (federal, state), which voters see as one.
  List<ElectionSummary> get rounds {
    final seen = <DateTime>{};
    return [
      for (final e in _elections)
        if (seen.add(e.day)) e,
    ];
  }

  /// Every office voted on the chosen day, in ballot order.
  List<int> get offices => {
    for (final e in _elections)
      if (e.day == _election?.day) ...e.offices,
  }.toList()..sort();

  bool get municipal => _office != null && Cargo.municipal(_office!);

  /// Where the chosen office is elected: Brazil, abroad and every UF for
  /// President; the UFs that elect it otherwise.
  List<String> get scopes => switch (_office) {
    Cargo.presidente => ['br', ...ufs, 'zz'],
    Cargo.deputadoEstadual => [
      for (final u in ufs)
        if (u != 'df') u,
    ],
    Cargo.deputadoDistrital => ['df'],
    Cargo.deputadoFederal => ['br', ...ufs],
    null => const [],
    _ => ufs,
  };

  /// The scope the report is for: `br`, a UF, `zz` or `sp71072`.
  String? get scope {
    if (_uf == null) return null;
    if (!municipal) return _uf;
    final m = _municipio;
    return m == null ? null : '$_uf${m.codigo.toString().padLeft(5, '0')}';
  }

  /// The report's candidates matching the search, by votes.
  List<CandidateReport> get candidates {
    final all = _report?.candidates ?? const <CandidateReport>[];
    final q = _fold(_query.trim());
    if (q.isEmpty) return all;
    return [
      for (final c in all)
        if (_fold(c.ballotName).contains(q) ||
            '${c.number}'.startsWith(q) ||
            _fold(c.party) == q)
          c,
    ];
  }

  Future<void> start() async {
    _loading = ResultadosLoad.elections;
    notifyListeners();
    try {
      _elections = await _source.eleicoes();
    } on Object catch (e) {
      _error = e;
      _loading = null;
      notifyListeners();
      return;
    }
    final held = _elections.where(isHeld).toList();
    // Newest held election; on a shared day, the one electing more offices.
    held.sort((a, b) {
      final byDay = b.day.compareTo(a.day);
      return byDay != 0 ? byDay : b.offices.length.compareTo(a.offices.length);
    });
    final first = held.firstOrNull ?? _elections.firstOrNull;
    if (first == null) {
      _loading = null;
      notifyListeners();
      return;
    }
    await selectElection(first);
  }

  Future<void> selectElection(ElectionSummary e) async {
    final previous = _office;
    _election = e;
    final keep = _office != null && e.offices.contains(_office);
    _office = keep
        ? _office
        : e.offices.contains(Cargo.deputadoFederal)
        ? Cargo.deputadoFederal
        : e.offices.first;
    _municipio = null;
    _municipios = const [];
    _fitUf(from: previous);
    await _refresh();
  }

  /// Chooses a voting day, keeping the office when that day elects it.
  Future<void> selectRound(ElectionSummary day) async {
    final sameDay = _elections.where((e) => e.day == day.day);
    final keep = sameDay.where((e) => e.offices.contains(_office));
    final withDeputies = sameDay.where(
      (e) => e.offices.contains(Cargo.deputadoFederal),
    );
    await selectElection(
      keep.firstOrNull ?? withDeputies.firstOrNull ?? sameDay.first,
    );
  }

  Future<void> selectOffice(int code) async {
    final wasMunicipal = municipal;
    final previous = _office;
    final e = _election;
    if (e != null && !e.offices.contains(code)) {
      _election = _elections.firstWhere(
        (x) => x.day == e.day && x.offices.contains(code),
      );
    }
    _office = code;
    if (wasMunicipal != municipal) _municipio = null;
    _fitUf(from: previous);
    await _refresh();
  }

  Future<void> selectUf(String uf) async {
    _uf = uf;
    _municipio = null;
    _municipios = const [];
    await _refresh();
  }

  Future<void> selectMunicipio(MunicipioRef m) async {
    _municipio = m;
    await _refresh();
  }

  void search(String query) {
    _query = query;
    notifyListeners();
  }

  /// Keeps the UF when the office is elected there, else the first that is.
  /// Presidente opens on Brazil: it is a national race.
  void _fitUf({int? from}) {
    if (_office == Cargo.presidente && from != Cargo.presidente) _uf = 'br';
    final options = municipal ? ufs : scopes;
    if (_uf == null || !options.contains(_uf)) {
      _uf = options.contains(openingUf) ? openingUf : options.firstOrNull;
      _municipio = null;
      _municipios = const [];
    }
  }

  Future<void> _refresh() async {
    final generation = ++_generation;
    _report = null;
    _chamber = null;
    _error = null;
    final e = _election;
    if (e == null || !isHeld(e) || _office == null || _uf == null) {
      _loading = null;
      notifyListeners();
      return;
    }
    try {
      if (municipal && _municipios.isEmpty) {
        _loading = ResultadosLoad.municipios;
        notifyListeners();
        final all = await _source.municipios(e.code, _uf!);
        if (generation != _generation) return;
        final covered = e.allMunicipalities
            ? all
            : [
                for (final m in all)
                  if (e.municipalScopes.contains(
                    '$_uf${m.codigo.toString().padLeft(5, '0')}',
                  ))
                    m,
              ];
        _municipios = covered..sort((a, b) => a.nome.compareTo(b.nome));
      }
      final s = scope;
      if (s == null) {
        _loading = null;
        notifyListeners();
        return;
      }
      _loading = ResultadosLoad.report;
      notifyListeners();
      if (_office == Cargo.deputadoFederal && s == 'br') {
        final chamber = await _source.camara(e.code);
        if (generation != _generation) return;
        _chamber = chamber;
      } else {
        final r = await _source.resultado(e.code, _office!, s);
        if (generation != _generation) return;
        _report = r;
      }
    } on Object catch (err) {
      if (generation != _generation) return;
      _error = err;
    }
    _loading = null;
    notifyListeners();
    _schedule();
  }

  static String _fold(String s) {
    const from = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const to = 'aaaaaeeeeiiiiooooouuuucn';
    final lower = s.toLowerCase();
    final b = StringBuffer();
    for (final ch in lower.split('')) {
      final i = from.indexOf(ch);
      b.write(i < 0 ? ch : to[i]);
    }
    return b.toString();
  }
}

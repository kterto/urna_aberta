import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import '../resultados/resultados_controller.dart';
import '../secao/secao_controller.dart';
import 'relatorios_source.dart';

/// A place as one code, as the server writes it: `br`, `n`, `ac`,
/// `ac01066`, `ac01066z0004`, `ac01066z0004s0077`.
String placeKey(ReportPlace p) {
  String pad(int v, int w) => v.toString().padLeft(w, '0');
  final city = p.municipio == null ? '' : '${p.uf}${pad(p.municipio!, 5)}';
  return switch (p.kind) {
    ReportPlaceKind.br => 'br',
    ReportPlaceKind.regiao => p.regiao!,
    ReportPlaceKind.uf => p.uf!,
    ReportPlaceKind.municipio => city,
    ReportPlaceKind.zona => '${city}z${pad(p.zona!, 4)}',
    ReportPlaceKind.secao => '${city}z${pad(p.zona!, 4)}s${pad(p.secao!, 4)}',
  };
}

/// The city a place lies in, as a [placeKey] (`ac01066`); null above it.
String? cityKey(ReportPlace p) => p.municipio == null
    ? null
    : '${p.uf}${p.municipio.toString().padLeft(5, '0')}';

/// Where a report opens from: Resultados or Minha seção fill in what the
/// viewer was looking at.
class ReportDraft {
  const ReportDraft({
    this.day,
    this.offices = const {},
    this.places = const [],
    this.names = const {},
  });

  /// The voting day (all of TSE's elections that day).
  final DateTime? day;
  final Set<int> offices;
  final List<ReportPlace> places;

  /// City names by [cityKey].
  final Map<String, String> names;
}

/// The "Novo relatório" form: voting days, offices, places, breakdown and
/// language, quoted by the server as they change.
class NovoRelatorioController extends ChangeNotifier {
  NovoRelatorioController({
    required this._reports,
    required this._results,
    this.sections,
    this._draft = const ReportDraft(),
    this._language = 'pt',
    this.debounce = const Duration(milliseconds: 400),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final RelatoriosSource _reports;
  final ResultadosSource _results;

  /// Zones and sections come from Minha seção's source (2026 1st round).
  final SecaoSource? sections;
  final ReportDraft _draft;
  final Duration debounce;
  final DateTime Function() _now;

  /// The one voting day Minha seção's section lists cover.
  static final sectionsDay = DateTime.utc(2026, 10, 4);

  List<ElectionSummary> _elections = const [];
  Object? _loadError;
  bool _loading = false;
  final _days = <DateTime>{};
  final _offices = <int>{};
  final _places = <ReportPlace>[];
  final _names = <String, String>{};
  ReportBreakdown _breakdown = ReportBreakdown.none;
  String _language;
  bool _signedIn = false;

  ReportQuote? _quote;
  ReportRefused? _refusal;
  Object? _quoteError;
  bool _quoting = false;
  bool _submitting = false;
  Timer? _timer;
  int _generation = 0;
  final _cities = <(int, String), Future<List<MunicipioRef>>>{};

  bool get loading => _loading;
  Object? get loadError => _loadError;
  Set<DateTime> get days => Set.unmodifiable(_days);
  Set<int> get offices => Set.unmodifiable(_offices);
  List<ReportPlace> get places => List.unmodifiable(_places);
  ReportBreakdown get breakdown => _breakdown;
  String get language => _language;
  bool get signedIn => _signedIn;
  ReportQuote? get quote => _quote;

  /// The server refused the spec (too large, nothing to read…).
  ReportRefused? get refusal => _refusal;
  Object? get quoteError => _quoteError;
  bool get quoting => _quoting;
  bool get submitting => _submitting;

  /// The name of the city a place lies in; null above city level.
  String? cityName(ReportPlace p) => _names[cityKey(p)];

  /// TSE publishes from 17:00 Brasília on election day.
  bool _held(ElectionSummary e) =>
      !_now().isBefore(e.day.add(const Duration(hours: 20)));

  /// One entry per voting day TSE has published, newest first.
  List<ElectionSummary> get rounds {
    final seen = <DateTime>{};
    return [
      for (final e in _elections)
        if (_held(e) && seen.add(e.day)) e,
    ];
  }

  List<ElectionSummary> get _chosen => [
    for (final e in _elections)
      if (_days.contains(e.day)) e,
  ];

  /// Offices voted on the chosen days, in ballot order.
  List<int> get availableOffices =>
      {for (final e in _chosen) ...e.offices}.toList()..sort();

  /// Zones and sections can be listed only for Minha seção's round.
  bool get sectionsAvailable =>
      sections != null && _days.length == 1 && _days.single == sectionsDay;

  ReportSpec? get spec {
    final offices = [
      for (final o in availableOffices)
        if (_offices.contains(o)) o,
    ];
    if (_chosen.isEmpty || offices.isEmpty || _places.isEmpty) return null;
    return ReportSpec(
      elections: [for (final e in _chosen) e.code],
      offices: offices,
      places: List.of(_places),
      breakdown: _breakdown,
      language: _language,
    );
  }

  Future<void> start() async {
    _loading = true;
    _loadError = null;
    notifyListeners();
    try {
      _elections = await _results.eleicoes();
    } on Object catch (e) {
      _loadError = e;
    }
    _loading = false;
    final rounds = this.rounds;
    final day = _draft.day;
    if (day != null && rounds.any((r) => r.day == day)) {
      _days.add(day);
    } else if (rounds.isNotEmpty) {
      _days.add(rounds.first.day);
    }
    _offices.addAll(_draft.offices.where(availableOffices.contains));
    _places.addAll(_draft.places);
    _names.addAll(_draft.names);
    _requote();
  }

  void setSignedIn(bool value) {
    if (value == _signedIn) return;
    _signedIn = value;
    _requote();
  }

  void toggleDay(DateTime day) {
    if (!_days.remove(day)) _days.add(day);
    if (!sectionsAvailable) {
      _places.removeWhere(
        (p) =>
            p.kind == ReportPlaceKind.zona || p.kind == ReportPlaceKind.secao,
      );
    }
    _requote();
  }

  void toggleOffice(int office) {
    if (!_offices.remove(office)) _offices.add(office);
    _requote();
  }

  /// Adds [place] unless it is already there; [city] names its city.
  void addPlace(ReportPlace place, {String? city}) {
    final key = placeKey(place);
    if (_places.any((p) => placeKey(p) == key)) return;
    _places.add(place);
    if (city != null && cityKey(place) != null) _names[cityKey(place)!] = city;
    _requote();
  }

  void removePlace(ReportPlace place) {
    final key = placeKey(place);
    _places.removeWhere((p) => placeKey(p) == key);
    _requote();
  }

  void setBreakdown(ReportBreakdown value) {
    _breakdown = value;
    _requote();
  }

  void setLanguage(String value) {
    _language = value;
    _requote();
  }

  /// The cities of [uf] in the first chosen election's EA12.
  Future<List<MunicipioRef>> municipios(String uf) {
    final election = _chosen.firstOrNull?.code;
    if (election == null) return Future.value(const []);
    final key = (election, uf);
    final pending = _cities[key] ??= _results.municipios(election, uf);
    // A failed load is retried next time.
    pending.ignore();
    return pending.catchError((Object e) {
      _cities.remove(key);
      throw e;
    });
  }

  Future<List<int>> zonas(String uf, int municipio) =>
      sections?.zonas(uf, municipio) ?? Future.value(const []);

  Future<List<int>> secoes(String uf, int municipio, int zona) =>
      sections?.secoes(uf, municipio, zona) ?? Future.value(const []);

  void _requote() {
    _timer?.cancel();
    final generation = ++_generation;
    _quote = null;
    _refusal = null;
    _quoteError = null;
    final spec = this.spec;
    _quoting = spec != null && _signedIn;
    notifyListeners();
    if (!_quoting) return;
    _timer = Timer(debounce, () async {
      try {
        final q = await _reports.orcar(spec!);
        if (generation != _generation) return;
        _quote = q;
      } on ReportRefused catch (e) {
        if (generation != _generation) return;
        _refusal = e;
      } on Object catch (e) {
        if (generation != _generation) return;
        _quoteError = e;
      }
      _quoting = false;
      notifyListeners();
    });
  }

  /// Queues the report. Returns it, or null when the server refused it
  /// ([refusal] says why). Other failures are rethrown.
  Future<ReportRequest?> submit() async {
    final spec = this.spec;
    if (spec == null || _quote == null || _submitting) return null;
    _submitting = true;
    notifyListeners();
    try {
      return await _reports.pedir(spec);
    } on ReportRefused catch (e) {
      _refusal = e;
      _quote = null;
      return null;
    } finally {
      _submitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

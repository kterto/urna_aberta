import '../tse/tse_urls.dart';

/// One published result (a UF, exterior, or Brazil), normalized from EA20.
class ScopeResult {
  ScopeResult({
    required this.scope,
    required this.sectionsTotal,
    required this.sectionsTotalized,
    required this.votes,
    this.generatedAt,
    this.candidates = const {},
  });

  /// Lowercase scope code: a UF, `zz` or `br`.
  final String scope;
  final int sectionsTotal;
  final int sectionsTotalized;

  /// Votes by candidate number.
  final Map<int, int> votes;

  /// When TSE generated the file, in UTC.
  final DateTime? generatedAt;

  /// Ballot name and party by candidate number.
  final Map<int, CandidateInfo> candidates;

  double get sectionsTotalizedPct =>
      sectionsTotal == 0 ? 0 : sectionsTotalized * 100 / sectionsTotal;
}

/// How a candidacy appears on the ballot.
class CandidateInfo {
  const CandidateInfo({required this.ballotName, required this.party});

  final String ballotName;
  final String party;
}

/// The independent national figure: the sum of the per-UF files.
class StateSum {
  StateSum._(this._totalized, this._total, this.votes, this.missing);

  final int _totalized;
  final int _total;

  /// Votes by candidate number, summed over every received scope.
  final Map<int, int> votes;

  /// Expected scopes with no file yet. The sum never estimates them.
  final List<String> missing;

  bool get complete => missing.isEmpty;

  /// Sections totalized over sections, across all received scopes.
  double get sectionsTotalizedPct =>
      _total == 0 ? 0 : _totalized * 100 / _total;
}

/// Sums per-UF results. [expected] defaults to the 27 UFs plus exterior.
StateSum sumOfStates(List<ScopeResult> results, {List<String>? expected}) {
  final seen = <String>{};
  var totalized = 0, total = 0;
  final votes = <int, int>{};
  for (final r in results) {
    if (!seen.add(r.scope)) {
      throw ArgumentError.value(r.scope, 'results', 'duplicate scope');
    }
    totalized += r.sectionsTotalized;
    total += r.sectionsTotal;
    r.votes.forEach((n, v) => votes[n] = (votes[n] ?? 0) + v);
  }
  final missing = [
    for (final s in expected ?? Scope.ufs)
      if (!seen.contains(s)) s,
  ];
  return StateSum._(totalized, total, votes, missing);
}

/// The national file and the sum of states at one moment.
class Comparison {
  Comparison({
    required this.at,
    required this.nationalPct,
    required this.statesPct,
  });

  final DateTime at;
  final double nationalPct;
  final double statesPct;

  /// Positive when the national file lags the states.
  double get gap => statesPct - nationalPct;
}

/// A period when the national file lagged the sum of states.
class DivergenceEvent {
  DivergenceEvent._(this.startedAt, this.nationalPctAtStart, this.maxGap);

  final DateTime startedAt;
  final double nationalPctAtStart;
  DateTime? endedAt;
  double maxGap;

  bool get isOpen => endedAt == null;
}

/// Gap, in percentage points of sections totalized, that opens an event.
const divergenceThresholdPp = 0.5;

/// Finds periods when the national file lagged the states by more than
/// [threshold] percentage points. [samples] must be in time order.
List<DivergenceEvent> detectDivergence(
  List<Comparison> samples, {
  double threshold = divergenceThresholdPp,
}) {
  final events = <DivergenceEvent>[];
  DivergenceEvent? open;
  for (var i = 0; i < samples.length; i++) {
    final s = samples[i];
    if (i > 0 && s.at.isBefore(samples[i - 1].at)) {
      throw ArgumentError.value(samples, 'samples', 'not in time order');
    }
    final lagging = s.gap > threshold;
    if (lagging && open == null) {
      open = DivergenceEvent._(s.at, s.nationalPct, s.gap);
      events.add(open);
    } else if (lagging) {
      if (s.gap > open!.maxGap) open.maxGap = s.gap;
    } else if (open != null) {
      open.endedAt = s.at;
      open = null;
    }
  }
  return events;
}

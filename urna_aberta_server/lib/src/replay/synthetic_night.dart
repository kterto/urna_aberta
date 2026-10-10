import 'dart:math' as math;

import '../tally/aggregator.dart';
import '../tse/tse_urls.dart';

/// A synthetic election night that ends exactly at real final files.
///
/// Final files show only the end state, so the hours before are interpolated:
/// each UF follows its own S-curve toward its final counts, and the national
/// file stops updating between [freezeStart] and [freezeEnd]. Nothing here
/// before [end] is an official figure; it must be shown as a simulation.
class SyntheticNight {
  SyntheticNight({
    required List<ScopeResult> finals,
    required this.start,
    required this.end,
    required this.freezeStart,
    required this.freezeEnd,
    this.freezePct = 64.81,
  }) : _finals = [...finals]..sort((a, b) => a.scope.compareTo(b.scope)) {
    final scopes = _finals.map((f) => f.scope).toSet();
    if (scopes.length != _finals.length ||
        !scopes.containsAll(Scope.ufs) ||
        scopes.length != Scope.ufs.length) {
      throw ArgumentError.value(
        finals.map((f) => f.scope).toList(),
        'finals',
        'needs exactly one file per UF plus exterior',
      );
    }
    if (!(start.isBefore(freezeStart) &&
        freezeStart.isBefore(freezeEnd) &&
        freezeEnd.isBefore(end))) {
      throw ArgumentError('needs start < freezeStart < freezeEnd < end');
    }
    _midpoint = _solveMidpoint();
    _frozen = _sum(_statesAt(freezeStart), freezeStart);
  }

  final DateTime start, end, freezeStart, freezeEnd;

  /// The national % the freeze should land on; reached to within rounding.
  final double freezePct;

  final List<ScopeResult> _finals;
  late final double _midpoint;
  late final ScopeResult _frozen;

  /// Every UF plus exterior at [at], sorted by scope.
  List<ScopeResult> states(DateTime at) => _statesAt(at);

  /// The national (`br`) file at [at]: the sum of states, except while frozen.
  ScopeResult national(DateTime at) {
    if (!at.isBefore(freezeStart) && at.isBefore(freezeEnd)) {
      return ScopeResult(
        scope: 'br',
        sectionsTotal: _frozen.sectionsTotal,
        sectionsTotalized: _frozen.sectionsTotalized,
        votes: _frozen.votes,
        generatedAt: freezeStart,
      );
    }
    return _sum(_statesAt(at), at);
  }

  List<ScopeResult> _statesAt(DateTime at, [double? midpoint]) {
    final x = _progress(at);
    return [
      for (final f in _finals)
        _scaled(f, _curve(x, f.scope, midpoint ?? _midpoint), at),
    ];
  }

  ScopeResult _scaled(ScopeResult f, double share, DateTime at) => ScopeResult(
    scope: f.scope,
    sectionsTotal: f.sectionsTotal,
    sectionsTotalized: (f.sectionsTotalized * share).round(),
    votes: {for (final e in f.votes.entries) e.key: (e.value * share).round()},
    generatedAt: at,
  );

  ScopeResult _sum(List<ScopeResult> states, DateTime at) {
    final s = sumOfStates(states);
    var total = 0, totalized = 0;
    for (final r in states) {
      total += r.sectionsTotal;
      totalized += r.sectionsTotalized;
    }
    return ScopeResult(
      scope: 'br',
      sectionsTotal: total,
      sectionsTotalized: totalized,
      votes: s.votes,
      generatedAt: at,
    );
  }

  /// Night progress in [0, 1].
  double _progress(DateTime at) {
    final span = end.difference(start).inMicroseconds;
    final x = at.difference(start).inMicroseconds / span;
    return x.clamp(0.0, 1.0);
  }

  /// Share of a UF's final counts reached at progress [x]: a logistic curve
  /// rescaled to run exactly from 0 at [start] to 1 at [end]. Each UF gets a
  /// fixed offset and steepness derived from its code, so runs are repeatable.
  static double _curve(double x, String scope, double midpoint) {
    final h = scope.codeUnits.fold(7, (a, c) => (a * 31 + c) % 1000003);
    final offset = ((h % 1000) / 1000 - 0.5) * 0.16;
    final k = 8 + (h ~/ 1000 % 1000) / 1000 * 4;
    final m = midpoint + offset;
    double l(double v) => 1 / (1 + math.exp(-k * (v - m)));
    final l0 = l(0), l1 = l(1);
    return (l(x) - l0) / (l1 - l0);
  }

  /// The base midpoint that puts the sum of states at [freezePct] when the
  /// national file freezes. A later midpoint means a slower night.
  double _solveMidpoint() {
    var lo = -1.0, hi = 2.0;
    for (var i = 0; i < 60; i++) {
      final mid = (lo + hi) / 2;
      final pct = _sum(
        _statesAt(freezeStart, mid),
        freezeStart,
      ).sectionsTotalizedPct;
      if (pct > freezePct) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return (lo + hi) / 2;
  }
}

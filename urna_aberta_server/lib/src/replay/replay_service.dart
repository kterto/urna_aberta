import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../ingestion/snapshot_store.dart';
import '../tally/aggregator.dart' as tally;
import '../tse/tse_urls.dart';
import 'synthetic_night.dart';

/// Builds and caches the replay night from stored final files.
///
/// Before the newest final file's TSE time every frame is synthetic; from
/// then on frames are the stored files themselves.
abstract final class ReplayService {
  static const electionCode = 6257;
  static const office = Office.presidente;

  /// Brasília time (UTC-3), as UTC.
  static DateTime _brt(int day, int hour, int minute) =>
      DateTime.utc(2026, 10, day, hour + 3, minute);

  static final start = _brt(4, 17, 0);
  static final end = _brt(5, 1, 0);
  static final freezeStart = _brt(4, 21, 2);
  static final freezeEnd = _brt(4, 21, 57);

  static const maxTimelinePoints = 2000;

  static Future<_Loaded>? _cache;

  /// Drops the cached night, e.g. after the stored files change.
  static void resetCache() => _cache = null;

  static Future<_Loaded> _loaded(Session session) {
    final cached = _cache ??= _load(session);
    cached.ignore();
    return cached.catchError((Object e) {
      _cache = null;
      throw e;
    });
  }

  static Future<_Loaded> _load(Session session) async {
    final rows = await SnapshotStore.latestAt(
      session,
      origin: DataOrigin.replay,
      electionCode: electionCode,
      office: office,
      at: DateTime.utc(9999),
    );
    final national = rows.where((r) => r.scope == 'br').firstOrNull;
    final states = rows.where((r) => r.scope != 'br').toList();
    final missing = tally.sumOfStates(states).missing;
    if (national == null || missing.isNotEmpty) {
      throw ReplayUnavailableException(
        message:
            'Archived final files are not stored '
            '(missing: ${[if (national == null) 'br', ...missing].join(', ')}).',
      );
    }
    return _Loaded(
      SyntheticNight(
        finals: states,
        start: start,
        end: end,
        freezeStart: freezeStart,
        freezeEnd: freezeEnd,
      ),
      national,
      states,
      [
        national,
        ...states,
      ].map((r) => r.generatedAt!).reduce((a, b) => a.isAfter(b) ? a : b),
    );
  }

  static Future<ReplayNight> night(Session session) async {
    final l = await _loaded(session);
    return ReplayNight(
      origin: DataOrigin.synthetic,
      electionCode: electionCode,
      officeCode: office.code,
      start: start,
      end: end,
      freezeStart: freezeStart,
      freezeEnd: freezeEnd,
      finalsGeneratedAt: l.finalsGeneratedAt,
    );
  }

  static Future<TallyFrame> frame(Session session, DateTime at) async {
    final l = await _loaded(session);
    final (origin, national, states) = l.at(at);
    final sum = tally.sumOfStates(states);
    final numbers = {...national.votes.keys, ...sum.votes.keys};
    return TallyFrame(
      at: at,
      origin: origin,
      nationalPct: national.sectionsTotalizedPct,
      statesPct: sum.sectionsTotalizedPct,
      missingScopes: sum.missing,
      candidates: [
        for (final n in numbers)
          CandidateVotes(
            candidateNumber: n,
            national: national.votes[n] ?? 0,
            states: sum.votes[n] ?? 0,
            ballotName: l.national.candidates[n]?.ballotName,
            party: l.national.candidates[n]?.party,
          ),
      ]..sort((a, b) => b.states.compareTo(a.states)),
      ufs: [
        for (final s in states)
          UfProgress(
            scopeCode: s.scope,
            sectionsTotal: s.sectionsTotal,
            sectionsTotalized: s.sectionsTotalized,
          ),
      ]..sort((a, b) => a.scopeCode.compareTo(b.scopeCode)),
    );
  }

  static Future<List<TimelinePoint>> timeline(
    Session session,
    DateTime from,
    DateTime to,
    Duration step,
  ) async {
    if (step <= Duration.zero || to.isBefore(from)) {
      throw ArgumentError('needs from <= to and a positive step');
    }
    final count = to.difference(from).inMicroseconds ~/ step.inMicroseconds + 1;
    if (count > maxTimelinePoints) {
      throw ArgumentError.value(
        count,
        'points',
        'over $maxTimelinePoints; use a larger step',
      );
    }
    final l = await _loaded(session);
    return [
      for (var i = 0; i < count; i++) l.point(from.add(step * i)),
    ];
  }

  /// Lag events seen up to [at], sampled every minute of the night.
  static Future<List<DivergenceEvent>> divergence(
    Session session,
    DateTime at,
  ) async {
    final l = await _loaded(session);
    final last = at.isBefore(end) ? at : end;
    final samples = <tally.Comparison>[];
    for (
      var t = start;
      !t.isAfter(last);
      t = t.add(const Duration(minutes: 1))
    ) {
      final p = l.point(t);
      samples.add(
        tally.Comparison(
          at: t,
          nationalPct: p.nationalPct,
          statesPct: p.statesPct,
        ),
      );
    }
    return [
      for (final e in tally.detectDivergence(samples))
        DivergenceEvent(
          origin: DataOrigin.synthetic,
          electionCode: electionCode,
          startedAt: e.startedAt,
          endedAt: e.endedAt,
          nationalPctAtStart: e.nationalPctAtStart,
          maxGap: e.maxGap,
        ),
    ];
  }
}

class _Loaded {
  _Loaded(this.synthetic, this.national, this.states, this.finalsGeneratedAt);

  final SyntheticNight synthetic;
  final tally.ScopeResult national;
  final List<tally.ScopeResult> states;
  final DateTime finalsGeneratedAt;

  (DataOrigin, tally.ScopeResult, List<tally.ScopeResult>) at(DateTime t) =>
      t.isBefore(finalsGeneratedAt)
      ? (DataOrigin.synthetic, synthetic.national(t), synthetic.states(t))
      : (DataOrigin.replay, national, states);

  TimelinePoint point(DateTime t) {
    final (_, n, s) = at(t);
    return TimelinePoint(
      at: t,
      nationalPct: n.sectionsTotalizedPct,
      statesPct: tally.sumOfStates(s).sectionsTotalizedPct,
    );
  }
}

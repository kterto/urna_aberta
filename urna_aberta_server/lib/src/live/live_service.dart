import 'package:serverpod/serverpod.dart' hide Scope;

import '../generated/protocol.dart';
import '../ingestion/snapshot_store.dart';
import '../tally/aggregator.dart' as tally;
import '../tally/frame.dart';
import '../tse/tse_urls.dart';
import 'elections.dart';
import 'live_poll_call.dart';

/// The presidential count as stored by [LivePollCall]: which election is
/// (or will be) live, and the national file vs the sum of states from the
/// latest stored versions.
abstract final class LiveService {
  /// Elections known to the server; tests replace it.
  static List<Election> Function() elections = () =>
      LivePollCall.ingestor?.elections ?? const [];

  static const maxTimelinePoints = 2000;

  static Future<LiveStatus> status(Session session, {DateTime? now}) async {
    final at = (now ?? DateTime.now()).toUtc();
    final presidential = [
      for (final e in elections())
        if (e.targets.contains((Scope.brazil(), Office.presidente))) e,
    ]..sort((a, b) => a.opensAt.compareTo(b.opensAt));

    final election = await _pick(session, presidential, at);
    if (election == null) {
      return LiveStatus(open: false, timeline: [], divergence: []);
    }
    final rows = await SnapshotStore.latestAt(
      session,
      origin: DataOrigin.live,
      electionCode: election.code,
      office: Office.presidente,
      at: DateTime.utc(9999),
    );
    final timeline = await _timeline(session, election.code);
    return LiveStatus(
      electionCode: election.code,
      round: election.round,
      opensAt: election.opensAt,
      closesAt: election.closesAt,
      open: election.isLiveAt(at),
      frame: rows.isEmpty
          ? null
          : buildTallyFrame(
              at: rows
                  .map((r) => r.generatedAt!)
                  .reduce((a, b) => a.isAfter(b) ? a : b),
              origin: DataOrigin.live,
              national: rows.where((r) => r.scope == 'br').firstOrNull,
              states: rows.where((r) => r.scope != 'br').toList(),
            ),
      timeline: timeline,
      divergence: [
        for (final e in tally.detectDivergence([
          for (final p in timeline)
            tally.Comparison(
              at: p.at,
              nationalPct: p.nationalPct,
              statesPct: p.statesPct,
            ),
        ]))
          DivergenceEvent(
            origin: DataOrigin.live,
            electionCode: election.code,
            startedAt: e.startedAt,
            endedAt: e.endedAt,
            nationalPctAtStart: e.nationalPctAtStart,
            maxGap: e.maxGap,
          ),
      ],
    );
  }

  /// The one live now; else the latest past one with stored files; else
  /// the next one; else the latest past one.
  static Future<Election?> _pick(
    Session session,
    List<Election> presidential,
    DateTime at,
  ) async {
    final live = presidential.where((e) => e.isLiveAt(at)).firstOrNull;
    if (live != null) return live;
    final past = presidential.where((e) => !e.opensAt.isAfter(at)).toList();
    for (final e in past.reversed) {
      final stored = await ResultSnapshot.db.count(
        session,
        where: (t) =>
            t.origin.equals(DataOrigin.live) & t.electionCode.equals(e.code),
      );
      if (stored > 0) return e;
    }
    return presidential.where((e) => e.opensAt.isAfter(at)).firstOrNull ??
        past.lastOrNull;
  }

  /// National and state-sum progress each time a stored file changed.
  static Future<List<TimelinePoint>> _timeline(
    Session session,
    int electionCode,
  ) async {
    final rows = await ResultSnapshot.db.find(
      session,
      where: (t) =>
          t.origin.equals(DataOrigin.live) &
          t.electionCode.equals(electionCode) &
          t.officeCode.equals(Office.presidente.code) &
          (t.signature.equals(null) |
              t.signature.equals(SignatureStatus.valid)),
      orderBy: (t) => t.tseGeneratedAt,
    );
    final latest = <String, ResultSnapshot>{};
    final points = <TimelinePoint>[];
    for (final (i, r) in rows.indexed) {
      latest[r.scopeCode] = r;
      final last = i == rows.length - 1;
      if (!last && rows[i + 1].tseGeneratedAt == r.tseGeneratedAt) continue;
      final br = latest['br'];
      var totalized = 0, total = 0;
      for (final s in latest.values) {
        if (s.scopeCode == 'br') continue;
        totalized += s.sectionsTotalized;
        total += s.sectionsTotal;
      }
      points.add(
        TimelinePoint(
          at: r.tseGeneratedAt,
          nationalPct: br == null || br.sectionsTotal == 0
              ? 0
              : br.sectionsTotalized * 100 / br.sectionsTotal,
          statesPct: total == 0 ? 0 : totalized * 100 / total,
        ),
      );
    }
    if (points.length <= maxTimelinePoints) return points;
    // Evenly thinned, always keeping the latest point.
    final step = points.length / maxTimelinePoints;
    return [
      for (var i = 0; i < maxTimelinePoints - 1; i++)
        points[(i * step).floor()],
      points.last,
    ];
  }
}

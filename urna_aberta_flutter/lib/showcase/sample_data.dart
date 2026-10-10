import 'dart:math' as math;

import '../design/tokens.dart';
import '../design/widgets/charts.dart';

/// Demonstration data for the design system showcase.
///
/// SIMULATION. Not TSE data. Candidates are anonymous placeholders, and the
/// timeline is a synthetic curve that reproduces the shape of the Oct 4, 2026
/// national-file freeze at 64.81%. Replace with replay fixtures.
abstract final class SampleData {
  static const isSimulation = true;

  /// % of sections totalized per UF at the sample moment (21:41).
  static const ufPct = <String, double>{
    'AC': 88.1, 'AL': 91.4, 'AP': 79.6, 'AM': 72.3, 'BA': 86.0, //
    'CE': 90.2, 'DF': 97.5, 'ES': 89.9, 'GO': 84.7, 'MA': 76.8, //
    'MT': 81.2, 'MS': 85.3, 'MG': 83.1, 'PA': 69.4, 'PB': 92.0, //
    'PR': 87.6, 'PE': 88.9, 'PI': 90.7, 'RJ': 74.5, 'RN': 93.3, //
    'RS': 82.4, 'RO': 78.0, 'RR': 66.2, 'SC': 91.8, 'SP': 77.9, //
    'SE': 94.1, 'TO': 80.5,
  };

  static const momentLabel = '21:41';
  static const nationalFilePct = 64.81;
  static const stateSumPct = 81.37;

  static const candidates = <SampleCandidate>[
    SampleCandidate('Candidatura A', '00', 41203118, 51722904),
    SampleCandidate('Candidatura B', '00', 38960771, 48907315),
    SampleCandidate('Candidatura C', '00', 4120554, 5172630),
    SampleCandidate('Candidatura D', '00', 2266091, 2844671),
    SampleCandidate('Candidatura E', '00', 1031778, 1295197),
  ];

  /// Synthetic night, 19:00 → 23:30, one point per 5 min.
  static final List<TimelinePoint> timeline = _buildTimeline();

  static final DateTime freezeStart = DateTime(2026, 10, 4, 21, 2);
  static final DateTime freezeEnd = DateTime(2026, 10, 4, 21, 57);

  static List<TimelinePoint> _buildTimeline() {
    final start = DateTime(2026, 10, 4, 19, 0);
    final pts = <TimelinePoint>[];
    for (var m = 0; m <= 270; m += 5) {
      final t = start.add(Duration(minutes: m));
      final x = m / 270;
      final states = 100 * (1 - math.exp(-3.1 * x)) / (1 - math.exp(-3.1));
      final inFreeze =
          !t.isBefore(DateTime(2026, 10, 4, 21, 2)) &&
          t.isBefore(DateTime(2026, 10, 4, 21, 57));
      final national = inFreeze
          ? 64.81
          : math.max(0.0, states - (t.isAfter(freezeEnd) ? 0.6 : 1.2));
      pts.add(
        TimelinePoint(
          t,
          national.clamp(0, 100).toDouble(),
          states.clamp(0, 100).toDouble(),
        ),
      );
    }
    return pts;
  }

  /// Per-UF curves for the small multiples, all on one 0–100 scale.
  static List<double> ufCurve(String sigla) {
    final end = ufPct[sigla]!;
    final seed = sigla.codeUnits.fold<int>(0, (a, b) => a + b);
    final k = 2.2 + (seed % 9) / 6;
    return [
      for (var i = 0; i <= 24; i++)
        end * (1 - math.exp(-k * i / 24)) / (1 - math.exp(-k)),
    ];
  }

  static final List<TimelineSample> samples = [
    for (final p in timeline) TimelineSample(p.time, p.national, p.states),
  ];

  /// Replay starts at 21:40, inside the freeze.
  static final int startIndex = timeline.indexWhere(
    (p) => p.time.hour == 21 && p.time.minute == 40,
  );

  /// Per-UF % at a replay index, scaled from the 21:41 snapshot.
  static Map<String, double> ufPctAt(int index) {
    final ref = timeline[startIndex].states;
    final now = timeline[index].states;
    return {
      for (final e in ufPct.entries)
        e.key: (e.value * now / ref).clamp(0, 100).toDouble(),
    };
  }

  static final List<MirroredRow> mirroredRows = [
    for (final c in candidates)
      MirroredRow(c.name, c.nationalVotes, c.stateVotes),
  ];

  static Map<Regiao, double> regionPct(Map<String, Regiao> regionOf) {
    final sums = <Regiao, List<double>>{};
    ufPct.forEach(
      (uf, pct) => sums.putIfAbsent(regionOf[uf]!, () => []).add(pct),
    );
    return {
      for (final e in sums.entries)
        e.key: e.value.reduce((a, b) => a + b) / e.value.length,
    };
  }
}

class SampleCandidate {
  const SampleCandidate(
    this.name,
    this.number,
    this.nationalVotes,
    this.stateVotes,
  );

  final String name;
  final String number;
  final int nationalVotes;
  final int stateVotes;
}

class TimelinePoint {
  const TimelinePoint(this.time, this.national, this.states);

  final DateTime time;
  final double national;
  final double states;
}

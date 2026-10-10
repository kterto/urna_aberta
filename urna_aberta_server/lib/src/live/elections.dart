import 'dart:convert';

import '../tse/tse_urls.dart';

/// One election from TSE's EA11 (`ele-c.json`) that publishes offices this
/// app tallies, with the result files it will publish.
class Election {
  Election({
    required this.code,
    required this.pleito,
    required this.round,
    required this.name,
    required this.day,
    required this.targets,
  });

  final int code;
  final int pleito;
  final int round;
  final String name;

  /// Election day, Brasília calendar: (year, month, day).
  final (int, int, int) day;

  /// Every (scope, office) result file this election publishes.
  final List<(Scope, Office)> targets;

  /// Polls close at 17:00 Brasília; TSE publishes from then until the count
  /// ends, usually overnight. The window closes at 06:00 the next day.
  static const opensAtHour = 17, closesAtHour = 6;

  DateTime get opensAt => DateTime.utc(day.$1, day.$2, day.$3, opensAtHour + 3);
  DateTime get closesAt =>
      DateTime.utc(day.$1, day.$2, day.$3 + 1, closesAtHour + 3);

  bool isLiveAt(DateTime now) =>
      !now.isBefore(opensAt) && now.isBefore(closesAt);
}

/// The earliest window opening after [now], or null when none is left.
DateTime? nextLiveWindow(List<Election> elections, DateTime now) {
  DateTime? next;
  for (final e in elections) {
    if (e.opensAt.isAfter(now) && (next == null || e.opensAt.isBefore(next))) {
      next = e.opensAt;
    }
  }
  return next;
}

/// Reads EA11. Elections without an office in [Office] (municipal,
/// plebiscites) are left out. Throws [FormatException] on a malformed file.
List<Election> parseElections(List<int> bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException catch (e) {
    throw FormatException('EA11 ilegível: ${e.message}');
  }
  if (json case {'pl': final List<Object?> pleitos}) {
    return [
      for (final p in pleitos)
        if (p case {
          'cd': final String pl,
          'dt': final String dt,
          'e': final List<Object?> es,
        })
          for (final e in es) ?_election(e, int.parse(pl), _day(dt)),
    ];
  }
  throw const FormatException('EA11 sem lista de pleitos (pl)');
}

Election? _election(Object? e, int pleito, (int, int, int) day) {
  if (e case {
    'cd': final String cd,
    't': final String t,
    'nm': final String nm,
    'abr': final List<Object?> abr,
  }) {
    final targets = <(Scope, Office)>[];
    for (final a in abr) {
      if (a case {'cd': final String scope, 'cp': final List<Object?> cps}) {
        for (final cp in cps) {
          if (cp case {'cd': final String office}) {
            final o = Office.values
                .where((o) => o.code == int.parse(office))
                .firstOrNull;
            if (o != null) targets.addAll(_scopes(scope, o));
          }
        }
      }
    }
    if (targets.isEmpty) return null;
    return Election(
      code: int.parse(cd),
      pleito: pleito,
      round: int.parse(t),
      name: nm,
      day: day,
      targets: targets,
    );
  }
  return null;
}

/// `br` in EA11 means nationwide: Brazil, every UF and abroad for
/// President; every UF for state offices.
Iterable<(Scope, Office)> _scopes(String scope, Office office) {
  if (scope != 'br') return [(Scope.uf(scope), office)];
  final ufs = Scope.ufs.where((u) => u != 'zz');
  return office == Office.presidente
      ? [
          (Scope.brazil(), office),
          for (final u in ufs) (Scope.uf(u), office),
          (Scope.uf('zz'), office),
        ]
      : [for (final u in ufs) (Scope.uf(u), office)];
}

(int, int, int) _day(String ddmmyyyy) {
  final m = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(ddmmyyyy);
  if (m == null) throw FormatException('EA11: data inválida $ddmmyyyy');
  return (int.parse(m[3]!), int.parse(m[2]!), int.parse(m[1]!));
}

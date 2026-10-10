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
    required this.offices,
    required this.targets,
    this.allMunicipalities = false,
  });

  final int code;
  final int pleito;
  final int round;
  final String name;

  /// Election day, Brasília calendar: (year, month, day).
  final (int, int, int) day;

  final Set<Office> offices;

  /// Every (scope, office) result file this election publishes, except the
  /// per-municipality files of [allMunicipalities], which come from EA12.
  final List<(Scope, Office)> targets;

  /// A municipal election held in every municipality (EA11 scope `br`).
  final bool allMunicipalities;

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

/// Reads EA11. Only ordinary elections with an office in [Office] are kept
/// (supplementary elections and plebiscites are left out). Throws
/// [FormatException] on a malformed file.
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

/// EA11 election types: 8 federal, 1 state, 3 municipal (ordinary).
const _ordinary = {'1', '3', '8'};

Election? _election(Object? e, int pleito, (int, int, int) day) {
  if (e case {
    'cd': final String cd,
    't': final String t,
    'tp': final String tp,
    'nm': final String nm,
    'abr': final List<Object?> abr,
  }) {
    if (!_ordinary.contains(tp)) return null;
    final offices = <Office>{};
    final targets = <(Scope, Office)>[];
    var allMunicipalities = false;
    for (final a in abr) {
      if (a case {'cd': final String scope, 'cp': final List<Object?> cps}) {
        final mus = [
          if (a['mu'] case final List<Object?> mu)
            for (final m in mu)
              if (m case {'cd': final String c}) int.parse(c),
        ];
        for (final cp in cps) {
          if (cp case {'cd': final String code}) {
            final o = Office.byCode(int.parse(code));
            if (o == null) continue;
            offices.add(o);
            if (o.level == OfficeLevel.municipal && scope == 'br') {
              allMunicipalities = true;
            } else {
              targets.addAll(_scopes(scope, mus, o));
            }
          }
        }
      }
    }
    if (offices.isEmpty) return null;
    return Election(
      code: int.parse(cd),
      pleito: pleito,
      round: int.parse(t),
      name: nm,
      day: day,
      offices: offices,
      targets: targets,
      allMunicipalities: allMunicipalities,
    );
  }
  return null;
}

/// `br` in EA11 means nationwide: Brazil, every UF and abroad for
/// President; every UF that elects the office for state offices. A UF entry
/// may list municipalities (`mu`) for municipal offices.
Iterable<(Scope, Office)> _scopes(String scope, List<int> mus, Office office) {
  if (office.level == OfficeLevel.municipal) {
    return [for (final m in mus) (Scope.municipality(scope, m), office)];
  }
  if (scope != 'br') return [(Scope.uf(scope), office)];
  final ufs = Scope.ufs.where((u) => u != 'zz');
  return switch (office) {
    Office.presidente => [
      (Scope.brazil(), office),
      for (final u in ufs) (Scope.uf(u), office),
      (Scope.uf('zz'), office),
    ],
    Office.deputadoEstadual => [
      for (final u in ufs)
        if (u != 'df') (Scope.uf(u), office),
    ],
    Office.deputadoDistrital => [(Scope.uf('df'), office)],
    _ => [for (final u in ufs) (Scope.uf(u), office)],
  };
}

(int, int, int) _day(String ddmmyyyy) {
  final m = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(ddmmyyyy);
  if (m == null) throw FormatException('EA11: data inválida $ddmmyyyy');
  return (int.parse(m[3]!), int.parse(m[2]!), int.parse(m[1]!));
}

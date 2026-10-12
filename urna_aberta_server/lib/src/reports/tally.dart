/// Sums for reports: one office's votes over TSE result files or over the
/// BUs of polling sections, and the comparison of a sum with TSE's own
/// total for the same place.
library;

import '../generated/protocol.dart' hide Candidate;
import '../results/ea20_result.dart';
import '../results/seats.dart';
import '../tse/tse_urls.dart';

/// Where a figure in a report comes from.
class TallySource {
  const TallySource({
    required this.name,
    required this.url,
    required this.sha256,
    required this.check,
  });

  /// File name, e.g. `ac01066-c0001-e006257-u.jws` or a section's BU.
  final String name;
  final String url;
  final String sha256;

  /// TSE signature status of a result file; for a section, the BU check
  /// against the urna's signed list followed by the urna's signature
  /// (`matches/valid`).
  final String check;
}

/// One row: a candidacy (one race) or a party (several races or a
/// proportional office).
class TallyRow {
  TallyRow({required this.key, required this.label, this.number, this.party});

  /// `c<number>` for a candidacy, `p<number>` for a party.
  final String key;

  /// Ballot name or party abbreviation.
  String label;
  final int? number;

  /// A candidacy's party abbreviation.
  String? party;
  int votes = 0;

  /// TSE's seats (proportional offices, summed over whole races only).
  int? seats;

  /// TSE's status for a candidacy, read from its race's own file.
  String? status;
}

class Tally {
  Tally({required this.office, required this.byCandidate});

  final Office office;

  /// Rows are the candidacies of a single race; otherwise parties.
  final bool byCandidate;

  /// Summed from sections' BUs rather than TSE result files.
  bool fromBallots = false;

  int total = 0, valid = 0, nominal = 0, legend = 0, blank = 0;
  int nullVotes = 0, annulledSubJudice = 0;

  /// Voters registered and turned out; null when a source lacks them.
  int? electorate = 0, turnout = 0;

  /// Sections covered and those whose votes are in this sum.
  int sectionsTotal = 0, sectionsCounted = 0;

  /// Proportional offices over whole races: how many races there are and
  /// how many of them our seat allocation matches TSE's.
  int races = 0, racesMatching = 0;

  /// Sections left out of a BU sum, with the reason (`missing`, `differs`…).
  final excluded = <String, String>{};

  final sources = <TallySource>[];
  final _rows = <String, TallyRow>{};

  /// Most votes first; ties by label.
  List<TallyRow> get rows => _rows.values.toList()
    ..sort((a, b) {
      final byVotes = b.votes.compareTo(a.votes);
      return byVotes != 0 ? byVotes : a.label.compareTo(b.label);
    });

  TallyRow _row(String key, String label, {int? number}) => _rows.putIfAbsent(
    key,
    () => TallyRow(key: key, label: label, number: number),
  );
}

/// The race a file or section votes in: Brazil for President, the UF for
/// state offices, the city for municipal ones.
String raceOf(Office office, String scopeCode) => switch (office.level) {
  OfficeLevel.federal => 'br',
  OfficeLevel.state => scopeCode.substring(0, 2),
  OfficeLevel.municipal => scopeCode,
};

bool _isElected(Candidate c) => switch (c.status) {
  CandidateStatus.elected ||
  CandidateStatus.electedByQuotient ||
  CandidateStatus.electedByAverage => true,
  _ => false,
};

/// Sums [files] (each with the source it was read from). Rows are
/// candidacies when every file is in the same race, parties otherwise and
/// for proportional offices.
Tally sumResults(
  Office office,
  List<(OfficeResult, TallySource)> files,
) {
  final races = {for (final (r, _) in files) raceOf(office, r.scope)};
  final t = Tally(
    office: office,
    byCandidate: races.length == 1 && !office.proportional,
  );
  final wholeRaces = files.every(
    (f) => raceOf(office, f.$1.scope) == f.$1.scope,
  );
  for (final (r, source) in files) {
    t.sources.add(source);
    t.total += r.totals.total;
    t.valid += r.totals.valid;
    t.nominal += r.totals.nominal;
    t.legend += r.totals.legend;
    t.blank += r.totals.blank;
    t.nullVotes += r.totals.nullVotes;
    t.annulledSubJudice += r.totals.annulledSubJudice;
    t.electorate = _add(t.electorate, r.electorate);
    t.turnout = _add(t.turnout, r.turnout);
    t.sectionsTotal += r.sectionsTotal;
    t.sectionsCounted += r.sectionsTotalized;

    final isRaceFile = raceOf(office, r.scope) == r.scope;
    if (t.byCandidate) {
      for (final l in r.lists) {
        for (final p in l.parties) {
          for (final c in p.candidates) {
            final row = t._row('c${c.number}', c.ballotName, number: c.number)
              ..party = p.abbrev
              ..votes += c.votes;
            if (isRaceFile) row.status = c.rawStatus;
          }
        }
      }
    } else {
      for (final l in r.lists) {
        for (final p in l.parties) {
          final row = t._row('p${p.number}', p.abbrev, number: p.number)
            ..votes += p.nominalVotes + p.legendVotes;
          if (office.proportional && wholeRaces) {
            row.seats =
                (row.seats ?? 0) + p.candidates.where(_isElected).length;
          }
        }
      }
    }
    if (office.proportional && wholeRaces) {
      t.races++;
      if (SeatComparison.of(r, allocateSeats(r)).matches) t.racesMatching++;
    }
  }
  return t;
}

int? _add(int? sum, int? value) =>
    sum == null || value == null ? null : sum + value;

/// Sums the BUs of [sections] for one office of [election]. [reference] is
/// the race's result file, for names and party labels; [listed] counts the
/// sections TSE lists in the place, including those with no urna files.
///
/// A section counts only when its BU matches the list its urna signed;
/// any other is left out and named in [Tally.excluded].
Tally sumSections(
  int election,
  Office office,
  List<SectionReport> sections, {
  required OfficeResult reference,
  required int listed,
}) {
  final t = Tally(office: office, byCandidate: !office.proportional)
    ..sectionsTotal = listed
    ..fromBallots = true;
  final names = {for (final c in reference.candidates) c.number: c};
  final parties = {
    for (final l in reference.lists)
      for (final p in l.parties) p.number: p.abbrev,
  };
  for (final s in sections) {
    final id = '${s.uf}/${s.municipio}/${s.zona}/${s.secao}';
    final cargo = s.cargos
        .where((c) => c.eleicao == election && c.codigo == office.code)
        .firstOrNull;
    if (s.buCheck != BuCheck.matches || cargo == null) {
      t.excluded[id] = s.buCheck == BuCheck.matches ? 'office' : s.buCheck.name;
      continue;
    }
    t.sectionsCounted++;
    t.electorate = _add(t.electorate, s.aptos);
    t.turnout = _add(t.turnout, cargo.comparecimento);
    for (final f in s.files) {
      t.sources.add(
        TallySource(
          name: f.name,
          url: f.url,
          sha256: f.sha256,
          check: '${s.buCheck.name}/${s.urnaSignature.name}',
        ),
      );
    }
    for (final v in cargo.votos) {
      t.total += v.votos;
      switch (v.tipo) {
        case 'nominal':
          t.nominal += v.votos;
          t.valid += v.votos;
          final n = v.numero!;
          if (t.byCandidate) {
            t._row('c$n', names[n]?.ballotName ?? '$n', number: n)
              ..party = parties[v.partido ?? names[n]?.party]
              ..votes += v.votos;
          } else {
            final p = v.partido ?? names[n]?.party ?? n ~/ _partyDivisor(n);
            t._row('p$p', parties[p] ?? '$p', number: p).votes += v.votos;
          }
        case 'legenda':
          t.legend += v.votos;
          t.valid += v.votos;
          final p = v.partido ?? v.numero!;
          t._row('p$p', parties[p] ?? '$p', number: p).votes += v.votos;
        case 'branco':
          t.blank += v.votos;
        default:
          t.nullVotes += v.votos;
      }
    }
  }
  return t;
}

/// A candidate number's party is its first two digits.
int _partyDivisor(int number) {
  var d = 1;
  while (number ~/ d >= 100) {
    d *= 10;
  }
  return d;
}

/// One figure that differs between TSE's total and our sum.
class Difference {
  const Difference(this.what, this.tse, this.ours);

  /// `total`, `valid`, `blank`, `null`, or a row key (`c13`, `p22`).
  final String what;
  final int tse, ours;
}

/// TSE's total for a place against our sum of the files or sections inside
/// it. Rows are compared by key; totals field by field.
List<Difference> compareTallies(Tally tse, Tally ours) {
  final diffs = <Difference>[
    for (final (what, a, b) in [
      ('total', tse.total, ours.total),
      ('valid', tse.valid, ours.valid),
      ('blank', tse.blank, ours.blank),
      ('null', tse.nullVotes, ours.nullVotes),
    ])
      if (a != b) Difference(what, a, b),
  ];
  final keys = {...tse._rows.keys, ...ours._rows.keys};
  for (final k in keys) {
    final a = tse._rows[k]?.votes ?? 0, b = ours._rows[k]?.votes ?? 0;
    if (a != b) diffs.add(Difference(k, a, b));
  }
  return diffs;
}

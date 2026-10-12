import 'package:test/test.dart';
import 'package:urna_aberta_server/src/results/ea20_result.dart';
import 'package:urna_aberta_server/src/results/seats.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

/// A proportional race: list name → (legend votes, candidate votes).
/// Candidate numbers are list index * 100 + position; older first unless
/// [born] says otherwise.
OfficeResult race(
  int seats,
  Map<String, (int, List<int>)> lists, {
  Map<int, Validity> validity = const {},
  Map<int, DateTime> born = const {},
}) {
  var li = 0;
  final built = <ElectoralList>[];
  for (final MapEntry(key: name, value: (legend, votes)) in lists.entries) {
    li++;
    final cands = [
      for (final (i, v) in votes.indexed)
        Candidate(
          number: li * 100 + i,
          sequence: '${li * 100 + i}',
          name: '$name$i',
          ballotName: '$name$i',
          birthDate: born[li * 100 + i] ?? DateTime.utc(1950 + i),
          validity: validity[li * 100 + i] ?? Validity.valid,
          elected: false,
          status: CandidateStatus.notElected,
          rawStatus: '',
          votes: v,
          party: li,
          list: name,
        ),
    ];
    final valid = cands
        .where((c) => c.validity == Validity.valid)
        .fold(0, (s, c) => s + c.votes);
    built.add(
      ElectoralList(
        number: name,
        name: name,
        kind: ListKind.party,
        composition: name,
        seatsWon: null,
        parties: [
          Party(
            number: li,
            abbrev: name,
            name: name,
            federation: null,
            nominalVotes: valid,
            legendVotes: legend,
            candidates: cands,
          ),
        ],
      ),
    );
  }
  final valid = built.fold(0, (s, l) => s + l.votes);
  return OfficeResult(
    election: 1,
    round: 1,
    scope: 'xx',
    office: Office.vereador,
    seats: seats,
    electoralQuotient: null,
    generatedAt: DateTime.utc(2024),
    sectionsTotal: 1,
    sectionsTotalized: 1,
    totals: Totals(
      total: valid,
      valid: valid,
      nominal: valid,
      legend: 0,
      blank: 0,
      nullVotes: 0,
      annulledSubJudice: 0,
    ),
    lists: built,
  );
}

List<String> names(SeatAllocation a) =>
    [for (final s in a.elected) a.candidate(s).name]..sort();

void main() {
  group('quociente eleitoral (CE art. 106)', () {
    test('a fraction of a half or less is dropped', () {
      // 1000 / 3 = 333.33…; 1000 / 8 = 125.0; 1004 / 8 = 125.5.
      expect(electoralQuotient(1000, 3), 333);
      expect(electoralQuotient(1000, 8), 125);
      expect(electoralQuotient(1004, 8), 125);
    });

    test('a fraction over a half rounds up', () {
      // 1000 / 6 = 166.67; 1005 / 8 = 125.625.
      expect(electoralQuotient(1000, 6), 167);
      expect(electoralQuotient(1005, 8), 126);
    });
  });

  test('quotient seats, then one remainder by highest average', () {
    // V = 1000, 5 seats, QE = 200. QP: A 2, B 1, C 1. One seat left:
    // averages A 500/3 = 166.7, B 300/2 = 150, C 200/2 = 100 → A.
    final a = allocateSeats(
      race(5, {
        'A': (0, [300, 150, 50]),
        'B': (0, [200, 100]),
        'C': (0, [150, 50]),
      }),
    );
    expect(a.quotient, 200);
    expect(names(a), ['A0', 'A1', 'A2', 'B0', 'C0']);
    expect(a.phaseOf('A2'), SeatPhase.average);
    expect(a.phaseOf('A0'), SeatPhase.quotient);
    expect(a.seatsOf('A'), 3);
  });

  test('a quotient seat needs a candidate with 10% of QE (art. 108)', () {
    // V = 1000, 4 seats, QE = 250 (10% = 25, 80% = 200, 20% = 50).
    // QP: A 2 (550), B 1, C 0. A has nobody with 25 votes: no quotient
    // seat. Remainders: C 200/1 (C0 has 50+) → C0. Then nobody qualifies,
    // so all compete; A's divisor still counts its QP of 2 (Res. 23.677
    // art. 11 §5): A 550/3 = 183 → A0 (older of the two 24s), then
    // A 550/4 = 137 → A1.
    final a = allocateSeats(
      race(4, {
        'A': (478, [24, 24, 24]),
        'B': (0, [250]),
        'C': (0, [200]),
      }),
    );
    expect(a.quotient, 250);
    expect(names(a), ['A0', 'A1', 'B0', 'C0']);
    expect(a.phaseOf('B0'), SeatPhase.quotient);
    expect(a.phaseOf('C0'), SeatPhase.average);
    expect(a.phaseOf('A0'), SeatPhase.open);
  });

  test(
    'an unfilled quotient seat still counts in the divisor (art. 11 §5)',
    () {
      // V = 1532, 4 seats, QE = 383 (10% = 38.3, 80% = 306.4).
      // A 772 has QP 2 but no candidate with 38.3 votes; nobody reaches
      // 80% with a 20% candidate, so all four seats are open. A's divisor
      // is QP + won + 1 = 3, not 1: B 300 → B0, C 260 > A 257.3 → C0,
      // A 257.3 > D 200 → A0, then D 200 > A 772/4 = 193 → D0.
      final a = allocateSeats(
        race(4, {
          'A': (700, [24, 24, 24]),
          'B': (0, [300]),
          'C': (0, [260]),
          'D': (0, [200]),
        }),
      );
      expect(a.quotient, 383);
      expect(names(a), ['A0', 'B0', 'C0', 'D0']);
    },
  );

  test('remainders first need 80% of QE and a 20% candidate (art. 109)', () {
    // V = 1000, 3 seats, QE = 333 (80% = 266.4, 20% = 66.6).
    // A 400 (QP 1) → A0. Seat 2: A's next has 60 < 66.6, B's only
    // candidate has 60: only C qualifies → C0. Seat 3: nobody qualifies,
    // all compete: A 400/2 = 200, B 300/1, C 300/2 → B0.
    final a = allocateSeats(
      race(3, {
        'A': (0, [340, 60]),
        'B': (240, [60]),
        'C': (0, [280, 20]),
      }),
    );
    expect(names(a), ['A0', 'B0', 'C0']);
    expect(a.phaseOf('C0'), SeatPhase.average);
    expect(a.phaseOf('B0'), SeatPhase.open);
  });

  test('when no list qualifies, every list and candidate competes (STF)', () {
    // V = 900, 3 seats, QE = 300 (80% = 240, 20% = 60). QP: A 1 → A0.
    // Seat 2: A has no 60-vote candidate left; B 250 qualifies → B0.
    // Seat 3: C 220 < 240 and A has no 20% candidate → all compete:
    // A 430/2 = 215, C 220/1 = 220 → C0.
    final a = allocateSeats(
      race(3, {
        'A': (0, [400, 30]),
        'B': (0, [250]),
        'C': (0, [220]),
      }),
    );
    expect(a.quotient, 300);
    expect(names(a), ['A0', 'B0', 'C0']);
    expect(a.phaseOf('B0'), SeatPhase.average);
    expect(a.phaseOf('C0'), SeatPhase.open);
  });

  test('if no list reaches QE, all seats go by averages (art. 12-A)', () {
    // V = 1000, 3 seats, QE = 333: every QP is 0 and nobody has 80%.
    final a = allocateSeats(
      race(3, {
        'A': (0, [210]),
        'B': (0, [200]),
        'C': (0, [205]),
        'D': (0, [190]),
        'E': (0, [195]),
      }),
    );
    expect(names(a), ['A0', 'B0', 'C0']);
    expect(a.elected.every((s) => s.phase == SeatPhase.open), isTrue);
  });

  test('equal averages: the list with more votes wins', () {
    // V = 2370, 2 seats, QE = 1185, nobody reaches 80% (948): all compete.
    // Seat 1: A 800 → A0. Seat 2: A 800/2 = 400 = C 400/1: A has more
    // votes → A1.
    final a = allocateSeats(
      race(2, {
        'A': (0, [500, 300]),
        'C': (0, [400]),
        'D': (0, [390]),
        'E': (0, [390]),
        'F': (0, [390]),
      }),
    );
    expect(names(a), ['A0', 'A1']);
  });

  test('equal votes in a list: the older candidate (art. 110)', () {
    final a = allocateSeats(
      race(
        1,
        {
          'A': (0, [300, 300]),
        },
        born: {100: DateTime.utc(1990), 101: DateTime.utc(1960)},
      ),
    );
    expect(names(a), ['A1']);
  });

  test(
    'barred candidates never take a seat; a seat nobody can take stays empty',
    () {
      // Only A2's 100 votes are valid: V = 100, 2 seats, QE = 50, QP 2.
      final a = allocateSeats(
        race(
          2,
          {
            'A': (0, [500, 300, 100]),
          },
          validity: {
            100: Validity.annulledSubJudice,
            101: Validity.validForParty,
          },
        ),
      );
      expect(names(a), ['A2']);
      expect(a.unfilled, 1);
    },
  );

  test('a difference from TSE is reported, list by list and seat by seat', () {
    final r = race(5, {
      'A': (0, [300, 150, 50]),
      'B': (0, [200, 100]),
      'C': (0, [150, 50]),
    });
    final a = allocateSeats(r);
    // TSE (hypothetically) gave A only 2 seats and nobody else.
    final diff = SeatComparison.of(
      OfficeResult(
        election: r.election,
        round: r.round,
        scope: r.scope,
        office: r.office,
        seats: r.seats,
        electoralQuotient: 201,
        generatedAt: r.generatedAt,
        sectionsTotal: 1,
        sectionsTotalized: 1,
        totals: r.totals,
        lists: [
          for (final l in r.lists)
            ElectoralList(
              number: l.number,
              name: l.name,
              kind: l.kind,
              composition: l.composition,
              seatsWon: l.number == 'A' ? 2 : 0,
              parties: l.parties,
            ),
        ],
      ),
      a,
    );
    expect(diff.matches, isFalse);
    expect(diff.tseQuotient, 201);
    expect(diff.lists.map((d) => (d.list, d.tse, d.ours)), [
      ('A', 2, 3),
      ('B', 0, 1),
      ('C', 0, 1),
    ]);
    expect(diff.candidates, hasLength(5));
  });
}

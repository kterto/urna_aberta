/// Independent seat allocation for proportional offices (deputados,
/// vereadores), from the votes in an EA20 file.
///
/// Código Eleitoral arts. 106–112 (Lei 4.737/1965, as changed by Lei
/// 14.211/2021), Res.-TSE 23.677/2021 arts. 9–14 (consolidated), and STF ADIs
/// 7228, 7263 and 7325 (the last remainders open to every list and
/// candidate; applies since 2022). Integer arithmetic only: averages are
/// compared by cross-multiplication.
library;

import 'ea20_result.dart';

/// QE = valid votes / seats; a fraction of a half or less is dropped,
/// more than a half rounds up (CE art. 106).
int electoralQuotient(int validVotes, int seats) {
  final q = validVotes ~/ seats, r = validVotes % seats;
  return 2 * r > seats ? q + 1 : q;
}

enum SeatPhase {
  /// Within the list's quociente partidário (CE art. 108).
  quotient,

  /// A remainder, among lists with 80% of QE and a candidate with 20%
  /// (CE art. 109 I and §2).
  average,

  /// A remainder once no list qualifies: every list and candidate
  /// competes (STF, ADI 7228; Res. 23.677 art. 11 §4).
  open,
}

class Seat {
  const Seat(this.candidate, this.list, this.phase);

  final Candidate candidate;
  final String list;
  final SeatPhase phase;
}

class ListSeats {
  ListSeats(this.list, this.partyQuotient);

  final ElectoralList list;

  /// QP = list votes / QE, fraction dropped (CE art. 107).
  final int partyQuotient;
  int quotientSeats = 0;
  int remainderSeats = 0;

  int get votes => list.votes;
  int get seats => quotientSeats + remainderSeats;
}

class SeatAllocation {
  SeatAllocation({
    required this.validVotes,
    required this.seats,
    required this.quotient,
    required this.lists,
    required this.elected,
    required this.unfilled,
  });

  final int validVotes, seats, quotient;
  final Map<String, ListSeats> lists;

  /// In the order the seats were awarded.
  final List<Seat> elected;

  /// Seats no remaining candidate could take.
  final int unfilled;

  Candidate candidate(Seat s) => s.candidate;
  String listOf(Seat s) => s.list;
  int seatsOf(String list) => lists[list]?.seats ?? 0;

  SeatPhase? phaseOf(String candidateName) => elected
      .where((s) => s.candidate.name == candidateName)
      .firstOrNull
      ?.phase;
}

SeatAllocation allocateSeats(OfficeResult result) {
  final validVotes = result.lists.fold(0, (s, l) => s + l.votes);
  final seats = result.seats;
  final qe = electoralQuotient(validVotes, seats);
  final lists = {
    for (final l in result.lists)
      l.number: ListSeats(l, qe == 0 ? 0 : l.votes ~/ qe),
  };
  // Who can take a seat, in the order they would: votes, then the older
  // (CE art. 110). Barred candidacies never take one.
  final queues = {
    for (final l in result.lists)
      l.number: [
        for (final c in l.candidates)
          if (c.validity == Validity.valid) c,
      ]..sort(_byVotesThenAge),
  };
  final elected = <Seat>[];

  Candidate? next(String list, {int atLeastTimesQe = 0, int over = 1}) {
    final q = queues[list]!;
    if (q.isEmpty) return null;
    // votes ≥ QE × atLeastTimesQe / over, compared without fractions.
    return q.first.votes * over >= qe * atLeastTimesQe ? q.first : null;
  }

  void award(String list, SeatPhase phase) {
    final c = queues[list]!.removeAt(0);
    elected.add(Seat(c, list, phase));
    final ls = lists[list]!;
    phase == SeatPhase.quotient ? ls.quotientSeats++ : ls.remainderSeats++;
  }

  // 1. Quotient seats: up to QP, each to a candidate with 10% of QE.
  for (final MapEntry(key: number, value: ls) in lists.entries) {
    for (var i = 0; i < ls.partyQuotient && elected.length < seats; i++) {
      if (next(number, atLeastTimesQe: 1, over: 10) == null) break;
      award(number, SeatPhase.quotient);
    }
  }

  // 2–3. Remainders by highest average; the divisor counts the full QP,
  // filled or not, plus remainders won (Res. 23.677 art. 11 §§1, 5).
  var unfilled = 0;
  while (elected.length + unfilled < seats) {
    final qualified = [
      for (final MapEntry(key: number, value: ls) in lists.entries)
        if (ls.votes * 5 >= qe * 4 &&
            next(number, atLeastTimesQe: 1, over: 5) != null)
          number,
    ];
    final open = qualified.isEmpty;
    final competing = open
        ? [
            for (final number in lists.keys)
              if (queues[number]!.isNotEmpty) number,
          ]
        : qualified;
    if (competing.isEmpty) {
      unfilled++;
      continue;
    }
    competing.sort((a, b) => _byAverage(lists[a]!, lists[b]!, queues));
    award(competing.first, open ? SeatPhase.open : SeatPhase.average);
  }

  return SeatAllocation(
    validVotes: validVotes,
    seats: seats,
    quotient: qe,
    lists: lists,
    elected: elected,
    unfilled: unfilled,
  );
}

/// Higher average first; ties go to the list with more votes, then to the
/// list whose next candidate has more votes (Res. 23.677 art. 11 §§6–7).
int _byAverage(ListSeats a, ListSeats b, Map<String, List<Candidate>> queues) {
  final da = a.partyQuotient + a.remainderSeats + 1;
  final db = b.partyQuotient + b.remainderSeats + 1;
  final byAverage = (b.votes * da).compareTo(a.votes * db);
  if (byAverage != 0) return byAverage;
  final byVotes = b.votes.compareTo(a.votes);
  if (byVotes != 0) return byVotes;
  return queues[b.list.number]!.first.votes.compareTo(
    queues[a.list.number]!.first.votes,
  );
}

int _byVotesThenAge(Candidate a, Candidate b) {
  final byVotes = b.votes.compareTo(a.votes);
  if (byVotes != 0) return byVotes;
  final ba = a.birthDate, bb = b.birthDate;
  if (ba != null && bb != null && ba != bb) return ba.compareTo(bb);
  return a.number.compareTo(b.number);
}

/// How our allocation compares with the outcome TSE published in the same
/// file. Every difference is listed; none is hidden.
class SeatComparison {
  SeatComparison._(
    this.tseQuotient,
    this.quotient,
    this.lists,
    this.candidates,
  );

  /// Compares [ours] with [result]'s `qe`, `vag` and candidate statuses.
  factory SeatComparison.of(OfficeResult result, SeatAllocation ours) {
    String how(SeatPhase p) => p == SeatPhase.quotient ? 'QP' : 'média';
    final mine = {
      for (final s in ours.elected) s.candidate.sequence: how(s.phase),
    };
    final tse = {
      for (final c in result.candidates)
        if (c.elected)
          c.sequence: c.status == CandidateStatus.electedByQuotient
              ? 'QP'
              : 'média',
    };
    return SeatComparison._(
      result.electoralQuotient,
      ours.quotient,
      [
        for (final l in result.lists)
          if (l.seatsWon != ours.seatsOf(l.number))
            (
              list: l.number,
              tse: l.seatsWon ?? 0,
              ours: ours.seatsOf(l.number),
            ),
      ],
      [
        for (final c in result.candidates)
          if (mine[c.sequence] != tse[c.sequence])
            (candidate: c, tse: tse[c.sequence], ours: mine[c.sequence]),
      ],
    );
  }

  final int? tseQuotient;
  final int quotient;

  /// Lists whose seat count differs from TSE's `vag`.
  final List<({String list, int tse, int ours})> lists;

  /// Candidates elected differently: `QP`, `média`, or null (not elected).
  final List<({Candidate candidate, String? tse, String? ours})> candidates;

  bool get matches =>
      tseQuotient == quotient && lists.isEmpty && candidates.isEmpty;
}

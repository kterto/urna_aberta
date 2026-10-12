/// The full content of an EA20 result file, for any office: lists,
/// parties, federations, candidates, seats and TSE's own outcome.
///
/// Field meanings were checked against the 2026 and 2024 files in
/// `fixtures/`: a party's `tvtn` is the sum of its valid candidates' `vap`,
/// `tvan` also counts sub judice votes, `tvtl` is its valid legend votes,
/// `tvtl` is its legend votes (direct legend `tval` plus the votes of
/// candidates barred after the election, `Válido (legenda)`), and nominal +
/// legend over all parties equals the file's valid votes.
library;

import 'dart:convert';

import '../tse/tse_time.dart';
import '../tse/tse_urls.dart';

enum ListKind {
  /// A party running alone (`tp` `i`).
  party,

  /// A federação (`f`): several parties acting as one for every rule.
  federation,

  /// A coligação (`c`), majoritarian offices only.
  coalition,
}

enum Validity {
  valid,

  /// Barred after the election: the votes count for the party (legend),
  /// the candidate cannot take a seat (Res.-TSE 23.677, art. 20 §2).
  validForParty,

  /// Barred before the count; votes are null.
  annulled,

  /// Barred, appeal pending: not counted in totals or seats.
  annulledSubJudice,
}

enum CandidateStatus {
  elected,
  electedByQuotient,
  electedByAverage,
  secondRound,
  substitute,
  notElected,

  /// Anything TSE writes that this reader does not know; kept as [raw].
  other,
}

class Totals {
  const Totals({
    required this.total,
    required this.valid,
    required this.nominal,
    required this.legend,
    required this.blank,
    required this.nullVotes,
    required this.annulledSubJudice,
  });

  final int total, valid, nominal, legend, blank, nullVotes, annulledSubJudice;
}

class Candidate {
  const Candidate({
    required this.number,
    required this.sequence,
    required this.name,
    required this.ballotName,
    required this.birthDate,
    required this.validity,
    required this.elected,
    required this.status,
    required this.rawStatus,
    required this.votes,
    required this.party,
    required this.list,
  });

  final int number;

  /// TSE's candidacy id (`sqcand`), stable across files.
  final String sequence;
  final String name;
  final String ballotName;
  final DateTime? birthDate;
  final Validity validity;
  final bool elected;
  final CandidateStatus status;
  final String rawStatus;
  final int votes;

  /// Party number and list number this candidacy runs under.
  final int party;
  final String list;
}

class Party {
  const Party({
    required this.number,
    required this.abbrev,
    required this.name,
    required this.federation,
    required this.nominalVotes,
    required this.legendVotes,
    required this.candidates,
  });

  final int number;
  final String abbrev;
  final String name;

  /// Federation number, when the party runs inside one.
  final int? federation;

  /// Valid nominal votes (its valid candidates' votes) and legend votes.
  final int nominalVotes, legendVotes;
  final List<Candidate> candidates;
}

class ElectoralList {
  const ElectoralList({
    required this.number,
    required this.name,
    required this.kind,
    required this.composition,
    required this.seatsWon,
    required this.parties,
  });

  /// TSE's list id (`agr.n`).
  final String number;
  final String name;
  final ListKind kind;

  /// Party abbreviations, as TSE writes them (`com`).
  final String composition;

  /// Seats TSE awarded the list (`vag`), proportional offices only.
  final int? seatsWon;
  final List<Party> parties;

  /// Valid nominal plus legend votes (including votes moved to the legend):
  /// what the quotients count.
  int get votes =>
      parties.fold(0, (s, p) => s + p.nominalVotes + p.legendVotes);

  Iterable<Candidate> get candidates => parties.expand((p) => p.candidates);
}

class OfficeResult {
  const OfficeResult({
    required this.election,
    required this.round,
    required this.scope,
    required this.office,
    required this.seats,
    required this.electoralQuotient,
    required this.generatedAt,
    required this.sectionsTotal,
    required this.sectionsTotalized,
    required this.totals,
    required this.lists,
    this.electorate,
    this.turnout,
  });

  final int election, round;

  /// `br`, a UF or a municipality (`sp71072`), lowercase.
  final String scope;
  final Office office;
  final int seats;

  /// TSE's quociente eleitoral (`qe`); null for majoritarian offices.
  final int? electoralQuotient;
  final DateTime generatedAt;
  final int sectionsTotal, sectionsTotalized;
  final Totals totals;
  final List<ElectoralList> lists;

  /// Voters registered (`e.te`) and who turned out (`e.c`), when the file
  /// has them.
  final int? electorate, turnout;

  Iterable<Candidate> get candidates => lists.expand((l) => l.candidates);
}

/// Parses an EA20 JSON payload. A municipal file names only its
/// municipality, so its [uf] (the URL's folder) must be given. Throws
/// [FormatException] on anything it cannot read faithfully: a figure is
/// never guessed.
OfficeResult parseOfficeResult(List<int> bytes, {String? uf}) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException catch (e) {
    throw FormatException('EA20 ilegível: ${e.message}');
  }
  if (json is! Map<String, dynamic>) {
    throw const FormatException('EA20: top level is not an object');
  }
  final cargs = _list(json['carg'], 'carg');
  if (cargs.length != 1) {
    throw FormatException('EA20: expected one office, found ${cargs.length}');
  }
  final carg = _map(cargs.single, 'carg[0]');
  final officeCode = _int(carg['cd'], 'carg.cd');
  final office =
      Office.byCode(officeCode) ??
      (throw FormatException('EA20: unknown office $officeCode'));
  final s = _map(json['s'], 's');
  final v = _map(json['v'], 'v');
  final e = json['e'] is Map<String, dynamic> ? json['e'] as Map : const {};
  final qe = carg['qe'];

  return OfficeResult(
    election: _int(json['ele'], 'ele'),
    round: _int(json['t'], 't'),
    scope: _scope(json, uf),
    office: office,
    seats: _int(carg['nv'], 'carg.nv'),
    electoralQuotient: qe == null ? null : _int(qe, 'carg.qe'),
    generatedAt: parseTseDateTime(
      json['dg'],
      json['hg'],
      what: 'EA20 generation time',
    ),
    sectionsTotal: _int(s['ts'], 's.ts'),
    sectionsTotalized: _int(s['st'], 's.st'),
    totals: Totals(
      total: _int(v['tv'], 'v.tv'),
      valid: _int(v['vv'], 'v.vv'),
      nominal: _int(v['vnom'], 'v.vnom'),
      legend: _optInt(v['vl'], 'v.vl'),
      blank: _int(v['vb'], 'v.vb'),
      nullVotes: _int(v['vn'], 'v.vn'),
      annulledSubJudice: _optInt(v['vansj'], 'v.vansj'),
    ),
    lists: [
      for (final a in _list(carg['agr'], 'carg.agr'))
        _electoralList(_map(a, 'agr[]')),
    ],
    electorate: e['te'] == null ? null : _int(e['te'], 'e.te'),
    turnout: e['c'] == null ? null : _int(e['c'], 'e.c'),
  );
}

String _scope(Map<String, dynamic> json, String? uf) {
  final code = _string(json['cdabr'], 'cdabr').toLowerCase();
  if (json['tpabr'] != 'mu') return code;
  if (uf == null) {
    throw const FormatException('EA20: municipal file needs its UF');
  }
  return Scope.municipality(uf, int.parse(code)).code;
}

ElectoralList _electoralList(Map<String, dynamic> a) {
  final number = _string(a['n'], 'agr.n');
  final vag = a['vag'];
  return ElectoralList(
    number: number,
    name: _string(a['nm'], 'agr.nm'),
    kind: switch (a['tp']) {
      'i' => ListKind.party,
      'f' => ListKind.federation,
      'c' => ListKind.coalition,
      final tp => throw FormatException('EA20: unknown list type $tp'),
    },
    composition: (a['com'] as String?) ?? '',
    seatsWon: vag == null ? null : _int(vag, 'agr.vag'),
    parties: [
      for (final p in _list(a['par'], 'agr.par'))
        _party(_map(p, 'par[]'), number),
    ],
  );
}

Party _party(Map<String, dynamic> p, String list) {
  final number = _int(p['n'], 'par.n');
  final fed = p['nfed'] as String?;
  return Party(
    number: number,
    abbrev: _string(p['sg'], 'par.sg'),
    name: _string(p['nm'], 'par.nm'),
    federation: fed == null || fed.isEmpty ? null : _int(fed, 'par.nfed'),
    nominalVotes: _int(p['tvtn'], 'par.tvtn'),
    legendVotes: _optInt(p['tvtl'], 'par.tvtl'),
    candidates: [
      for (final c in _list(p['cand'] ?? const [], 'par.cand'))
        _candidate(_map(c, 'cand[]'), number, list),
    ],
  );
}

Candidate _candidate(Map<String, dynamic> c, int party, String list) {
  final st = (c['st'] as String?) ?? '';
  return Candidate(
    number: _int(c['n'], 'cand.n'),
    sequence: _string(c['sqcand'], 'cand.sqcand'),
    name: _string(c['nm'], 'cand.nm'),
    ballotName: _string(c['nmu'], 'cand.nmu'),
    birthDate: _date(c['dt']),
    validity: switch (c['dvt']) {
      'Válido' => Validity.valid,
      // A city abroad where no section was installed lists its candidates
      // with no votes and no validity.
      null when c['vap'] == '0' => Validity.valid,
      'Válido (legenda)' => Validity.validForParty,
      'Anulado' => Validity.annulled,
      'Anulado sub judice' => Validity.annulledSubJudice,
      final dvt => throw FormatException('EA20: unknown validity $dvt'),
    },
    elected: c['e'] == 's',
    status: switch (st) {
      'Eleito' => CandidateStatus.elected,
      'Eleito por QP' => CandidateStatus.electedByQuotient,
      'Eleito por média' => CandidateStatus.electedByAverage,
      '2º turno' => CandidateStatus.secondRound,
      'Suplente' => CandidateStatus.substitute,
      'Não eleito' => CandidateStatus.notElected,
      _ => CandidateStatus.other,
    },
    rawStatus: st,
    votes: _int(c['vap'], 'cand.vap'),
    party: party,
    list: list,
  );
}

DateTime? _date(Object? v) {
  if (v is! String) return null;
  final m = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(v);
  if (m == null) return null;
  return DateTime.utc(int.parse(m[3]!), int.parse(m[2]!), int.parse(m[1]!));
}

Map<String, dynamic> _map(Object? v, String field) => v is Map<String, dynamic>
    ? v
    : throw FormatException('EA20: $field is not an object');

List<dynamic> _list(Object? v, String field) =>
    v is List ? v : throw FormatException('EA20: $field is not a list');

String _string(Object? v, String field) =>
    v is String ? v : throw FormatException('EA20: $field is not a string');

final _digits = RegExp(r'^\d+$');

int _int(Object? v, String field) {
  final s = _string(v, field);
  if (!_digits.hasMatch(s)) {
    throw FormatException('EA20: $field "$s" is not a count');
  }
  return int.parse(s);
}

/// A count TSE leaves out where it does not apply (legend votes on
/// majoritarian offices).
int _optInt(Object? v, String field) => v == null ? 0 : _int(v, field);

import 'dart:async';

import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/resultados/resultados_controller.dart';

ElectionSummary election(
  int code, {
  required DateTime day,
  required String level,
  required List<int> offices,
  int round = 1,
  bool all = false,
  List<String> scopes = const [],
}) => ElectionSummary(
  code: code,
  round: round,
  day: day,
  name: 'Eleição $code',
  level: level,
  offices: offices,
  allMunicipalities: all,
  municipalScopes: scopes,
);

/// EA11 as of 10/10/2026, newest first (as the server sends it).
final sampleElections = [
  election(
    6260,
    day: DateTime.utc(2026, 10, 25),
    level: 'state',
    offices: [3],
    round: 2,
  ),
  election(
    6258,
    day: DateTime.utc(2026, 10, 25),
    level: 'federal',
    offices: [1],
    round: 2,
  ),
  election(
    6259,
    day: DateTime.utc(2026, 10, 4),
    level: 'state',
    offices: [3, 5, 6, 7, 8],
  ),
  election(
    6257,
    day: DateTime.utc(2026, 10, 4),
    level: 'federal',
    offices: [1],
  ),
  election(
    620,
    day: DateTime.utc(2024, 10, 27),
    level: 'municipal',
    offices: [11],
    round: 2,
    scopes: ['sp71072', 'am02550'],
  ),
  election(
    619,
    day: DateTime.utc(2024, 10, 6),
    level: 'municipal',
    offices: [11, 13],
    all: true,
  ),
];

CandidateReport cand(
  int number,
  String name,
  int votes, {
  String party = 'P1',
  String list = '1',
  bool elected = false,
  String status = 'Suplente',
  String? ourSeat,
}) => CandidateReport(
  number: number,
  ballotName: name,
  party: party,
  list: list,
  votes: votes,
  validity: 'valid',
  elected: elected,
  tseStatus: status,
  ourSeat: ourSeat,
);

/// A small proportional race (3 seats) whose allocation matches TSE.
OfficeReport proportionalReport({
  int election = 6259,
  int office = 6,
  String scope = 'sp',
  bool matches = true,
  int totalized = 100,
}) => OfficeReport(
  electionCode: election,
  round: 1,
  officeCode: office,
  proportional: true,
  scopeCode: scope,
  seats: 3,
  fileName: '$scope-c000$office-e00$election-u.jws',
  signature: SignatureStatus.valid,
  tseGeneratedAt: DateTime.utc(2026, 10, 5, 14, 44),
  fetchedAt: DateTime.utc(2026, 10, 5, 14, 45),
  complete: totalized == 100,
  sectionsTotal: 100,
  sectionsTotalized: totalized,
  totalVotes: 1200,
  validVotes: 1000,
  nominalVotes: 900,
  legendVotes: 100,
  blankVotes: 120,
  nullVotes: 80,
  annulledSubJudice: 0,
  lists: [
    ListReport(
      number: '1',
      name: 'FEDERAÇÃO AZUL',
      kind: 'federation',
      parties: ['P1', 'P2'],
      votes: 600,
      legendVotes: 60,
      tseSeats: 2,
      ourSeats: matches ? 2 : 1,
      partyQuotient: 1,
    ),
    ListReport(
      number: '2',
      name: 'PARTIDO VERDE CLARO',
      kind: 'party',
      parties: ['P3'],
      votes: 400,
      legendVotes: 40,
      tseSeats: 1,
      ourSeats: matches ? 1 : 2,
      partyQuotient: 1,
    ),
  ],
  candidates: [
    cand(
      1111,
      'ANA LIMA',
      400,
      elected: true,
      status: 'Eleito por QP',
      ourSeat: 'QP',
    ),
    cand(
      3333,
      'JOÃO SOUZA',
      300,
      party: 'P3',
      list: '2',
      elected: true,
      status: 'Eleito por QP',
      ourSeat: 'QP',
    ),
    cand(
      2222,
      'BRUNO DIAS',
      140,
      party: 'P2',
      elected: true,
      status: 'Eleito por média',
      ourSeat: 'média',
    ),
    cand(3334, 'CARLA ROCHA', 60, party: 'P3', list: '2'),
  ],
  seatCheck: SeatCheck(
    quotient: 333,
    tseQuotient: 333,
    matches: matches,
    listDifferences: matches ? 0 : 2,
    candidateDifferences: matches ? 0 : 2,
    unfilled: 0,
  ),
);

/// Prefeito, 1st round: two go to the 2nd round.
OfficeReport majoritarianReport({String scope = 'sp71072'}) => OfficeReport(
  electionCode: 619,
  round: 1,
  officeCode: 11,
  proportional: false,
  scopeCode: scope,
  seats: 1,
  fileName: '$scope-c0011-e000619-u.jws',
  signature: SignatureStatus.valid,
  tseGeneratedAt: DateTime.utc(2024, 10, 7, 2),
  fetchedAt: DateTime.utc(2024, 10, 7, 2, 1),
  complete: true,
  sectionsTotal: 100,
  sectionsTotalized: 100,
  totalVotes: 1000,
  validVotes: 900,
  nominalVotes: 900,
  legendVotes: 0,
  blankVotes: 60,
  nullVotes: 40,
  annulledSubJudice: 0,
  lists: [],
  candidates: [
    cand(15, 'CANDIDATO A', 450, status: '2º turno'),
    cand(50, 'CANDIDATA B', 300, status: '2º turno'),
    cand(40, 'CANDIDATO C', 150, status: 'Não eleito'),
  ],
  seatCheck: null,
);

class FakeResultadosSource implements ResultadosSource {
  List<ElectionSummary> elections = sampleElections;
  OfficeReport Function(int eleicao, int cargo, String abrangencia) report =
      (e, c, a) => c == 11 || c == 1 || c == 3 || c == 5
      ? majoritarianReport(scope: a)
      : proportionalReport(election: e, office: c, scope: a);
  Object? failWith;
  final reportCalls = <(int, int, String)>[];
  final municipioCalls = <(int, String)>[];

  /// When set, reports wait for it to complete.
  Completer<void>? gate;

  final camaraCalls = <int>[];

  @override
  Future<ChamberReport> camara(int eleicao) async {
    camaraCalls.add(eleicao);
    return ChamberReport(
      electionCode: eleicao,
      seats: 513,
      states: 27,
      matchingStates: 27,
      differingStates: [],
      lists: [
        ListReport(
          number: 'P1/P2',
          name: 'FEDERAÇÃO AZUL',
          kind: 'federation',
          parties: ['P1', 'P2'],
          votes: 30000000,
          legendVotes: 1000000,
          tseSeats: 300,
          ourSeats: 300,
        ),
        ListReport(
          number: 'P3',
          name: 'PARTIDO VERDE CLARO',
          kind: 'party',
          parties: ['P3'],
          votes: 20000000,
          legendVotes: 500000,
          tseSeats: 213,
          ourSeats: 213,
        ),
      ],
    );
  }

  @override
  Future<List<ElectionSummary>> eleicoes() async => elections;

  @override
  Future<List<MunicipioRef>> municipios(int eleicao, String uf) async {
    municipioCalls.add((eleicao, uf));
    return [
      MunicipioRef(codigo: 71072, nome: 'SÃO PAULO'),
      MunicipioRef(codigo: 62910, nome: 'CAMPINAS'),
    ];
  }

  @override
  Future<OfficeReport> resultado(
    int eleicao,
    int cargo,
    String abrangencia,
  ) async {
    reportCalls.add((eleicao, cargo, abrangencia));
    await gate?.future;
    final e = failWith;
    if (e != null) throw e;
    return report(eleicao, cargo, abrangencia);
  }
}

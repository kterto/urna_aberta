import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart' hide Scope;

import '../generated/protocol.dart';
import '../live/elections.dart';
import '../tse/ea12.dart';
import '../tse/tse_client.dart';
import '../tse/tse_urls.dart';
import '../verify/jws.dart';
import 'ea20_result.dart';
import 'seats.dart';

/// Resultados: any office of any ordinary election TSE lists, read from its
/// signed EA20 file. Each file is fetched once through the rate-limited
/// client, stored raw ([ResultFile]) and re-read from the database after.
///
/// A 404 pauses every TSE request, so nothing is requested before an
/// election's polls close, and a municipality must be in EA12 first.
class ResultsService {
  ResultsService({
    required this._client,
    required this._elections,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final TseClient _client;
  final List<Election> Function() _elections;
  final DateTime Function() _now;
  final _municipalities = <int, Municipalities>{};
  final _chambers =
      <int, ({String key, DateTime? until, ChamberReport report})>{};

  /// Newest first.
  List<ElectionSummary> elections() => [
    for (final e in _elections()..sort((a, b) => _compareDays(b, a)))
      ElectionSummary(
        code: e.code,
        round: e.round,
        day: DateTime.utc(e.day.$1, e.day.$2, e.day.$3),
        name: e.name,
        level: e.offices.first.level.name,
        offices: [for (final o in e.offices) o.code]..sort(),
        allMunicipalities: e.allMunicipalities,
        municipalScopes: {
          for (final (scope, _) in e.targets)
            if (scope.isMunicipality) scope.code,
        }.toList(),
      ),
  ];

  Future<List<MunicipioRef>> municipios(int electionCode, String uf) async {
    final ea12 = await municipalities(_election(electionCode));
    return [
      for (final m in ea12.byUf[uf.toLowerCase()] ?? const <Municipio>[])
        MunicipioRef(codigo: m.code, nome: m.name),
    ];
  }

  /// One result file a report planner has already checked against EA11
  /// and EA12: read once, stored, re-read while the count is on.
  Future<(OfficeResult, ResultFile, Uri)> load(
    Session session,
    int electionCode,
    Office office,
    Scope scope,
  ) async {
    final election = _election(electionCode);
    final uri = TseUrls.oficial(
      year: election.day.$1,
    ).resultJws(election.code, scope, office);
    final (parsed, file) = await _load(session, election, office, scope, uri);
    return (parsed, file, uri);
  }

  Future<OfficeReport> result(
    Session session,
    int electionCode,
    int officeCode,
    String scopeCode,
  ) async {
    final election = _election(electionCode);
    final office = Office.byCode(officeCode);
    if (office == null || !election.offices.contains(office)) {
      throw _invalid('A eleição $electionCode não elege o cargo $officeCode.');
    }
    final scope = await _scope(election, scopeCode);
    final urls = TseUrls.oficial(year: election.day.$1);
    final Uri uri;
    try {
      uri = urls.resultJws(election.code, scope, office);
    } on ArgumentError {
      throw _invalid('O cargo $officeCode não é eleito em $scopeCode.');
    }

    final (parsed, file) = await _load(session, election, office, scope, uri);
    return _report(parsed, file, uri.pathSegments.last);
  }

  /// The Câmara: every UF's Deputado Federal race, summed by party or
  /// federation (matched by their parties), with our allocation per UF.
  Future<ChamberReport> chamber(Session session, int electionCode) async {
    final election = _election(electionCode);
    const office = Office.deputadoFederal;
    if (!election.offices.contains(office)) {
      throw _invalid('A eleição $electionCode não elege deputados federais.');
    }
    _assertClosed(election);
    final cached = _chambers[election.code];
    if (cached != null &&
        cached.key == await _chamberKey(session, election.code) &&
        (cached.until == null || _now().isBefore(cached.until!))) {
      return cached.report;
    }
    final urls = TseUrls.oficial(year: election.day.$1);
    var complete = true;
    final byKey = <String, _ChamberList>{};
    final differing = <String>[];
    var seats = 0, states = 0;
    for (final (scope, o) in election.targets) {
      if (o != office) continue;
      final uri = urls.resultJws(election.code, scope, office);
      final (r, _) = await _load(session, election, office, scope, uri);
      complete &= _complete(r);
      final ours = allocateSeats(r);
      if (!SeatComparison.of(r, ours).matches) differing.add(scope.code);
      seats += r.seats;
      states++;
      for (final l in r.lists) {
        final parties = [for (final p in l.parties) p.abbrev]..sort();
        final sum = byKey.putIfAbsent(
          parties.join('/'),
          () => _ChamberList(l.name, parties, l.kind),
        );
        sum.votes += l.votes;
        sum.legend += l.parties.fold(0, (s, p) => s + p.legendVotes);
        sum.tseSeats += l.seatsWon ?? 0;
        sum.ourSeats += ours.seatsOf(l.number);
      }
    }
    final lists = byKey.entries.toList()
      ..sort((a, b) {
        final bySeats = b.value.tseSeats.compareTo(a.value.tseSeats);
        return bySeats != 0 ? bySeats : b.value.votes.compareTo(a.value.votes);
      });
    final report = ChamberReport(
      electionCode: election.code,
      seats: seats,
      states: states,
      matchingStates: states - differing.length,
      differingStates: differing,
      lists: [
        for (final MapEntry(key: key, value: l) in lists)
          ListReport(
            number: key,
            name: l.name,
            kind: l.kind.name,
            parties: l.parties,
            votes: l.votes,
            legendVotes: l.legend,
            tseSeats: l.tseSeats,
            ourSeats: l.ourSeats,
          ),
      ],
    );
    // A new version of any state's file is a new key; while the count is
    // on, the sum is also re-read as often as the files.
    _chambers[election.code] = (
      key: await _chamberKey(session, election.code),
      until: complete ? null : _now().add(refreshAfter),
      report: report,
    );
    return report;
  }

  /// Changes when a file is stored or read again; reads no `jws`.
  Future<String> _chamberKey(Session session, int electionCode) async {
    final row = (await session.db.unsafeQuery(
      'SELECT max("id"), max("fetchedAt") FROM "result_file" '
      'WHERE "electionCode" = @e AND "officeCode" = @o',
      parameters: QueryParameters.named({
        'e': electionCode,
        'o': Office.deputadoFederal.code,
      }),
    )).first;
    return 'camara:$electionCode:${row[0]}:${row[1]}';
  }

  /// How long an incomplete file is trusted before TSE is asked again
  /// (a conditional GET, so an unchanged file costs a 304).
  static const refreshAfter = Duration(seconds: 30);

  /// The latest stored version; an incomplete one (the count is still on)
  /// is re-read once it is [refreshAfter] old. If TSE fails then, the
  /// stored version is served.
  Future<(OfficeResult, ResultFile)> _load(
    Session session,
    Election election,
    Office office,
    Scope scope,
    Uri uri,
  ) async {
    final uf = scope.isMunicipality ? scope.uf : null;
    OfficeResult parse(ResultFile f) =>
        parseOfficeResult(TseJws.parse(f.jws).payload, uf: uf);

    final stored = await _stored(session, election.code, office, scope);
    if (stored != null) {
      final r = parse(stored);
      final fresh = _now().difference(stored.fetchedAt) < refreshAfter;
      if (_complete(r) || fresh) return (r, stored);
      try {
        final file = await _fetch(session, election, office, scope, uri);
        return (parse(file), file);
      } on ResultUnavailable {
        return (r, stored);
      }
    }
    final file = await _fetch(session, election, office, scope, uri);
    return (parse(file), file);
  }

  static bool _complete(OfficeResult r) =>
      r.sectionsTotal > 0 && r.sectionsTotalized == r.sectionsTotal;

  Election _election(int code) =>
      _elections().where((e) => e.code == code).firstOrNull ??
      (throw _invalid('O TSE não lista a eleição $code.'));

  Future<Scope> _scope(Election election, String code) async {
    final c = code.toLowerCase();
    try {
      if (c == 'br') return Scope.brazil();
      if (c.length == 2) return Scope.uf(c);
      final m = RegExp(r'^([a-z]{2})(\d{5})$').firstMatch(c);
      if (m == null) throw ArgumentError.value(code);
      final scope = Scope.municipality(m[1]!, int.parse(m[2]!));
      final listed = election.allMunicipalities
          ? (await municipalities(
                  election,
                )).byCode(scope.uf, scope.municipio!) !=
                null
          : election.targets.any((t) => t.$1 == scope);
      if (!listed) throw ArgumentError.value(code);
      return scope;
    } on ArgumentError {
      throw _invalid('O TSE não lista $code nesta eleição.');
    }
  }

  /// The election's EA12, read once and checked against TSE's signature.
  Future<Municipalities> municipalities(Election election) async {
    final cached = _municipalities[election.code];
    if (cached != null) return cached;
    _assertClosed(election);
    final body = await _get(
      TseUrls.oficial(
        year: election.day.$1,
      ).municipalitiesConfigJws(election.code),
    );
    final jws = TseJws.parse(utf8.decode(body));
    if (await checkJws(jws) != JwsCheck.valid) {
      throw ResultUnavailable(
        message: 'A lista de municípios do TSE não tem assinatura válida.',
        reason: 'tseUnavailable',
      );
    }
    return _municipalities[election.code] = parseEa12(jws.payload);
  }

  Future<ResultFile?> _stored(
    Session session,
    int election,
    Office office,
    Scope scope,
  ) => ResultFile.db.findFirstRow(
    session,
    where: (t) =>
        t.electionCode.equals(election) &
        t.officeCode.equals(office.code) &
        t.scopeCode.equals(scope.code),
    // The version read most recently (two versions can share TSE's
    // timestamp, and TSE could serve an older one again).
    orderBy: (t) => t.fetchedAt.desc(),
  );

  Future<ResultFile> _fetch(
    Session session,
    Election election,
    Office office,
    Scope scope,
    Uri uri,
  ) async {
    _assertClosed(election);
    final body = await _get(uri);
    final digest = sha256.convert(body).toString();
    // Same bytes as a stored version: only note that it was read again.
    final same = await ResultFile.db.findFirstRow(
      session,
      where: (t) =>
          t.electionCode.equals(election.code) &
          t.officeCode.equals(office.code) &
          t.scopeCode.equals(scope.code) &
          t.rawSha256.equals(digest),
    );
    if (same != null) {
      return ResultFile.db.updateRow(
        session,
        same.copyWith(fetchedAt: _now().toUtc()),
      );
    }
    final text = utf8.decode(body);
    final jws = TseJws.parse(text);
    final check = await checkJws(jws);
    final parsed = parseOfficeResult(
      jws.payload,
      uf: scope.isMunicipality ? scope.uf : null,
    );
    return ResultFile.db.insertRow(
      session,
      ResultFile(
        electionCode: election.code,
        officeCode: office.code,
        scopeCode: scope.code,
        tseGeneratedAt: parsed.generatedAt,
        fetchedAt: _now().toUtc(),
        rawSha256: digest,
        signature: switch (check) {
          JwsCheck.valid => SignatureStatus.valid,
          JwsCheck.invalid => SignatureStatus.invalid,
          JwsCheck.unknownKey => SignatureStatus.unknownKey,
        },
        jws: text,
      ),
    );
  }

  /// TSE publishes from 17:00 Brasília on election day; asking earlier
  /// can only 404.
  void _assertClosed(Election election) {
    if (_now().isBefore(election.opensAt)) {
      throw ResultUnavailable(
        message: 'O TSE ainda não publicou resultados desta eleição.',
        reason: 'notPublished',
      );
    }
  }

  Future<List<int>> _get(Uri uri) async {
    try {
      return switch (await _client.fetch(uri)) {
        Fetched(:final body) => body,
        NotModified(:final cachedBody) => cachedBody,
      };
    } on TseNotFound {
      throw ResultUnavailable(
        message: 'O TSE não publicou este arquivo.',
        reason: 'notPublished',
      );
    } on TseException {
      throw ResultUnavailable(
        message: 'O TSE não respondeu; tente de novo em instantes.',
        reason: 'tseUnavailable',
      );
    }
  }

  OfficeReport _report(OfficeResult r, ResultFile file, String fileName) {
    final allocation = r.office.proportional ? allocateSeats(r) : null;
    final comparison = allocation == null
        ? null
        : SeatComparison.of(r, allocation);
    final ourSeat = {
      for (final s in allocation?.elected ?? const <Seat>[])
        s.candidate.sequence: s.phase == SeatPhase.quotient ? 'QP' : 'média',
    };
    final parties = {
      for (final l in r.lists)
        for (final p in l.parties) p.number: p,
    };
    return OfficeReport(
      electionCode: r.election,
      round: r.round,
      officeCode: r.office.code,
      proportional: r.office.proportional,
      scopeCode: r.scope,
      seats: r.seats,
      fileName: fileName,
      signature: file.signature,
      tseGeneratedAt: r.generatedAt,
      fetchedAt: file.fetchedAt,
      complete: _complete(r),
      sectionsTotal: r.sectionsTotal,
      sectionsTotalized: r.sectionsTotalized,
      totalVotes: r.totals.total,
      validVotes: r.totals.valid,
      nominalVotes: r.totals.nominal,
      legendVotes: r.totals.legend,
      blankVotes: r.totals.blank,
      nullVotes: r.totals.nullVotes,
      annulledSubJudice: r.totals.annulledSubJudice,
      lists: [
        for (final l
            in r.lists.toList()..sort((a, b) => b.votes.compareTo(a.votes)))
          ListReport(
            number: l.number,
            name: l.name,
            kind: l.kind.name,
            parties: [for (final p in l.parties) p.abbrev],
            votes: l.votes,
            legendVotes: l.parties.fold(0, (s, p) => s + p.legendVotes),
            tseSeats: l.seatsWon,
            ourSeats: allocation?.seatsOf(l.number),
            partyQuotient: allocation?.lists[l.number]?.partyQuotient,
          ),
      ],
      candidates: [
        for (final c
            in r.candidates.toList()
              ..sort((a, b) => b.votes.compareTo(a.votes)))
          CandidateReport(
            number: c.number,
            ballotName: c.ballotName,
            party: parties[c.party]?.abbrev ?? '',
            list: c.list,
            votes: c.votes,
            validity: c.validity.name,
            elected: c.elected,
            tseStatus: c.rawStatus,
            ourSeat: ourSeat[c.sequence],
          ),
      ],
      seatCheck: comparison == null
          ? null
          : SeatCheck(
              quotient: comparison.quotient,
              tseQuotient: comparison.tseQuotient,
              matches: comparison.matches,
              listDifferences: comparison.lists.length,
              candidateDifferences: comparison.candidates.length,
              unfilled: allocation!.unfilled,
            ),
    );
  }

  static ResultUnavailable _invalid(String message) =>
      ResultUnavailable(message: message, reason: 'invalidRequest');

  static int _compareDays(Election a, Election b) {
    final byDay = DateTime.utc(a.day.$1, a.day.$2, a.day.$3).compareTo(
      DateTime.utc(b.day.$1, b.day.$2, b.day.$3),
    );
    return byDay != 0 ? byDay : a.code.compareTo(b.code);
  }
}

class _ChamberList {
  _ChamberList(this.name, this.parties, this.kind);

  final String name;
  final List<String> parties;
  final ListKind kind;
  int votes = 0, legend = 0, tseSeats = 0, ourSeats = 0;
}

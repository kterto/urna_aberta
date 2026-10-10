import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../tally/aggregator.dart';
import '../tally/ea20.dart';
import '../tse/tse_urls.dart';

/// Stores EA20 files as immutable [ResultSnapshot] versions.
abstract final class SnapshotStore {
  /// Records one EA20 file. A file already stored for [origin] (same hash)
  /// returns the existing row with `isNew: false`.
  ///
  /// Throws [FormatException] when the file is malformed or its own
  /// election or office code differs from [electionCode] / [office].
  static Future<({ResultSnapshot snapshot, bool isNew})> record(
    Session session, {
    required DataOrigin origin,
    required int electionCode,
    required Office office,
    required List<int> bytes,
    required DateTime fetchedAt,
  }) async {
    final result = parseEa20(bytes);
    _checkIdentity(bytes, electionCode, office);
    final sha = sha256.convert(bytes).toString();

    return session.db.transaction((tx) async {
      final existing = await ResultSnapshot.db.findFirstRow(
        session,
        where: (t) =>
            t.origin.equals(origin) &
            t.electionCode.equals(electionCode) &
            t.officeCode.equals(office.code) &
            t.scopeCode.equals(result.scope) &
            t.rawSha256.equals(sha),
        transaction: tx,
      );
      await _recordCandidates(session, tx, electionCode, office, result);
      if (existing != null) return (snapshot: existing, isNew: false);

      final snapshot = await ResultSnapshot.db.insertRow(
        session,
        ResultSnapshot(
          origin: origin,
          electionCode: electionCode,
          officeCode: office.code,
          scopeCode: result.scope,
          sectionsTotal: result.sectionsTotal,
          sectionsTotalized: result.sectionsTotalized,
          tseGeneratedAt: result.generatedAt!,
          fetchedAt: fetchedAt,
          rawSha256: sha,
        ),
        transaction: tx,
      );
      await CandidateTally.db.insert(session, [
        for (final MapEntry(key: n, value: v) in result.votes.entries)
          CandidateTally(
            snapshotId: snapshot.id!,
            candidateNumber: n,
            votes: v,
          ),
      ], transaction: tx);
      return (snapshot: snapshot, isNew: true);
    });
  }

  /// The newest stored version of each scope generated at or before [at].
  static Future<List<ScopeResult>> latestAt(
    Session session, {
    required DataOrigin origin,
    required int electionCode,
    required Office office,
    required DateTime at,
  }) async {
    final rows = await ResultSnapshot.db.find(
      session,
      where: (t) =>
          t.origin.equals(origin) &
          t.electionCode.equals(electionCode) &
          t.officeCode.equals(office.code) &
          (t.tseGeneratedAt <= at),
      orderBy: (t) => t.tseGeneratedAt.desc(),
      include: ResultSnapshot.include(tallies: CandidateTally.includeList()),
    );
    final names = <String, Map<int, CandidateInfo>>{};
    for (final c in await Candidate.db.find(
      session,
      where: (t) =>
          t.electionCode.equals(electionCode) &
          t.officeCode.equals(office.code),
    )) {
      (names[c.scopeCode] ??= {})[c.number] = CandidateInfo(
        ballotName: c.ballotName,
        party: c.party,
      );
    }
    final byScope = <String, ResultSnapshot>{};
    for (final r in rows) {
      byScope.putIfAbsent(r.scopeCode, () => r);
    }
    return [
      for (final s in byScope.values)
        ScopeResult(
          scope: s.scopeCode,
          sectionsTotal: s.sectionsTotal,
          sectionsTotalized: s.sectionsTotalized,
          votes: {for (final t in s.tallies!) t.candidateNumber: t.votes},
          generatedAt: s.tseGeneratedAt,
          candidates: names[s.scopeCode] ?? const {},
        ),
    ];
  }

  /// Adds candidacies not yet known for this election, office and scope.
  /// A later file never renames one already stored.
  static Future<void> _recordCandidates(
    Session session,
    Transaction tx,
    int electionCode,
    Office office,
    ScopeResult result,
  ) async {
    final known = await Candidate.db.find(
      session,
      where: (t) =>
          t.electionCode.equals(electionCode) &
          t.officeCode.equals(office.code) &
          t.scopeCode.equals(result.scope),
      transaction: tx,
    );
    final numbers = {for (final c in known) c.number};
    await Candidate.db.insert(session, [
      for (final MapEntry(key: n, value: c) in result.candidates.entries)
        if (!numbers.contains(n))
          Candidate(
            electionCode: electionCode,
            officeCode: office.code,
            scopeCode: result.scope,
            number: n,
            ballotName: c.ballotName,
            party: c.party,
          ),
    ], transaction: tx);
  }

  /// The file names its election (`ele`) and office (`carg[].cd`); a caller
  /// passing other codes would mislabel it.
  static void _checkIdentity(List<int> bytes, int electionCode, Office office) {
    final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    final ele = json['ele'];
    if (ele != '$electionCode') {
      throw FormatException('EA20: file is election $ele, not $electionCode');
    }
    for (final c in json['carg'] as List) {
      final cd = (c as Map)['cd'];
      if (cd != '${office.code}') {
        throw FormatException('EA20: file is office $cd, not ${office.code}');
      }
    }
  }
}

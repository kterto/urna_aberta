import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/results/ea20_result.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

/// The signed result files archived from TSE (see fixtures/README.md).
OfficeResult load(String path) {
  final file = File('../fixtures/$path');
  final bytes = path.endsWith('.jws')
      ? TseJws.parse(file.readAsStringSync()).payload
      : file.readAsBytesSync();
  // Municipal files live under their UF folder: `…/dados/sp/sp71072-…`.
  final uf = RegExp(r'/dados/([a-z]{2})/[a-z]{2}\d{5}-').firstMatch(path)?[1];
  return parseOfficeResult(bytes, uf: uf);
}

void main() {
  group('Deputado Federal, SP, 2026', () {
    final r = load(
      '2026-1t/oficial/ele2026/6259/dados/sp/sp-c0006-e006259-u.jws',
    );

    test('office, scope, seats and TSE quotient', () {
      expect(r.election, 6259);
      expect(r.round, 1);
      expect(r.scope, 'sp');
      expect(r.office, Office.deputadoFederal);
      expect(r.seats, 70);
      expect(r.electoralQuotient, 338203);
      expect(r.totals.valid, 23674188);
      expect(r.totals.nominal, 22988308);
      expect(r.totals.legend, 685880);
      expect(r.totals.annulledSubJudice, 30358);
    });

    test('party votes add up to the valid total', () {
      final parties = r.lists.expand((l) => l.parties);
      expect(parties.fold(0, (s, p) => s + p.nominalVotes), r.totals.nominal);
      expect(parties.fold(0, (s, p) => s + p.legendVotes), r.totals.legend);
      expect(
        r.lists.fold(0, (s, l) => s + l.votes),
        r.totals.nominal + r.totals.legend,
      );
    });

    test('party nominal votes count only valid candidacies', () {
      final pl = r.lists
          .expand((l) => l.parties)
          .singleWhere((p) => p.abbrev == 'PL');
      expect(pl.nominalVotes, 6278173);
      expect(
        pl.candidates
            .where((c) => c.validity == Validity.valid)
            .fold(0, (s, c) => s + c.votes),
        6278173,
      );
      expect(
        pl.candidates.any((c) => c.validity == Validity.annulledSubJudice),
        isTrue,
      );
    });

    test('a federation is one list of several parties', () {
      final fed = r.lists.singleWhere(
        (l) => l.parties.any((p) => p.abbrev == 'PT'),
      );
      expect(fed.kind, ListKind.federation);
      expect(fed.parties.length, greaterThan(1));
    });

    test('TSE seats per list and elected candidates', () {
      expect(r.lists.fold(0, (s, l) => s + l.seatsWon!), 70);
      final elected = r.candidates.where((c) => c.elected);
      expect(elected, hasLength(70));
      expect(
        elected.where((c) => c.status == CandidateStatus.electedByQuotient),
        hasLength(60),
      );
      expect(
        elected.where((c) => c.status == CandidateStatus.electedByAverage),
        hasLength(10),
      );
      expect(r.candidates.first.birthDate, isNotNull);
    });
  });

  group('Vereador, São Paulo, 2024', () {
    final r = load(
      '2024/oficial/ele2024/619/dados/sp/sp71072-c0013-e000619-u.jws',
    );

    test('municipality scope, 55 seats, 46 by quotient and 9 by average', () {
      expect(r.election, 619);
      expect(r.scope, 'sp71072');
      expect(r.office, Office.vereador);
      expect(r.seats, 55);
      expect(r.electoralQuotient, 105110);
      final elected = r.candidates.where((c) => c.elected).toList();
      expect(elected, hasLength(55));
      expect(
        elected.where((c) => c.status == CandidateStatus.electedByAverage),
        hasLength(9),
      );
    });
  });

  test('votes of a candidate barred after the election go to the party', () {
    final r = load(
      '2024/oficial/ele2024/619/dados/rj/rj60011-c0013-e000619-u.jws',
    );
    final party = r.lists
        .expand((l) => l.parties)
        .singleWhere((p) => p.abbrev == 'REPUBLICANOS');
    final moved = party.candidates.singleWhere(
      (c) => c.validity == Validity.validForParty,
    );
    expect(moved.elected, isFalse);
    // 2,592 direct legend votes + the barred candidate's 10,074.
    expect(party.legendVotes, 2592 + moved.votes);
    expect(moved.votes, 10074);
  });

  group('majoritarian offices', () {
    test('Prefeito SP 2024: two go to the 2nd round, then one is elected', () {
      final first = load(
        '2024/oficial/ele2024/619/dados/sp/sp71072-c0011-e000619-u.jws',
      );
      expect(first.office, Office.prefeito);
      expect(first.seats, 1);
      expect(first.electoralQuotient, isNull);
      expect(
        first.candidates.where((c) => c.status == CandidateStatus.secondRound),
        hasLength(2),
      );
      final second = load(
        '2024/oficial/ele2024/620/dados/sp/sp71072-c0011-e000620-u.jws',
      );
      expect(second.round, 2);
      expect(second.candidates.where((c) => c.elected), hasLength(1));
    });

    test('Senador SP 2026: two seats, coalitions', () {
      final r = load(
        '2026-1t/oficial/ele2026/6259/dados/sp/sp-c0005-e006259-u.json',
      );
      expect(r.office, Office.senador);
      expect(r.seats, 2);
      expect(r.lists.any((l) => l.kind == ListKind.coalition), isTrue);
      expect(r.candidates.where((c) => c.elected), hasLength(2));
    });
  });

  test('a municipal file without its UF is refused', () {
    final bytes = TseJws.parse(
      File(
        '../fixtures/2024/oficial/ele2024/619/dados/sp/sp71072-c0011-e000619-u.jws',
      ).readAsStringSync(),
    ).payload;
    expect(() => parseOfficeResult(bytes), throwsFormatException);
  });

  test('malformed input is refused', () {
    expect(() => parseOfficeResult(utf8.encode('{}')), throwsFormatException);
    expect(() => parseOfficeResult(utf8.encode('nope')), throwsFormatException);
  });
}

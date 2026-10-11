import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/reports/tally.dart';
import 'package:urna_aberta_server/src/results/ea20_result.dart';
import 'package:urna_aberta_server/src/tse/ea12.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

const _dados = '../fixtures/2026-1t/oficial/ele2026';

(OfficeResult, TallySource) file(int election, String scope, Office office) {
  final name = '$scope-${office.fileCode}-e00$election-u.jws';
  final jws = File(
    '$_dados/$election/dados/${scope.substring(0, 2)}/$name',
  ).readAsStringSync();
  final uf = scope.length > 2 ? scope.substring(0, 2) : null;
  return (
    parseOfficeResult(TseJws.parse(jws).payload, uf: uf),
    TallySource(name: name, url: name, sha256: '', check: 'valid'),
  );
}

void main() {
  final acCities = parseEa12(
    TseJws.parse(
      File('$_dados/6257/config/mun-e006257-cm.jws').readAsStringSync(),
    ).payload,
  ).byUf['ac']!;

  group('a sum of result files', () {
    test("the 22 AC cities add up to TSE's AC file, figure by figure", () {
      final tse = sumResults(Office.presidente, [
        file(6257, 'ac', Office.presidente),
      ]);
      final ours = sumResults(Office.presidente, [
        for (final m in acCities)
          file(
            6257,
            Scope.municipality('ac', m.code).code,
            Office.presidente,
          ),
      ]);
      expect(ours.sources, hasLength(22));
      expect(compareTallies(tse, ours), isEmpty);
      expect(ours.total, 488330);
      expect(ours.electorate, 613742);
      expect(ours.turnout, 488330);
    });

    test('one race lists candidacies, with status from the race file', () {
      final t = sumResults(Office.presidente, [
        file(6257, 'ac', Office.presidente),
        file(6257, 'ap', Office.presidente),
      ]);
      expect(t.byCandidate, isTrue);
      final first = t.rows.first;
      expect(first.key, startsWith('c'));
      expect(first.party, isNotNull);
      // A UF file is part of the national race: no status from it.
      expect(first.status, isNull);
      expect(
        sumResults(Office.presidente, [
          file(6257, 'br', Office.presidente),
        ]).rows.first.status,
        isNotEmpty,
      );
    });

    test('several races list parties', () {
      final t = sumResults(Office.governador, [
        for (final uf in ['ac', 'am', 'ap', 'pa', 'ro', 'rr', 'to'])
          file(6259, uf, Office.governador),
      ]);
      expect(t.byCandidate, isFalse);
      expect(t.rows.every((r) => r.key.startsWith('p')), isTrue);
      expect(t.rows.fold(0, (s, r) => s + r.votes), t.valid);
    });

    test("proportional races sum TSE's seats per party", () {
      final ufs = ['ac', 'am', 'ap', 'pa', 'ro', 'rr', 'to'];
      final t = sumResults(Office.deputadoFederal, [
        for (final uf in ufs) file(6259, uf, Office.deputadoFederal),
      ]);
      // The North elects 65 federal deputies.
      expect(t.rows.fold(0, (s, r) => s + (r.seats ?? 0)), 65);
      expect([t.races, t.racesMatching], [7, 7]);
    });

    test('a city of a proportional race has votes but no seats', () {
      final t = sumResults(Office.presidente, [
        file(6257, 'ac01066', Office.presidente),
      ]);
      expect(t.rows.every((r) => r.seats == null), isTrue);
    });
  });

  test('a difference names the figure and both values', () {
    final a = sumResults(Office.presidente, [
      file(6257, 'ac', Office.presidente),
    ]);
    final b = sumResults(Office.presidente, [
      file(6257, 'ac01066', Office.presidente),
    ]);
    final diffs = compareTallies(a, b);
    expect(diffs.first.what, 'total');
    expect(diffs.first.tse, 488330);
    expect(diffs.first.ours, lessThan(488330));
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/tally/aggregator.dart';
import 'package:urna_aberta_server/src/tally/ea20.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

/// Real 1st-round files archived in `fixtures/2026-1t` (see its README).
const _dados = '../fixtures/2026-1t/oficial/ele2026/6257/dados';

ScopeResult president(String scope) => parseEa20(
  File('$_dados/$scope/$scope-c0001-e006257-u.json').readAsBytesSync(),
);

void main() {
  group('parseEa20 on archived TSE files', () {
    test('reads scope, sections and candidate votes (Acre)', () {
      final ac = president('ac');
      expect(ac.scope, 'ac');
      expect(ac.sectionsTotal, 2270);
      expect(ac.sectionsTotalized, 2270);
      expect(ac.votes[22], 302807);
    });

    test('generation time is Brasília time (UTC-3), stored as UTC', () {
      // dg 05/10/2026, hg 12:51:40 in the Acre file.
      expect(
        president('ac').generatedAt,
        DateTime.utc(2026, 10, 5, 15, 51, 40),
      );
    });

    test('the sum of the 28 per-UF files equals the national file', () {
      final br = president('br');
      final sum = sumOfStates([for (final uf in Scope.ufs) president(uf)]);
      expect(sum.complete, isTrue);
      expect(br.sectionsTotal, 499248);
      expect(sum.sectionsTotalizedPct, br.sectionsTotalizedPct);
      expect(sum.votes, br.votes);
      expect(br.votes, hasLength(12));
    });
  });

  group('parseEa20 rejects files it cannot read faithfully', () {
    List<int> ea20(Map<String, Object?> patch) {
      final base = <String, Object?>{
        'cdabr': 'ac',
        'dg': '05/10/2026',
        'hg': '12:51:40',
        's': {'ts': '10', 'st': '5'},
        'carg': [
          {
            'agr': [
              {
                'par': [
                  {
                    'cand': [
                      {'n': '22', 'vap': '7'},
                    ],
                  },
                ],
              },
            ],
          },
        ],
      };
      return utf8.encode(jsonEncode({...base, ...patch}));
    }

    test('a minimal valid file parses', () {
      final r = parseEa20(ea20({}));
      expect(r.sectionsTotalizedPct, 50);
      expect(r.votes, {22: 7});
    });

    test('missing section counts', () {
      expect(() => parseEa20(ea20({'s': null})), throwsFormatException);
    });

    test('a count that is not an integer', () {
      expect(
        () => parseEa20(
          ea20({
            's': {'ts': '10', 'st': '5,0'},
          }),
        ),
        throwsFormatException,
      );
    });

    test('more sections totalized than exist', () {
      expect(
        () => parseEa20(
          ea20({
            's': {'ts': '10', 'st': '11'},
          }),
        ),
        throwsFormatException,
      );
    });

    test('a candidate number listed twice', () {
      final cand = {'n': '22', 'vap': '7'};
      expect(
        () => parseEa20(
          ea20({
            'carg': [
              {
                'agr': [
                  {
                    'par': [
                      {
                        'cand': [cand, cand],
                      },
                    ],
                  },
                ],
              },
            ],
          }),
        ),
        throwsFormatException,
      );
    });

    test('a malformed generation date', () {
      expect(
        () => parseEa20(ea20({'dg': '2026-10-05'})),
        throwsFormatException,
      );
    });
  });
}

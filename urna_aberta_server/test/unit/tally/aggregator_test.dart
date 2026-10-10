import 'package:test/test.dart';
import 'package:urna_aberta_server/src/tally/aggregator.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

ScopeResult uf(String code, int total, int totalized, Map<int, int> votes) =>
    ScopeResult(
      scope: code,
      sectionsTotal: total,
      sectionsTotalized: totalized,
      votes: votes,
    );

void main() {
  group('independent sum of states', () {
    test('% totalized is weighted by sections, not a mean of UF percents', () {
      final sum = sumOfStates(
        [
          uf('sp', 1000, 900, {}), // 90%
          uf('rr', 10, 1, {}), // 10%
        ],
        expected: ['sp', 'rr'],
      );
      // (900 + 1) / (1000 + 10) = 89.21%, not (90 + 10) / 2 = 50%.
      expect(sum.sectionsTotalizedPct, closeTo(89.2079, 1e-4));
    });

    test('candidate votes add up across UFs and exterior', () {
      final sum = sumOfStates(
        [
          uf('ba', 100, 100, {13: 50, 22: 40}),
          uf('sp', 100, 100, {13: 30, 22: 60}),
          uf('zz', 10, 10, {13: 1, 22: 2}),
        ],
        expected: ['ba', 'sp', 'zz'],
      );
      expect(sum.votes, {13: 81, 22: 102});
    });

    test(
      'a missing UF makes the sum incomplete and names it, never estimates',
      () {
        final sum = sumOfStates(
          [
            uf('ba', 100, 50, {13: 5}),
          ],
          expected: ['ba', 'sp'],
        );
        expect(sum.complete, isFalse);
        expect(sum.missing, ['sp']);
        expect(sum.sectionsTotalizedPct, 50);
      },
    );

    test('expects all 27 UFs plus exterior by default', () {
      final sum = sumOfStates([]);
      expect(sum.missing, Scope.ufs);
    });

    test('a duplicate scope is a programming error', () {
      expect(
        () => sumOfStates(
          [uf('ba', 1, 1, {}), uf('ba', 1, 1, {})],
          expected: ['ba'],
        ),
        throwsArgumentError,
      );
    });
  });

  group('divergence: national file vs sum of states', () {
    final t0 = DateTime.utc(2026, 10, 4, 21);
    Comparison at(int minute, double br, double states) => Comparison(
      at: t0.add(Duration(minutes: minute)),
      nationalPct: br,
      statesPct: states,
    );

    test('no event while the gap stays under the threshold', () {
      final events = detectDivergence([at(0, 60, 60.2), at(5, 62, 62.4)]);
      expect(events, isEmpty);
    });

    test('the Oct 4 shape: national frozen while states keep moving', () {
      final events = detectDivergence([
        at(0, 64.0, 64.3),
        at(2, 64.81, 65.5),
        at(10, 64.81, 70.1), // frozen national file
        at(40, 64.81, 79.9),
        at(57, 84.2, 84.6), // national catches up
        at(60, 85.0, 85.1),
      ]);
      expect(events, hasLength(1));
      final e = events.single;
      expect(e.startedAt, t0.add(const Duration(minutes: 2)));
      expect(e.endedAt, t0.add(const Duration(minutes: 57)));
      expect(e.nationalPctAtStart, 64.81);
      expect(e.maxGap, closeTo(15.09, 1e-9));
      expect(e.isOpen, isFalse);
    });

    test('an event still diverging at the last sample stays open', () {
      final events = detectDivergence([at(0, 64.81, 66), at(5, 64.81, 70)]);
      expect(events.single.isOpen, isTrue);
      expect(events.single.endedAt, isNull);
    });

    test('national ahead of the states is not a lag event', () {
      expect(detectDivergence([at(0, 70, 60)]), isEmpty);
    });

    test('samples must be in time order', () {
      expect(
        () => detectDivergence([at(5, 1, 1), at(0, 1, 1)]),
        throwsArgumentError,
      );
    });
  });
}

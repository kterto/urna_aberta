import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/live/elections.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

/// EA11 as archived on 10/10/2026: it already lists the 2nd round
/// (pleito 3221, 25/10/2026).
List<int> ea11() => File(
  '../fixtures/2026-1t/oficial/comum/config/ele-c.json',
).readAsBytesSync();

void main() {
  late List<Election> all;
  setUpAll(() => all = parseElections(ea11()));

  Election byCode(int code) => all.singleWhere((e) => e.code == code);

  test('reads the 2026 ordinary elections, both rounds', () {
    final first = byCode(6257);
    expect(first.pleito, 3220);
    expect(first.round, 1);
    expect(first.day, (2026, 10, 4));
    final second = byCode(6258);
    expect(second.pleito, 3221);
    expect(second.round, 2);
    expect(second.day, (2026, 10, 25));
  });

  test('President: Brazil, every UF and abroad', () {
    final targets = byCode(6258).targets;
    expect(targets, hasLength(29));
    expect(targets.first, (Scope.brazil(), Office.presidente));
    expect(targets.map((t) => t.$1.code), containsAll(['br', 'sp', 'zz']));
    expect(targets.map((t) => t.$2).toSet(), {Office.presidente});
  });

  test('state 1st round: Governor and Senator in every UF', () {
    final targets = byCode(6259).targets;
    expect(targets, hasLength(54));
    expect(targets.map((t) => t.$1.code), isNot(contains('zz')));
  });

  test('state 2nd round: Governor only where there is one', () {
    final targets = byCode(6260).targets;
    expect(targets.map((t) => t.$1.code).toSet(), {'am', 'df', 'es', 'ac'});
    expect(targets.map((t) => t.$2).toSet(), {Office.governador});
  });

  test('offices this app does not tally are left out', () {
    // Municipal (Prefeito) and plebiscites have no tracked office.
    expect(all.any((e) => e.code == 6284), isFalse);
    expect(all.any((e) => e.code == 6288), isFalse);
  });

  group('live window', () {
    Election second() => byCode(6258);

    DateTime brt(int d, int h, [int m = 0]) =>
        DateTime.utc(2026, 10, d, h + 3, m);

    test('closed before the polls close', () {
      expect(second().isLiveAt(brt(25, 16, 59)), isFalse);
    });

    test('open from 17:00 Brasília on election day', () {
      expect(second().isLiveAt(brt(25, 17)), isTrue);
      expect(second().isLiveAt(brt(25, 23, 59)), isTrue);
    });

    test('still open overnight, closed the next morning', () {
      expect(second().isLiveAt(brt(26, 5, 59)), isTrue);
      expect(second().isLiveAt(brt(26, 6)), isFalse);
    });

    test('closed on other days', () {
      expect(second().isLiveAt(brt(4, 20)), isFalse);
    });

    test('next opening is 17:00 Brasília on election day', () {
      expect(
        nextLiveWindow(all, brt(10, 9)),
        DateTime.utc(2026, 10, 25, 20),
      );
      expect(nextLiveWindow(all, brt(26, 7)), isNull);
    });
  });
}

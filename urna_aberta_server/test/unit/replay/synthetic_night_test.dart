import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/replay/synthetic_night.dart';
import 'package:urna_aberta_server/src/tally/aggregator.dart';
import 'package:urna_aberta_server/src/tally/ea20.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

const _dados = '../fixtures/2026-1t/oficial/ele2026/6257/dados';

/// Brasília time (UTC-3) on election night, as UTC.
DateTime brt(int day, int hour, int minute) =>
    DateTime.utc(2026, 10, day, hour + 3, minute);

void main() {
  final finals = [
    for (final uf in Scope.ufs)
      parseEa20(
        File('$_dados/$uf/$uf-c0001-e006257-u.json').readAsBytesSync(),
      ),
  ];
  final finalSum = sumOfStates(finals);

  SyntheticNight build() => SyntheticNight(
    finals: finals,
    start: brt(4, 17, 0),
    end: brt(5, 1, 0),
    freezeStart: brt(4, 21, 2),
    freezeEnd: brt(4, 21, 57),
  );

  final night = build();
  final minutes = [
    for (
      var t = night.start.subtract(const Duration(minutes: 5));
      !t.isAfter(night.end.add(const Duration(minutes: 5)));
      t = t.add(const Duration(minutes: 1))
    )
      t,
  ];
  double statesPct(DateTime t) =>
      sumOfStates(night.states(t)).sectionsTotalizedPct;
  double nationalPct(DateTime t) => night.national(t).sectionsTotalizedPct;

  test('nothing is totalized before polls close', () {
    final before = night.start.subtract(const Duration(minutes: 1));
    expect(statesPct(before), 0);
    expect(nationalPct(before), 0);
    expect(night.national(before).votes.values, everyElement(0));
  });

  test('every UF ends exactly at its real final file', () {
    for (final t in [night.end, night.end.add(const Duration(days: 1))]) {
      final byScope = {for (final r in night.states(t)) r.scope: r};
      for (final f in finals) {
        expect(byScope[f.scope]!.sectionsTotalized, f.sectionsTotalized);
        expect(byScope[f.scope]!.votes, f.votes, reason: f.scope);
      }
      expect(night.national(t).votes, finalSum.votes);
      expect(nationalPct(t), finalSum.sectionsTotalizedPct);
    }
  });

  test('counts never go down', () {
    var prev = night.states(minutes.first);
    for (final t in minutes.skip(1)) {
      final cur = night.states(t);
      for (var i = 0; i < cur.length; i++) {
        expect(
          cur[i].sectionsTotalized,
          greaterThanOrEqualTo(prev[i].sectionsTotalized),
        );
        cur[i].votes.forEach(
          (n, v) => expect(v, greaterThanOrEqualTo(prev[i].votes[n]!)),
        );
      }
      prev = cur;
    }
  });

  test('UFs progress at different speeds', () {
    final mid = brt(4, 20, 0);
    final pcts = night.states(mid).map((r) => r.sectionsTotalizedPct).toSet();
    expect(pcts.length, greaterThan(10));
  });

  group('the national freeze', () {
    test('the national file holds the states value at 21:02, about 64.81%', () {
      final frozen = nationalPct(night.freezeStart);
      expect(frozen, closeTo(64.81, 0.005));
      expect(frozen, statesPct(night.freezeStart));
      for (final t in minutes.where(
        (t) => !t.isBefore(night.freezeStart) && t.isBefore(night.freezeEnd),
      )) {
        expect(nationalPct(t), frozen);
        expect(
          night.national(t).votes,
          night.national(night.freezeStart).votes,
        );
      }
    });

    test('states keep moving while the national file is frozen', () {
      final late = night.freezeEnd.subtract(const Duration(minutes: 1));
      expect(statesPct(late) - nationalPct(late), greaterThan(10));
    });

    test('outside the freeze the national file equals the sum of states', () {
      for (final t in minutes.where(
        (t) => t.isBefore(night.freezeStart) || !t.isBefore(night.freezeEnd),
      )) {
        expect(nationalPct(t), statesPct(t));
        expect(night.national(t).votes, sumOfStates(night.states(t)).votes);
      }
    });

    test('divergence detection finds exactly the freeze', () {
      final events = detectDivergence([
        for (final t in minutes)
          Comparison(
            at: t,
            nationalPct: nationalPct(t),
            statesPct: statesPct(t),
          ),
      ]);
      expect(events, hasLength(1));
      expect(events.single.endedAt, night.freezeEnd);
      expect(
        events.single.startedAt.difference(night.freezeStart).inMinutes,
        lessThanOrEqualTo(2),
      );
    });
  });

  test('the same finals always build the same night', () {
    final t = brt(4, 20, 30);
    final a = build().states(t), b = night.states(t);
    for (var i = 0; i < a.length; i++) {
      expect(a[i].votes, b[i].votes);
    }
  });

  test('finals must cover every UF and exterior', () {
    expect(
      () => SyntheticNight(
        finals: finals.skip(1).toList(),
        start: night.start,
        end: night.end,
        freezeStart: night.freezeStart,
        freezeEnd: night.freezeEnd,
      ),
      throwsArgumentError,
    );
  });
}

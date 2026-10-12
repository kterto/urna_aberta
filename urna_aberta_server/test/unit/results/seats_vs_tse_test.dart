import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/results/ea20_result.dart';
import 'package:urna_aberta_server/src/results/seats.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

/// Our allocation against TSE's, seat by seat, on every archived
/// proportional race: 2026 deputies (54 files) and 2024 councils in the
/// 26 state capitals.
void main() {
  final files = [
    for (final root in [
      '../fixtures/2026-1t/oficial',
      '../fixtures/2024/oficial',
    ])
      ...Directory(root)
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (f) => RegExp(r'-c00(0[678]|13)-e\d+-u\.jws$').hasMatch(f.path),
          ),
  ];

  test('every proportional race is archived', () {
    expect(files, hasLength(54 + 26));
  });

  for (final f in files) {
    final name = f.path.split('/').last;
    test(name, () {
      final uf = RegExp(r'^([a-z]{2})\d{5}-').firstMatch(name)?[1];
      final r = parseOfficeResult(
        TseJws.parse(f.readAsStringSync()).payload,
        uf: uf,
      );
      final a = allocateSeats(r);

      expect(a.validVotes, r.totals.valid, reason: 'valid votes');
      expect(a.unfilled, 0);
      final diff = SeatComparison.of(r, a);
      expect(diff.quotient, diff.tseQuotient, reason: 'quociente eleitoral');
      expect(diff.lists, isEmpty, reason: 'seats per list');
      expect(diff.candidates, isEmpty, reason: 'who is elected, and how');
      expect(diff.matches, isTrue);
    });
  }
}

import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/results/ea20_result.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

/// Every archived result file, any office: it must parse and add up.
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
            (f) =>
                RegExp(r'-c00(0[35678]|1[13])-e\d+-u\.jws$').hasMatch(f.path),
          ),
  ];

  test('the archive holds every office', () {
    expect(files.length, greaterThanOrEqualTo(54 + 54 + 52));
  });

  for (final f in files) {
    final name = f.path.split('/').last;
    test(name, () {
      final uf = RegExp(r'^([a-z]{2})\d{5}-').firstMatch(name)?[1];
      final r = parseOfficeResult(
        TseJws.parse(f.readAsStringSync()).payload,
        uf: uf,
      );
      final parties = r.lists.expand((l) => l.parties);
      expect(parties.fold(0, (s, p) => s + p.nominalVotes), r.totals.nominal);
      expect(parties.fold(0, (s, p) => s + p.legendVotes), r.totals.legend);
      expect(r.totals.nominal + r.totals.legend, r.totals.valid);
      if (r.office.proportional) {
        expect(r.lists.fold(0, (s, l) => s + (l.seatsWon ?? 0)), r.seats);
        expect(r.candidates.where((c) => c.elected), hasLength(r.seats));
        expect(r.electoralQuotient, isNotNull);
      }
    });
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/tse/ea12.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

List<int> _payload(String path) => TseJws.parse(
  File('../fixtures/2024/oficial/$path').readAsStringSync(),
).payload;

void main() {
  final first = parseEa12(_payload('ele2024/619/config/mun-e000619-cm.jws'));

  test('every municipality of the 2024 1st round, by UF', () {
    expect(first.byUf.keys, hasLength(26));
    expect(first.byUf.keys, isNot(contains('df')));
    expect(first.all, hasLength(5569));
  });

  test('TSE code, IBGE code, name and capital flag', () {
    final sp = first.byCode('sp', 71072)!;
    expect(sp.name, 'SÃO PAULO');
    expect(sp.ibge, 3550308);
    expect(sp.capital, isTrue);
    expect(sp.zones, isNotEmpty);
    expect(first.all.where((m) => m.capital), hasLength(26));
    expect(first.byCode('sp', 99999), isNull);
  });

  test('the 2nd-round file lists only where there was one', () {
    final second = parseEa12(_payload('ele2024/620/config/mun-e000620-cm.jws'));
    expect(second.all.length, lessThan(200));
    expect(second.byCode('sp', 71072), isNotNull);
  });

  test('malformed input is refused', () {
    expect(() => parseEa12(utf8.encode('{}')), throwsFormatException);
    expect(() => parseEa12(utf8.encode('[')), throwsFormatException);
  });
}

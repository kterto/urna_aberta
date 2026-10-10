import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/resultados/resultados_controller.dart';

import 'fake_resultados_source.dart';

void main() {
  final now = DateTime.utc(2026, 10, 10, 15);
  late FakeResultadosSource source;
  late ResultadosController c;

  setUp(() {
    source = FakeResultadosSource();
    c = ResultadosController(source, now: () => now);
  });

  test('opens on the newest election held: Deputado Federal, SP', () async {
    await c.start();
    expect(c.election!.code, 6259);
    expect(c.office, 6);
    expect(c.uf, 'sp');
    expect(source.reportCalls, [(6259, 6, 'sp')]);
    expect(c.report!.seats, 3);
  });

  test(
    'one voting day is one choice; its offices span TSE\'s elections',
    () async {
      await c.start();
      expect(c.rounds.map((e) => e.day.year), [2026, 2026, 2024, 2024]);
      expect(c.offices, [1, 3, 5, 6, 7, 8]);
      await c.selectOffice(1);
      expect(c.election!.code, 6257);
      expect(c.scopes.first, 'br');
      expect(source.reportCalls.last, (6257, 1, 'br'));
      await c.selectOffice(5);
      expect(c.election!.code, 6259);
      expect(c.uf, 'sp');
    },
  );

  test('elections not held yet are listed but never chosen or asked', () async {
    await c.start();
    expect(c.elections.map((e) => e.code), contains(6260));
    expect(c.isHeld(c.elections.first), isFalse);
    await c.selectElection(c.elections.first);
    expect(c.report, isNull);
    expect(c.notHeldYet, isTrue);
    expect(source.reportCalls.where((r) => r.$1 == 6260), isEmpty);
  });

  test('each office offers only the scopes that elect it', () async {
    await c.start();
    expect(c.scopes, isNot(contains('zz')));
    await c.selectOffice(7);
    expect(c.scopes, isNot(contains('df')));
    await c.selectOffice(8);
    expect(c.scopes, ['df']);
    expect(c.uf, 'df');
    expect(source.reportCalls.last, (6259, 8, 'df'));
    await c.selectElection(sampleElections.singleWhere((e) => e.code == 6257));
    expect(c.office, 1);
    expect(c.scopes.first, 'br');
    expect(c.scopes, contains('zz'));
  });

  test('Deputado Federal for Brazil is the Câmara: 27 states summed', () async {
    await c.start();
    expect(c.scopes.first, 'br');
    await c.selectUf('br');
    expect(source.camaraCalls, [6259]);
    expect(c.report, isNull);
    expect(c.chamber!.seats, 513);
    await c.selectUf('rj');
    expect(c.chamber, isNull);
    expect(c.report!.scopeCode, 'rj');
  });

  test('a municipal election asks for a municipality first', () async {
    await c.start();
    await c.selectElection(sampleElections.singleWhere((e) => e.code == 619));
    expect(c.office, 11);
    expect(c.uf, 'sp');
    expect(source.municipioCalls.last, (619, 'sp'));
    expect(c.municipios.map((m) => m.nome), ['CAMPINAS', 'SÃO PAULO']);
    expect(c.report, isNull);
    await c.selectMunicipio(c.municipios.last);
    expect(source.reportCalls.last, (619, 11, 'sp71072'));
    expect(c.report!.proportional, isFalse);
    // Switching office keeps the municipality.
    await c.selectOffice(13);
    expect(source.reportCalls.last, (619, 13, 'sp71072'));
  });

  test('a 2nd round lists only the municipalities it covers', () async {
    await c.start();
    await c.selectElection(sampleElections.singleWhere((e) => e.code == 620));
    expect(c.municipios.map((m) => m.codigo), [71072]);
  });

  test('a server refusal is kept as the error, not a report', () async {
    source.failWith = ResultUnavailable(
      message: 'O TSE não publicou este arquivo.',
      reason: 'notPublished',
    );
    await c.start();
    expect(c.report, isNull);
    expect(c.error, isA<ResultUnavailable>());
  });

  test('search filters candidates by name, number or party', () async {
    await c.start();
    expect(c.candidates, hasLength(4));
    c.search('joao');
    expect(c.candidates.map((x) => x.ballotName), ['JOÃO SOUZA']);
    c.search('2222');
    expect(c.candidates.map((x) => x.ballotName), ['BRUNO DIAS']);
    c.search('p3');
    expect(c.candidates, hasLength(2));
    c.search('');
    expect(c.candidates, hasLength(4));
  });

  test('an answer for an older choice is dropped', () async {
    await c.start();
    source.gate = Completer<void>();
    final slow = c.selectUf('rj');
    final fast = c.selectUf('mg');
    source.gate!.complete();
    await Future.wait([slow, fast]);
    expect(c.uf, 'mg');
    expect(c.report!.scopeCode, 'mg');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/secao/secao_controller.dart';

import 'fake_secao_source.dart';

void main() {
  late FakeSecaoSource source;
  late SecaoController c;

  setUp(() {
    source = FakeSecaoSource();
    c = SecaoController(source);
  });

  Future<void> pickPortoWalter77() async {
    await c.selectUf('ac');
    await c.selectMunicipio(c.municipios.singleWhere((m) => m.codigo == 1066));
    await c.selectZona(4);
    c.selectSecao(77);
  }

  test('each choice loads the next list', () async {
    await c.selectUf('ac');
    expect(c.municipios.map((m) => m.nome), contains('PORTO WALTER'));
    await c.selectMunicipio(c.municipios.singleWhere((m) => m.codigo == 1066));
    expect(c.zonas, [4]);
    await c.selectZona(4);
    expect(c.secoes, [77, 78]);
    expect(c.canConsult, isFalse);
    c.selectSecao(77);
    expect(c.canConsult, isTrue);
  });

  test('changing the UF clears everything below it', () async {
    await pickPortoWalter77();
    await c.consultar();
    await c.selectUf('sp');
    expect([c.municipio, c.zona, c.secao, c.report], [null, null, null, null]);
    expect(c.zonas, isEmpty);
    expect(c.secoes, isEmpty);
  });

  test('consult returns the report', () async {
    await pickPortoWalter77();
    await c.consultar();
    expect(c.report!.secao, 77);
    expect(c.error, isNull);
    expect(source.consults, [('ac', 1066, 4, 77)]);
  });

  test('a server error is kept for the screen and cleared on retry', () async {
    await pickPortoWalter77();
    source.fail = SectionUnavailableException(message: 'TSE fora');
    await c.consultar();
    expect(c.error, isA<SectionUnavailableException>());
    expect(c.report, isNull);
    source.fail = null;
    await c.consultar();
    expect(c.error, isNull);
    expect(c.report, isNotNull);
  });

  test('a slow list for an old UF never replaces the current one', () async {
    source.hold = true;
    final first = c.selectUf('ac');
    final second = c.selectUf('sp');
    source.release('sp');
    await second;
    source.release('ac');
    await first;
    expect(c.uf, 'sp');
    expect(c.municipios.single.nome, 'SÃO PAULO');
  });

  test('shows which list is loading until it arrives', () async {
    source.hold = true;
    final pending = c.selectUf('ac');
    expect(c.loading, SecaoLoad.municipios);
    source.release('ac');
    await pending;
    expect(c.loading, isNull);
  });

  test('a superseded load does not keep the new one marked loading', () async {
    source.hold = true;
    final first = c.selectUf('ac');
    final second = c.selectUf('sp');
    source.release('ac');
    await first;
    expect(c.loading, SecaoLoad.municipios);
    source.release('sp');
    await second;
    expect(c.loading, isNull);
  });

  group('CachedSecaoSource', () {
    late CachedSecaoSource cached;
    setUp(() => cached = CachedSecaoSource(source));

    test('asks the server once per list', () async {
      await cached.municipios('ac');
      await cached.municipios('ac');
      await cached.zonas('ac', 1066);
      await cached.zonas('ac', 1066);
      await cached.secoes('ac', 1066, 4);
      await cached.secoes('ac', 1066, 4);
      await cached.municipios('sp');
      expect(source.listCalls, [
        'municipios ac',
        'zonas ac 1066',
        'secoes ac 1066 4',
        'municipios sp',
      ]);
    });

    test('a failed list is asked again next time', () async {
      source.failLists = StateError('offline');
      await expectLater(cached.municipios('ac'), throwsStateError);
      source.failLists = null;
      expect(await cached.municipios('ac'), hasLength(2));
      expect(source.listCalls, ['municipios ac', 'municipios ac']);
    });

    test('the report is never cached: the server decides freshness', () async {
      await cached.consultar('ac', 1066, 4, 77);
      await cached.consultar('ac', 1066, 4, 77);
      expect(source.consults, hasLength(2));
    });
  });

  group('openAt (the saved place)', () {
    test('a full section opens and is consulted', () async {
      await c.openAt('ac', 1066, 4, 77);
      expect(
        [c.uf, c.municipio?.nome, c.zona, c.secao],
        [
          'ac',
          'PORTO WALTER',
          4,
          77,
        ],
      );
      expect(c.report!.aptos, 289);
    });

    test('a municipality alone stops there', () async {
      await c.openAt('ac', 1066, null, null);
      expect(c.municipio?.nome, 'PORTO WALTER');
      expect(c.zonas, [4]);
      expect([c.zona, c.report], [null, null]);
    });

    test('a place no longer listed stops at what is', () async {
      await c.openAt('ac', 1066, 4, 9999);
      expect(c.zona, 4);
      expect([c.secao, c.report], [null, null]);
    });

    test('a choice made meanwhile wins', () async {
      final opening = c.openAt('ac', 1066, 4, 77);
      await c.selectUf('sp');
      await opening;
      expect(c.uf, 'sp');
      expect(c.report, isNull);
    });
  });
}

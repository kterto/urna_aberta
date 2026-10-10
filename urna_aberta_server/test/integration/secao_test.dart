import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/replay/fixture_seeder.dart';
import 'package:urna_aberta_server/src/secao/secao_endpoint.dart';
import 'package:urna_aberta_server/src/secao/section_directory.dart';
import 'package:urna_aberta_server/src/secao/section_service.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

import 'test_tools/serverpod_test_tools.dart';

const _fixtures = '../fixtures/2026-1t';

/// Serves archived files by URL path; anything else is a 404.
class FixtureTse implements TseHttp {
  final requested = <String>[];
  final overrides = <String, List<int>>{};
  int? failWith;

  @override
  Future<TseHttpResponse> get(Uri uri, Map<String, String> headers) async {
    requested.add(uri.path);
    if (failWith != null) return TseHttpResponse(failWith!, const [], const {});
    final override = overrides.entries
        .where((e) => uri.path.endsWith(e.key))
        .firstOrNull;
    if (override != null) {
      return TseHttpResponse(200, override.value, const {});
    }
    final f = File('$_fixtures${uri.path}');
    if (!f.existsSync()) return TseHttpResponse(404, const [], const {});
    return TseHttpResponse(200, f.readAsBytesSync(), const {});
  }
}

class _NoWait extends TokenBucket {
  _NoWait() : super(ratePerSecond: 20, burst: 1);

  @override
  Future<void> acquire() async {}
}

Future<SectionDirectory> fixtureDirectory(
  String uf,
) async => parseSectionConfig(
  File(
    '$_fixtures/oficial/ele2026/arquivo-urna/3220/config/$uf/$uf-p003220-cs.json',
  ).readAsBytesSync(),
);

void main() {
  late FixtureTse tse;

  setUp(() {
    tse = FixtureTse();
    SecaoEndpoint.service = SectionService(
      client: TseClient(http: tse, bucket: _NoWait()),
      urls: TseUrls.oficial(),
      directory: fixtureDirectory,
      now: () => DateTime.utc(2026, 10, 10, 12),
    );
  });

  withServerpod('secao endpoint', (sessionBuilder, endpoints) {
    late final session = sessionBuilder.build();
    final secao = endpoints.secao;

    Future<SectionReport> porto77() =>
        secao.consultar(sessionBuilder, 'ac', 1066, 4, 77);

    test(
      'pickers come from the section config, without TSE requests',
      () async {
        final mun = await secao.municipios(sessionBuilder, 'AC');
        expect(mun.map((m) => m.nome), contains('PORTO WALTER'));
        expect(await secao.zonas(sessionBuilder, 'ac', 1066), contains(4));
        expect(await secao.secoes(sessionBuilder, 'ac', 1066, 4), contains(77));
        expect(tse.requested, isEmpty);
      },
    );

    test('a section TSE does not list is refused without a request', () async {
      await expectLater(
        secao.consultar(sessionBuilder, 'ac', 1066, 4, 9999),
        throwsA(isA<SectionNotFoundException>()),
      );
      expect(tse.requested, isEmpty);
    });

    test(
      'reads the official BU, checks it, and names the candidates',
      () async {
        await FixtureSeeder.seed(session, Directory(_fixtures));
        final r = await porto77();
        expect(r.status, 'Totalizada');
        expect(r.municipioNome, 'PORTO WALTER');
        expect(r.receivedAt, DateTime.utc(2026, 10, 4, 21, 34, 8));
        expect(r.emitidoEm, '2026-10-04T15:44:09');
        expect([r.aptos, r.comparecimento, r.local], [289, 234, 1031]);
        expect(r.buCheck, BuCheck.matches);
        expect(r.signatureVerified, isFalse);

        final presidente = r.cargos.singleWhere((c) => c.codigo == 1);
        final v22 = presidente.votos.singleWhere((v) => v.numero == 22);
        expect(v22.votos, 103);
        expect(v22.nome, 'FLAVIO BOLSONARO');
        expect(
          r.cargos.singleWhere((c) => c.codigo == 3).votos.first.nome,
          isNotNull,
        );

        expect(r.files.map((f) => f.kind), ['aux', 'bu', 'vota']);
        expect(r.files.every((f) => f.sha256.length == 64), isTrue);
        expect(r.files[1].url, endsWith('/o03220ac0106600040077-bu.dat'));
        expect(tse.requested, hasLength(3));
      },
    );

    test('a second lookup is served from the stored files', () async {
      await porto77();
      tse.requested.clear();
      final again = await porto77();
      expect(again.buCheck, BuCheck.matches);
      expect(again.cargos, isNotEmpty);
      expect(tse.requested, isEmpty);
      expect(await SectionCheck.db.count(session), 1);
      expect(await SectionFile.db.count(session), 3);
    });

    test('a BU that differs from the urna list shows no votes', () async {
      final bu = File(
        '$_fixtures/oficial/ele2026/arquivo-urna/3220/dados/ac/01066/0004/0077/'
        '4a6b704a7350756e6a5a496433337049453538516932486a676159553779785542752d6d765749354f41343d/'
        'o03220ac0106600040077-bu.dat',
      ).readAsBytesSync();
      tse.overrides['-bu.dat'] = Uint8List.fromList(bu)..[8000] ^= 1;
      final r = await porto77();
      expect(r.buCheck, BuCheck.differs);
      expect(r.cargos, isEmpty);
    });

    test(
      'when TSE refuses, nothing is stored and the caller is told',
      () async {
        tse.failWith = 503;
        await expectLater(
          porto77(),
          throwsA(isA<SectionUnavailableException>()),
        );
        expect(await SectionCheck.db.count(session), 0);
      },
    );
  });
}

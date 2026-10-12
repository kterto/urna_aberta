import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/meu_local/meu_local_endpoint.dart';
import 'package:urna_aberta_server/src/secao/section_service.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

import 'secao_test.dart' show FixtureTse, fixtureDirectory;
import 'test_tools/serverpod_test_tools.dart';

void main() {
  late FixtureTse tse;

  setUp(() {
    tse = FixtureTse();
    MeuLocalEndpoint.sections = SectionService(
      client: TseClient(
        http: tse,
        bucket: TokenBucket(ratePerSecond: 20, burst: 1),
      ),
      urls: TseUrls.oficial(),
      directory: fixtureDirectory,
    );
  });

  withServerpod('meu local endpoint', (sessionBuilder, endpoints) {
    final meuLocal = endpoints.meuLocal;
    late TestSessionBuilder ana;
    late TestSessionBuilder bia;

    Future<TestSessionBuilder> signedIn() async {
      final user = await AuthUser.db.insertRow(
        sessionBuilder.build(),
        AuthUser(scopeNames: {}),
      );
      return sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id!.uuid,
          {},
        ),
      );
    }

    setUp(() async {
      ana = await signedIn();
      bia = await signedIn();
    });

    test('needs a signed-in viewer', () async {
      await expectLater(
        meuLocal.ler(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('nothing is saved until the viewer saves it', () async {
      expect(await meuLocal.ler(ana), isNull);
    });

    test('saves a section TSE lists, with the municipality name', () async {
      final saved = await meuLocal.salvar(ana, 'AC', 1066, 4, 77);
      expect(
        [saved.uf, saved.municipio, saved.municipioNome, saved.zona],
        ['ac', 1066, 'PORTO WALTER', 4],
      );
      expect(saved.secao, 77);
      expect((await meuLocal.ler(ana))!.secao, 77);
      expect(tse.requested, isEmpty);
    });

    test('a municipality alone is enough', () async {
      final saved = await meuLocal.salvar(ana, 'ac', 1066, null, null);
      expect([saved.zona, saved.secao], [null, null]);
    });

    test('saving again replaces the place', () async {
      await meuLocal.salvar(ana, 'ac', 1066, 4, 77);
      await meuLocal.salvar(ana, 'ac', 1066, null, null);
      final place = await meuLocal.ler(ana);
      expect(place!.secao, isNull);
      expect(await VoterPlace.db.count(sessionBuilder.build()), 1);
    });

    test('each viewer sees only their own place', () async {
      await meuLocal.salvar(ana, 'ac', 1066, 4, 77);
      expect(await meuLocal.ler(bia), isNull);
    });

    for (final (what, zona, secao) in [
      ('a section TSE does not list', 4, 9999),
      ('a zone TSE does not list', 999, null),
      ('a section without its zone', null, 77),
    ]) {
      test('refuses $what', () async {
        await expectLater(
          meuLocal.salvar(ana, 'ac', 1066, zona, secao),
          throwsA(isA<SectionNotFoundException>()),
        );
        expect(await meuLocal.ler(ana), isNull);
      });
    }

    test('refuses a municipality TSE does not list', () async {
      await expectLater(
        meuLocal.salvar(ana, 'ac', 99999, null, null),
        throwsA(isA<SectionNotFoundException>()),
      );
    });

    test('the viewer can delete it', () async {
      await meuLocal.salvar(ana, 'ac', 1066, 4, 77);
      await meuLocal.apagar(ana);
      expect(await meuLocal.ler(ana), isNull);
    });

    test('deleting the account deletes the place', () async {
      await meuLocal.salvar(ana, 'ac', 1066, 4, 77);
      final session = sessionBuilder.build();
      await AuthUser.db.deleteWhere(
        session,
        where: (t) => t.id.notEquals(null),
      );
      expect(await VoterPlace.db.count(session), 0);
    });
  });
}

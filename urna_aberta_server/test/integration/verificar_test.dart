import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/generated/protocol.dart';
import 'package:urna_aberta_server/src/replay/fixture_seeder.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

import 'test_tools/serverpod_test_tools.dart';

final _fixtures = Directory('../fixtures/2026-1t');

void main() {
  withServerpod('verificar endpoint', (sessionBuilder, endpoints) {
    late final session = sessionBuilder.build();
    final verificar = endpoints.verificar;

    setUp(() => FixtureSeeder.seed(session, _fixtures));

    test('lists every stored result file, Brazil first, all signed', () async {
      final files = await verificar.arquivos(sessionBuilder);
      expect(files, hasLength(83));
      final br = files.first;
      expect(br.scopeCode, 'br');
      expect(br.fileName, 'br-c0001-e006257-u.jws');
      expect(
        br.url,
        'https://resultados.tse.jus.br/oficial/ele2026/6257/dados/br/br-c0001-e006257-u.jws',
      );
      expect(br.kid, 'sNbt9Q_fLS65zE1_ZLNV-XRRwPY');
      expect(files.map((f) => f.signature).toSet(), {SignatureStatus.valid});
      expect(
        files.map((f) => f.officeCode).toList(),
        orderedEquals([
          ...List.filled(29, 1),
          ...List.filled(27, 3),
          ...List.filled(27, 5),
        ]),
      );
    });

    test('hands out the stored JWS so anyone can check it again', () async {
      final br = (await verificar.arquivos(sessionBuilder)).first;
      final compact = await verificar.jws(sessionBuilder, br.snapshotId);
      expect(await checkJws(TseJws.parse(compact)), JwsCheck.valid);
    });

    test('an unknown file is refused', () async {
      await expectLater(
        verificar.jws(sessionBuilder, 999999),
        throwsA(isA<FileNotStoredException>()),
      );
    });
  });
}

import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/verificar/verificar_controller.dart';

const _dados = '../fixtures/2026-1t/oficial/ele2026/6257/dados';

String fixtureJws(String scope) =>
    File('$_dados/$scope/$scope-c0001-e006257-u.jws').readAsStringSync();

FileVerification fileFor(int id, String scope, {SignatureStatus? signature}) {
  final json = File('$_dados/$scope/$scope-c0001-e006257-u.json');
  return FileVerification(
    snapshotId: id,
    origin: DataOrigin.replay,
    electionCode: 6257,
    officeCode: 1,
    scopeCode: scope,
    fileName: '$scope-c0001-e006257-u.jws',
    url:
        'https://resultados.tse.jus.br/oficial/ele2026/6257/dados/$scope/$scope-c0001-e006257-u.jws',
    tseGeneratedAt: DateTime.utc(2026, 10, 5, 15, 51, 5),
    sha256: sha256.convert(json.readAsBytesSync()).toString(),
    signature: signature ?? SignatureStatus.valid,
    kid: 'sNbt9Q_fLS65zE1_ZLNV-XRRwPY',
  );
}

/// Brazil and Acre as stored; snapshot 3 claims to be São Paulo but hands
/// out Acre's signed file.
class FakeVerificarSource implements VerificarSource {
  Object? fail;
  final jwsCalls = <int>[];

  @override
  Future<List<FileVerification>> arquivos() async {
    if (fail != null) throw fail!;
    return [fileFor(1, 'br'), fileFor(2, 'ac'), fileFor(3, 'sp')];
  }

  @override
  Future<String> jws(int snapshotId) async {
    jwsCalls.add(snapshotId);
    return fixtureJws(switch (snapshotId) {
      1 => 'br',
      _ => 'ac',
    });
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_flutter/verificar/device_check.dart';

const _br =
    '../fixtures/2026-1t/oficial/ele2026/6257/dados/br/br-c0001-e006257-u';

void main() {
  late String compact;
  late String sha;

  setUpAll(() {
    compact = File('$_br.jws').readAsStringSync();
    sha = sha256.convert(File('$_br.json').readAsBytesSync()).toString();
  });

  test('a real TSE file checks out on the device', () async {
    expect(
      await checkOnDevice(compact, expectedSha256: sha),
      DeviceCheck.valid,
    );
  });

  test('a changed signature fails', () async {
    final p = compact.trim().split('.');
    final sig = base64Url.decode(base64Url.normalize(p[2]))..[0] ^= 1;
    final forged =
        '${p[0]}.${p[1]}.${base64Url.encode(sig).replaceAll('=', '')}';
    expect(
      await checkOnDevice(forged, expectedSha256: sha),
      DeviceCheck.invalid,
    );
  });

  test(
    'a signed file other than the one the server described is caught',
    () async {
      expect(
        await checkOnDevice(compact, expectedSha256: '0' * 64),
        DeviceCheck.differentFile,
      );
    },
  );

  test('a key the app does not carry is reported', () async {
    final p = compact.trim().split('.');
    final header = base64Url
        .encode(utf8.encode('{"kid":"outra","alg":"EdDSA"}'))
        .replaceAll('=', '');
    expect(
      await checkOnDevice('$header.${p[1]}.${p[2]}', expectedSha256: sha),
      DeviceCheck.unknownKey,
    );
  });

  test('garbage is unreadable, not valid', () async {
    expect(
      await checkOnDevice('a.b', expectedSha256: sha),
      DeviceCheck.unreadable,
    );
  });
}

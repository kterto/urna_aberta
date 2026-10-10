import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

/// Real 1st-round files and their signatures, archived in `fixtures/2026-1t`.
const _dir = '../fixtures/2026-1t/oficial/ele2026/6257/dados/br';
const _name = 'br-c0001-e006257-u';

String _b64(List<int> b) => base64Url.encode(b).replaceAll('=', '');

void main() {
  late String compact;
  late List<int> json;

  setUpAll(() {
    compact = File('$_dir/$_name.jws').readAsStringSync();
    json = File('$_dir/$_name.json').readAsBytesSync();
  });

  test('reads the header and payload of a TSE file', () {
    final jws = TseJws.parse(compact);
    expect(jws.kid, 'sNbt9Q_fLS65zE1_ZLNV-XRRwPY');
    expect(jws.alg, 'EdDSA');
    expect(jws.payload, json);
  });

  test('a TSE file verifies with the official key', () async {
    expect(await checkJws(TseJws.parse(compact)), JwsCheck.valid);
  });

  test('one changed byte in the signature fails', () async {
    final parts = compact.trim().split('.');
    final sig = base64Url.decode(base64Url.normalize(parts[2]));
    sig[10] ^= 0x01;
    final forged = '${parts[0]}.${parts[1]}.${_b64(sig)}';
    expect(await checkJws(TseJws.parse(forged)), JwsCheck.invalid);
  });

  test('a changed vote count in the payload fails', () async {
    final parts = compact.trim().split('.');
    final text = utf8.decode(json);
    final vap = RegExp(r'"vap" : "(\d+)"').firstMatch(text)!;
    final altered = text.replaceFirst(
      vap.group(0)!,
      '"vap" : "${int.parse(vap.group(1)!) + 1}"',
    );
    final forged = '${parts[0]}.${_b64(utf8.encode(altered))}.${parts[2]}';
    expect(await checkJws(TseJws.parse(forged)), JwsCheck.invalid);
  });

  test('a key id the app does not know is reported, not trusted', () async {
    final parts = compact.trim().split('.');
    final header = _b64(
      utf8.encode('{"kid":"outra-chave","typ":"JOSE","alg":"EdDSA"}'),
    );
    final other = '$header.${parts[1]}.${parts[2]}';
    expect(await checkJws(TseJws.parse(other)), JwsCheck.unknownKey);
  });

  test('refuses anything but EdDSA, and malformed input', () {
    final parts = compact.trim().split('.');
    final none = _b64(utf8.encode('{"kid":"x","alg":"none"}'));
    expect(
      () => TseJws.parse('$none.${parts[1]}.'),
      throwsFormatException,
    );
    expect(() => TseJws.parse('a.b'), throwsFormatException);
    expect(() => TseJws.parse('!!.??.**'), throwsFormatException);
  });

  test(
    'every archived signed file verifies; its .json, if kept, matches',
    () async {
      final signed = [
        for (final root in [
          '../fixtures/2026-1t/oficial',
          '../fixtures/2024/oficial',
        ])
          ...Directory(root)
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.jws')),
      ];
      // 83 President/Governor/Senator, 54 deputies, 67 municipal, 2 EA12.
      expect(signed, hasLength(206));
      for (final f in signed) {
        final jws = TseJws.parse(f.readAsStringSync());
        final plain = File(f.path.replaceFirst(RegExp(r'\.jws$'), '.json'));
        if (plain.existsSync()) {
          expect(jws.payload, plain.readAsBytesSync(), reason: f.path);
        }
        expect(await checkJws(jws), JwsCheck.valid, reason: f.path);
      }
    },
  );
}

import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/secao/urna_certificate.dart';

import 'urna_fixture.dart';

void main() {
  test('reads subject, issuer key id and the 66-byte Ed521 key', () {
    expect(urnaCertificate.subject, 'UEAO02293919');
    expect(urnaCertificate.issuer, 'AC UE2022');
    expect(urnaCertificate.isEd521, isTrue);
    expect(urnaCertificate.publicKey, hasLength(66));
  });

  test('AC UE2022, pinned in code, signed the urna certificate', () {
    expect(urnaCertificate.issuedByTse(), isTrue);
  });

  test('a certificate changed after issue is not trusted', () {
    final der = Uint8List.fromList(urnaCertificate.der);
    // A byte inside the subject name, part of the signed TBS.
    final at = _indexOf(der, 'UEAO02293919'.codeUnits);
    der[at] ^= 1;
    expect(UrnaCertificate.parse(der).issuedByTse(), isFalse);
  });
}

int _indexOf(List<int> h, List<int> n) {
  for (var i = 0; i <= h.length - n.length; i++) {
    var ok = true;
    for (var j = 0; j < n.length && ok; j++) {
      ok = h[i + j] == n[j];
    }
    if (ok) return i;
  }
  throw StateError('not found');
}

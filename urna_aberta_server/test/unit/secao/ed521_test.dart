import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:test/test.dart';
import 'package:urna_aberta_server/src/secao/ed521.dart';

import 'urna_fixture.dart';

void main() {
  final hw = urnaHardwareBlock();
  final message = sha512.convert(hw.signedHash).bytes;

  test('the curve base point has the published order', () {
    expect(Ed521.basePointHasOrderL(), isTrue);
  });

  test("the fixture urna's signature verifies with its own key", () {
    expect(
      Ed521.verify(
        publicKey: urnaPublicKey,
        message: message,
        signature: hw.signature,
      ),
      isTrue,
    );
  });

  test('one changed byte in the signature or the message fails', () {
    final sig = Uint8List.fromList(hw.signature)..[10] ^= 1;
    expect(
      Ed521.verify(publicKey: urnaPublicKey, message: message, signature: sig),
      isFalse,
    );
    final msg = Uint8List.fromList(message)..[0] ^= 1;
    expect(
      Ed521.verify(
        publicKey: urnaPublicKey,
        message: msg,
        signature: hw.signature,
      ),
      isFalse,
    );
  });

  test('malformed keys and signatures are rejected, not thrown', () {
    expect(
      Ed521.verify(
        publicKey: [1, 2, 3],
        message: message,
        signature: hw.signature,
      ),
      isFalse,
    );
    expect(
      Ed521.verify(publicKey: urnaPublicKey, message: message, signature: [0]),
      isFalse,
    );
  });
}

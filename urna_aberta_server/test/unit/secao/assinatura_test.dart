import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/secao/assinatura.dart';

const _dir =
    '../fixtures/2026-1t/oficial/ele2026/arquivo-urna/3220/dados/ac/01066/0004/0077/'
    '4a6b704a7350756e6a5a496433337049453538516932486a676159553779785542752d6d765749354f41343d';
const _buName = 'o03220ac0106600040077-bu.dat';
final _vsc = File('$_dir/o03220ac0106600040077-vota.vsc').readAsBytesSync();
final _bu = File('$_dir/$_buName').readAsBytesSync();

void main() {
  final sig = decodeAssinaturas(_vsc);

  test('software and hardware blocks, SHA-512 listings', () {
    expect(sig.blocks.map((b) => b.kind), ['software', 'hardware']);
    final hw = sig.hardware;
    expect(hw.hashAlgorithm, 'sha512');
    expect(hw.signatureAlgorithm, 'eddsa');
    expect(hw.signatureBits, 521);
    expect(hw.hasCertificate, isTrue);
    expect(hw.signer, 'UEAO');
    expect(hw.fileHashes.keys, contains(_buName));
    expect(hw.fileHashes[_buName], hasLength(64));
  });

  test('both listings match the hash the urna signed', () {
    expect(sig.blocks.every((b) => b.listingIntact), isTrue);
  });

  test('the archived BU is the file the urna listed', () {
    expect(sig.check(_buName, _bu), FileCheck.matches);
  });

  test('one changed byte in the BU is caught', () {
    final changed = Uint8List.fromList(_bu)..[100] ^= 1;
    expect(sig.check(_buName, changed), FileCheck.differs);
  });

  test('a file the urna never listed', () {
    expect(sig.check('o03220ac0106600040077-xx.dat', _bu), FileCheck.notListed);
  });

  test('a listing edited after signing is reported, not trusted', () {
    // Flip one byte of the BU's listed hash inside the hardware block.
    final listed = sig.hardware.fileHashes[_buName]!;
    final edited = Uint8List.fromList(_vsc);
    final at = _lastIndexOf(edited, listed);
    expect(at, greaterThan(0));
    edited[at] ^= 1;
    final s = decodeAssinaturas(edited);
    expect(s.hardware.listingIntact, isFalse);
    expect(s.check(_buName, _bu), FileCheck.listingAltered);
  });

  test('bytes that are not a signature file are refused', () {
    expect(() => decodeAssinaturas(_bu), throwsFormatException);
    expect(() => decodeAssinaturas([0x30, 0x00]), throwsFormatException);
  });
}

int _lastIndexOf(List<int> h, List<int> n) {
  for (var i = h.length - n.length; i >= 0; i--) {
    var ok = true;
    for (var j = 0; j < n.length && ok; j++) {
      ok = h[i + j] == n[j];
    }
    if (ok) return i;
  }
  return -1;
}

/// EdDSA on curve E-521 ("Ed521"), the scheme TSE's UE2020/UE2022 urnas use
/// to sign their files (OID 1.3.6.1.4.1.44588.2.1).
///
/// Follows RFC 8032's EdDSA with TSE's parameters, as in the verification
/// code of TSE's "Manual do QR Code no Boletim de Urna" (ECPy `Ed521`):
/// a = 1, d = -376014, p = 2^521 - 1, SHAKE256 with 132-byte output and the
/// prefix `SigEd521\0\0`, 66-byte little-endian point encoding.
library;

import 'dart:typed_data';

import 'package:pointycastle/digests/shake.dart';

abstract final class Ed521 {
  static final _p = (BigInt.one << 521) - BigInt.one;
  static final _d = BigInt.from(-376014) % _p;
  static final _l =
      (BigInt.one << 519) -
      BigInt.parse(
        '337554763258501705789107630418782636071904961214051226618635150085779108655765',
      );
  static final _base = _Point(
    BigInt.parse(
      '752cb45c48648b189df90cb2296b2878a3bfd9f42fc6c818ec8bf3c9c0c6203913f6ecc5'
      'ccc72434b1ae949d568fc99c6059d0fb13364838aa302a940a2f19ba6c',
      radix: 16,
    ),
    BigInt.from(12),
    BigInt.one,
  );
  static final _dom = Uint8List.fromList('SigEd521\x00\x00'.codeUnits);

  /// Whether [signature] (R ‖ S, 132 bytes) by [publicKey] (66 bytes) covers
  /// [message]. Malformed input is simply not a valid signature.
  static bool verify({
    required List<int> publicKey,
    required List<int> message,
    required List<int> signature,
  }) {
    if (publicKey.length != 66 || signature.length != 132) return false;
    final rBytes = signature.sublist(0, 66);
    final a = _decode(publicKey), r = _decode(rBytes);
    if (a == null || r == null) return false;
    final s = _le(signature.sublist(66));
    if (s >= _l) return false;
    final h = _le(_shake([..._dom, ...rBytes, ...publicKey, ...message])) % _l;
    return _mul(s, _base).sameAs(_add(r, _mul(h, a)));
  }

  /// Sanity check of the constants: [L]·B is the neutral element.
  static bool basePointHasOrderL() => _mul(_l, _base).isNeutral;

  static BigInt _le(List<int> b) {
    var v = BigInt.zero;
    for (var i = b.length - 1; i >= 0; i--) {
      v = (v << 8) | BigInt.from(b[i]);
    }
    return v;
  }

  static _Point? _decode(List<int> b) {
    final v = _le(b);
    final sign = (v >> 527) & BigInt.one;
    final y = v & _p;
    if (y >= _p) return null;
    final yy = y * y % _p;
    final x2 =
        (yy - BigInt.one) * ((_d * yy - BigInt.one) % _p).modInverse(_p) % _p;
    var x = x2.modPow((_p + BigInt.one) >> 2, _p);
    if ((x * x - x2) % _p != BigInt.zero) return null;
    if (x == BigInt.zero && sign == BigInt.one) return null;
    if ((x & BigInt.one) != sign) x = _p - x;
    return _Point(x, y, BigInt.one);
  }

  static List<int> _shake(List<int> data) {
    final digest = SHAKEDigest(256)
      ..update(Uint8List.fromList(data), 0, data.length);
    final out = Uint8List(132);
    digest.doFinalRange(out, 0, out.length);
    return out;
  }

  // Projective coordinates on a = 1 twisted Edwards (add-2008-bbjlp).
  static _Point _add(_Point a, _Point b) {
    final p = _p;
    final aa = a.z * b.z % p;
    final bb = aa * aa % p;
    final c = a.x * b.x % p;
    final dd = a.y * b.y % p;
    final e = _d * c % p * dd % p;
    final f = (bb - e) % p;
    final g = (bb + e) % p;
    return _Point(
      aa * f % p * (((a.x + a.y) * (b.x + b.y) - c - dd) % p) % p,
      aa * g % p * ((dd - c) % p) % p,
      f * g % p,
    );
  }

  static _Point _mul(BigInt k, _Point point) {
    var r = _Point(BigInt.zero, BigInt.one, BigInt.one);
    var q = point;
    for (var i = 0; i < k.bitLength; i++) {
      if ((k >> i) & BigInt.one == BigInt.one) r = _add(r, q);
      q = _add(q, q);
    }
    return r;
  }
}

class _Point {
  _Point(this.x, this.y, this.z);

  final BigInt x, y, z;

  bool get isNeutral =>
      x % Ed521._p == BigInt.zero && (y - z) % Ed521._p == BigInt.zero;

  bool sameAs(_Point o) =>
      (x * o.z - o.x * z) % Ed521._p == BigInt.zero &&
      (y * o.z - o.y * z) % Ed521._p == BigInt.zero;
}

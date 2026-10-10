import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:cryptography/dart.dart';
import 'package:cryptography/cryptography.dart';

/// TSE's signing key for published result files, carried by the app itself
/// so the check below does not depend on the Urna Aberta server.
///
/// Source: TSE, "Manual de verificação dos arquivos JWS", Apêndice B
/// (ambiente oficial). Same key as the server's `verify/jws.dart`.
const tseKeyId = 'sNbt9Q_fLS65zE1_ZLNV-XRRwPY';
const tsePublicKey = 'kWlpNHjuws1csyQZwzn3Fhzbi3RD435RbpThtSr4hMc';

enum DeviceCheck {
  /// Signed by TSE's key, and it is the file the server described.
  valid,

  /// The signature does not match the file.
  invalid,

  /// Correctly signed, but not the file the server said it used.
  differentFile,

  /// Signed with a key id this app does not carry.
  unknownKey,

  /// Not a JWS this app can read.
  unreadable,
}

/// Checks a TSE `.jws` with the pinned key, using the pure-Dart Ed25519 so
/// the result is the same in every browser and on every device.
/// [expectedSha256] is the hash the server reported for the file.
Future<DeviceCheck> checkOnDevice(
  String compact, {
  required String expectedSha256,
}) async {
  final parts = compact.trim().split('.');
  if (parts.length != 3) return DeviceCheck.unreadable;
  final Object? header;
  final List<int> payload, sig;
  try {
    header = jsonDecode(utf8.decode(_decode(parts[0])));
    payload = _decode(parts[1]);
    sig = _decode(parts[2]);
  } on FormatException {
    return DeviceCheck.unreadable;
  }
  if (header case {'kid': final String kid, 'alg': 'EdDSA'}) {
    if (kid != tseKeyId) return DeviceCheck.unknownKey;
  } else {
    return DeviceCheck.unreadable;
  }
  if (sig.length != 64) return DeviceCheck.invalid;
  final ok = await DartEd25519().verify(
    ascii.encode('${parts[0]}.${parts[1]}'),
    signature: Signature(
      sig,
      publicKey: SimplePublicKey(
        _decode(tsePublicKey),
        type: KeyPairType.ed25519,
      ),
    ),
  );
  if (!ok) return DeviceCheck.invalid;
  return sha256.convert(payload).toString() == expectedSha256
      ? DeviceCheck.valid
      : DeviceCheck.differentFile;
}

List<int> _decode(String part) => base64Url.decode(base64Url.normalize(part));

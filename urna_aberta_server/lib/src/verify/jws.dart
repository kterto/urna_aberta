import 'dart:convert';

import 'package:cryptography/cryptography.dart';

/// TSE's signing keys for published result files, by key id (`kid`).
///
/// From TSE's "Manual de verificação dos arquivos JWS" (Apêndice B, ambiente
/// oficial). Pinned here, never read from the file being checked: a key
/// shipped inside the file would prove nothing. Checked 10/10/2026 against
/// the 83 archived 1st-round result files in `fixtures/2026-1t`.
const tseSigningKeys = {
  'sNbt9Q_fLS65zE1_ZLNV-XRRwPY': 'kWlpNHjuws1csyQZwzn3Fhzbi3RD435RbpThtSr4hMc',
};

enum JwsCheck {
  /// Signed by the key TSE publishes; the payload is exactly what TSE signed.
  valid,

  /// The signature does not match the payload: altered or not from TSE.
  invalid,

  /// Signed with a key id this app does not know; nothing can be said.
  unknownKey,
}

/// A TSE file in JWS compact serialization: `header.payload.signature`,
/// each base64url without padding. The payload is the JSON file itself.
class TseJws {
  TseJws._(this.kid, this.alg, this.payload, this._signingInput, this._sig);

  final String kid;
  final String alg;

  /// The signed file, byte for byte (the same bytes as the `.json`).
  final List<int> payload;

  final List<int> _signingInput;
  final List<int> _sig;

  /// Throws [FormatException] for anything but a three-part EdDSA JWS with a
  /// key id.
  static TseJws parse(String compact) {
    final parts = compact.trim().split('.');
    if (parts.length != 3) {
      throw const FormatException('JWS: esperado header.payload.signature');
    }
    final Object? header;
    final List<int> payload, sig;
    try {
      header = jsonDecode(utf8.decode(_decode(parts[0])));
      payload = _decode(parts[1]);
      sig = _decode(parts[2]);
    } on FormatException catch (e) {
      throw FormatException('JWS ilegível: ${e.message}');
    }
    if (header case {'kid': final String kid, 'alg': final String alg}) {
      if (alg != 'EdDSA') {
        throw FormatException('JWS: algoritmo $alg não aceito (só EdDSA)');
      }
      return TseJws._(
        kid,
        alg,
        payload,
        ascii.encode('${parts[0]}.${parts[1]}'),
        sig,
      );
    }
    throw const FormatException('JWS: cabeçalho sem kid ou alg');
  }

  static List<int> _decode(String part) =>
      base64Url.decode(base64Url.normalize(part));
}

/// Checks [jws] against [keys] (kid → Ed25519 public key, base64url).
Future<JwsCheck> checkJws(
  TseJws jws, {
  Map<String, String> keys = tseSigningKeys,
}) async {
  final key = keys[jws.kid];
  if (key == null) return JwsCheck.unknownKey;
  if (jws._sig.length != 64) return JwsCheck.invalid;
  final ok = await Ed25519().verify(
    jws._signingInput,
    signature: Signature(
      jws._sig,
      publicKey: SimplePublicKey(
        TseJws._decode(key),
        type: KeyPairType.ed25519,
      ),
    ),
  );
  return ok ? JwsCheck.valid : JwsCheck.invalid;
}

/// The urna's signature file (`-vota.vsc`): for each signing block, the
/// hash of every file the urna wrote and a signature over that list.
///
/// Follows TSE's 2022 `assinatura.asn1` adapted to the 2026 layout (see
/// `asn1/assinatura2026.asn1`). The hardware block's signature (Ed521 on
/// UE2020/UE2022) is verified back to TSE's urna CA; the software block uses
/// TSE's unpublished CEPESC algorithm and only its hashes are checked.
library;

import 'package:crypto/crypto.dart';

import 'der.dart';
import 'ed521.dart';
import 'urna_certificate.dart';

enum FileCheck {
  /// The file hashes to the value the urna listed.
  matches,

  /// The file is listed but its bytes hash differently.
  differs,

  /// The urna did not list a file with this name.
  notListed,

  /// The listing no longer matches the hash the urna signed.
  listingAltered,
}

enum HardwareSignature {
  /// Signed by the urna, whose certificate TSE's urna CA issued.
  valid,

  /// The signature, the listing or the certificate does not check out.
  invalid,

  /// An algorithm this app cannot check (older urna models), or no
  /// certificate in the file.
  unsupported,
}

class SignatureBlock {
  const SignatureBlock({
    required this.kind,
    required this.signer,
    required this.hashAlgorithm,
    required this.signatureAlgorithm,
    required this.signatureBits,
    required this.listingIntact,
    required this.signedHash,
    required this.signature,
    required this.certificate,
    required this.fileHashes,
  });

  /// `software` or `hardware`.
  final String kind;
  final String signer;
  final String hashAlgorithm;
  final String signatureAlgorithm;
  final int signatureBits;

  /// The file listing hashes to the value the urna signed.
  final bool listingIntact;

  /// The listing's hash, as the urna computed and signed it.
  final List<int> signedHash;
  final List<int> signature;

  /// The urna's X.509 certificate (PEM), when the block carries one.
  final List<int>? certificate;
  bool get hasCertificate => certificate != null;
  final Map<String, List<int>> fileHashes;
}

class UrnaSignatures {
  const UrnaSignatures(this.blocks);

  final List<SignatureBlock> blocks;

  /// The hardware block, signed by the urna's security chip.
  SignatureBlock get hardware =>
      blocks.singleWhere((b) => b.kind == 'hardware');

  /// Checks [bytes] against the hardware block's listing for [name].
  FileCheck check(String name, List<int> bytes) {
    final hw = hardware;
    if (!hw.listingIntact) return FileCheck.listingAltered;
    final listed = hw.fileHashes[name];
    if (listed == null) return FileCheck.notListed;
    final actual = _hashes[hw.hashAlgorithm]!.convert(bytes).bytes;
    return _equal(actual, listed) ? FileCheck.matches : FileCheck.differs;
  }

  /// Checks the hardware block's signature over its listing, and that the
  /// signing certificate comes from TSE's urna CA.
  ///
  /// The urna signs SHA-512 of the listing's SHA-512 hash, as TSE's QR code
  /// manual does for the printed BU.
  HardwareSignature hardwareSignature() {
    final hw = hardware;
    final cert = hw.certificate;
    if (hw.signatureAlgorithm != 'eddsa' ||
        hw.signatureBits != 521 ||
        hw.hashAlgorithm != 'sha512' ||
        cert == null) {
      return HardwareSignature.unsupported;
    }
    if (!hw.listingIntact) return HardwareSignature.invalid;
    final UrnaCertificate urna;
    try {
      urna = UrnaCertificate.parse(cert);
    } on FormatException {
      return HardwareSignature.invalid;
    }
    final valid =
        urna.issuedByTse() &&
        Ed521.verify(
          publicKey: urna.publicKey,
          message: sha512.convert(hw.signedHash).bytes,
          signature: hw.signature,
        );
    return valid ? HardwareSignature.valid : HardwareSignature.invalid;
  }
}

const _hashNames = {1: 'sha1', 2: 'sha256', 3: 'sha384', 4: 'sha512'};
final _hashes = <String, Hash>{
  'sha1': sha1,
  'sha256': sha256,
  'sha384': sha384,
  'sha512': sha512,
};
const _signatureNames = {1: 'rsa', 2: 'ecdsa', 3: 'cepesc', 4: 'eddsa'};

/// Decodes a `-vota.vsc` file. Throws [FormatException] when the bytes do
/// not have the signature-file layout.
UrnaSignatures decodeAssinaturas(List<int> bytes) {
  try {
    // 2026: SEQUENCE { assinaturaSW, assinaturaHW, { modeloUrna, … } }.
    final top = DerNode.parse(bytes).children;
    if (top.length != 3) {
      throw const FormatException('VSC: expected software, hardware, model');
    }
    return UrnaSignatures([
      _block('software', top[0]),
      _block('hardware', top[1]),
    ]);
  } on FormatException {
    rethrow;
  } on Object catch (e) {
    throw FormatException('VSC: unexpected layout ($e)');
  }
}

SignatureBlock _block(String kind, DerNode node) {
  // EntidadeAssinatura: dataHoraCriacao, versao, autoAssinado,
  // conteudoAutoAssinado, [0] conjuntoChave OPTIONAL,
  // [1] certificadoDigital OPTIONAL.
  final f = node.children;
  final auto = f[2].children;
  final listing = f[3];
  if (!listing.isUniversal(DerNode.octetString)) {
    throw const FormatException('VSC: missing signed listing');
  }
  final hashName = _hashNames[auto[1].children[0].asInt];
  final signatureName = _signatureNames[auto[2].children[0].asInt];
  if (hashName == null || signatureName == null) {
    throw const FormatException('VSC: unknown hash or signature algorithm');
  }
  final signedHash = auto[3].children[1].bytes;
  final certificate = f.where((n) => n.isContext(1) && n.bytes.isNotEmpty);
  final listingHash = _hashes[hashName]!.convert(listing.bytes).bytes;

  // Assinatura: SEQUENCE { arquivosAssinados SEQUENCE OF
  //   { nomeArquivo, AssinaturaDigital { tamanho, hash, assinatura } } }.
  final files = DerNode.parse(listing.bytes).children[0].children;
  return SignatureBlock(
    kind: kind,
    signer: auto[0].children[0].asString,
    hashAlgorithm: hashName,
    signatureAlgorithm: signatureName,
    signatureBits: auto[2].children[1].asInt,
    listingIntact: _equal(listingHash, signedHash),
    signedHash: signedHash,
    signature: auto[3].children[2].bytes,
    certificate: certificate.firstOrNull?.bytes,
    fileHashes: {
      for (final a in files)
        a.children[0].asString: a.children[1].children[1].bytes,
    },
  );
}

bool _equal(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a[i] ^ b[i];
  }
  return diff == 0;
}

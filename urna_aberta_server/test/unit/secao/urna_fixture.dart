import 'dart:io';

import 'package:urna_aberta_server/src/secao/assinatura.dart';
import 'package:urna_aberta_server/src/secao/urna_certificate.dart';

const urnaFixtureDir =
    '../fixtures/2026-1t/oficial/ele2026/arquivo-urna/3220/dados/ac/01066/0004/0077/'
    '4a6b704a7350756e6a5a496433337049453538516932486a676159553779785542752d6d765749354f41343d';

final urnaVsc = File(
  '$urnaFixtureDir/o03220ac0106600040077-vota.vsc',
).readAsBytesSync();

SignatureBlock urnaHardwareBlock() => decodeAssinaturas(urnaVsc).hardware;

/// The fixture urna's certificate (CN=UEAO02293919, issued by AC UE2022).
final urnaCertificate = UrnaCertificate.parse(urnaHardwareBlock().certificate!);

List<int> get urnaPublicKey => urnaCertificate.publicKey;

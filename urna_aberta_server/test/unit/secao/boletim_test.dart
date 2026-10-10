import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/secao/boletim.dart';

/// Real BU for AC, Porto Walter (01066), zona 0004, seção 0077, archived in
/// fixtures/2026-1t.
final _bu = File(
  '../fixtures/2026-1t/oficial/ele2026/arquivo-urna/3220/dados/ac/01066/0004/0077/'
  '4a6b704a7350756e6a5a496433337049453538516932486a676159553779785542752d6d765749354f41343d/'
  'o03220ac0106600040077-bu.dat',
).readAsBytesSync();

BoletimCargo cargo(Boletim b, int codigo) =>
    b.eleicoes.expand((e) => e.cargos).singleWhere((c) => c.codigo == codigo);

void main() {
  final bu = decodeBoletim(_bu);

  test('identifies the section and the urna clock', () {
    expect(bu.pleito, 3220);
    expect(bu.oficial, isTrue);
    expect([bu.municipio, bu.zona, bu.secao, bu.local], [1066, 4, 77, 1031]);
    expect(bu.emitidoEm.iso, '2026-10-04T15:44:09');
    expect(bu.abertura!.iso, '2026-10-04T06:06:52');
    expect(bu.encerramento!.iso, '2026-10-04T15:40:41');
    expect(bu.comparecimento, 234);
  });

  test('both elections with 289 eligible voters', () {
    expect(bu.eleicoes.map((e) => e.eleicao), [6257, 6259]);
    expect(bu.eleicoes.map((e) => e.aptos).toSet(), {289});
  });

  test('President votes by ballot number', () {
    final p = cargo(bu, 1);
    expect(p.nome, 'Presidente');
    expect(p.comparecimento, 234);
    int? votes(int n) => p.votos
        .where((v) => v.tipo == TipoVoto.nominal && v.numero == n)
        .singleOrNull
        ?.votos;
    expect([votes(22), votes(13), votes(55), votes(14)], [103, 99, 5, 4]);
    expect(p.totalVotos, 234);
  });

  test('every office adds up; Senate has two seats', () {
    for (final c in bu.eleicoes.expand((e) => e.cargos)) {
      final seats = c.codigo == 5 ? 2 : 1;
      expect(c.totalVotos, c.comparecimento * seats, reason: c.nome);
    }
    expect(cargo(bu, 5).nome, 'Senador');
    expect(cargo(bu, 6).nome, 'Deputado Federal');
  });

  test('a changed vote count no longer adds up and is refused', () {
    // Lula's 99 votes are encoded as context tag [2], length 1, value 0x63.
    final tampered = Uint8List.fromList(_bu);
    final at = _indexOf(tampered, [0x82, 0x01, 0x63, 0xa3]);
    expect(at, greaterThan(0));
    tampered[at + 2] = 0x64;
    expect(() => decodeBoletim(tampered), throwsFormatException);
  });

  test('bytes that are not a BU are refused', () {
    expect(() => decodeBoletim([1, 2, 3]), throwsFormatException);
    expect(() => decodeBoletim(_bu.sublist(0, 500)), throwsFormatException);
    expect(() => decodeBoletim(<int>[]), throwsFormatException);
  });
}

int _indexOf(List<int> h, List<int> n) {
  for (var i = 0; i + n.length <= h.length; i++) {
    var ok = true;
    for (var j = 0; j < n.length && ok; j++) {
      ok = h[i + j] == n[j];
    }
    if (ok) return i;
  }
  return -1;
}

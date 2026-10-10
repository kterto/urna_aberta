import 'dart:async';

import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/secao/secao_controller.dart';

SectionReport sampleReport({
  BuCheck check = BuCheck.matches,
  String status = 'Totalizada',
}) => SectionReport(
  uf: 'ac',
  municipio: 1066,
  municipioNome: 'PORTO WALTER',
  zona: 4,
  secao: 77,
  status: status,
  auxGeneratedAt: DateTime.utc(2026, 10, 5, 15, 52, 50),
  receivedAt: DateTime.utc(2026, 10, 4, 21, 34, 8),
  emitidoEm: '2026-10-04T15:44:09',
  abertura: '2026-10-04T06:06:52',
  encerramento: '2026-10-04T15:40:41',
  local: 1031,
  aptos: 289,
  comparecimento: 234,
  buCheck: check,
  signatureVerified: false,
  cargos: check != BuCheck.matches
      ? []
      : [
          CargoResult(
            eleicao: 6257,
            codigo: 1,
            nome: 'Presidente',
            comparecimento: 234,
            votos: [
              VotoResult(
                tipo: 'nominal',
                numero: 22,
                partido: 22,
                nome: 'FLAVIO BOLSONARO',
                votos: 103,
              ),
              VotoResult(
                tipo: 'nominal',
                numero: 13,
                partido: 13,
                nome: 'LULA',
                votos: 99,
              ),
              VotoResult(tipo: 'branco', votos: 20),
              VotoResult(tipo: 'nulo', votos: 12),
            ],
          ),
          CargoResult(
            eleicao: 6259,
            codigo: 3,
            nome: 'Governador',
            comparecimento: 234,
            votos: [
              VotoResult(
                tipo: 'nominal',
                numero: 11,
                partido: 11,
                nome: 'FULANO',
                votos: 234,
              ),
            ],
          ),
        ],
  files: [
    SectionFileInfo(
      kind: 'bu',
      name: 'o03220ac0106600040077-bu.dat',
      url:
          'https://resultados.tse.jus.br/oficial/ele2026/arquivo-urna/3220/dados/ac/01066/0004/0077/4a6b/o03220ac0106600040077-bu.dat',
      sha256:
          'e987c40fc752fef52b3e03bea6fbe2f1893c4b2e94309f4f5c933319d8ed8985',
      sizeBytes: 9019,
    ),
  ],
  fetchedAt: DateTime.utc(2026, 10, 10, 12),
);

class FakeSecaoSource implements SecaoSource {
  final consults = <(String, int, int, int)>[];
  Object? fail;
  SectionReport Function() report = sampleReport;
  bool hold = false;
  final _held = <String, Completer<void>>{};

  void release(String uf) => _held[uf]!.complete();

  @override
  Future<List<MunicipioRef>> municipios(String uf) async {
    if (hold) await (_held[uf] = Completer<void>()).future;
    return uf == 'ac'
        ? [
            MunicipioRef(codigo: 1120, nome: 'CRUZEIRO DO SUL'),
            MunicipioRef(codigo: 1066, nome: 'PORTO WALTER'),
          ]
        : [MunicipioRef(codigo: 71072, nome: 'SÃO PAULO')];
  }

  @override
  Future<List<int>> zonas(String uf, int municipio) async => [4];

  @override
  Future<List<int>> secoes(String uf, int municipio, int zona) async => [
    77,
    78,
  ];

  @override
  Future<SectionReport> consultar(
    String uf,
    int municipio,
    int zona,
    int secao,
  ) async {
    consults.add((uf, municipio, zona, secao));
    if (fail != null) throw fail!;
    return report();
  }
}

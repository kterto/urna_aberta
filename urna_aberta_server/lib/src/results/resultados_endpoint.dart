import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'results_service.dart';

/// Resultados: the published result of any office, in any scope, for every
/// ordinary election TSE lists, with an independent seat allocation for
/// proportional offices.
class ResultadosEndpoint extends Endpoint {
  /// Set at startup; tests replace it with one backed by fixtures.
  static late ResultsService service;

  Future<List<ElectionSummary>> eleicoes(Session session) async =>
      service.elections();

  Future<List<MunicipioRef>> municipios(
    Session session,
    int eleicao,
    String uf,
  ) => service.municipios(eleicao, uf);

  Future<OfficeReport> resultado(
    Session session,
    int eleicao,
    int cargo,
    String abrangencia,
  ) => service.result(session, eleicao, cargo, abrangencia);
}

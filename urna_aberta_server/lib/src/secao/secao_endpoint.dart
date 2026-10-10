import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../tse/tse_urls.dart';
import 'section_service.dart';

/// Minha seção: find a polling section and read its official files.
class SecaoEndpoint extends Endpoint {
  /// Set at startup; tests replace it with one backed by fixtures.
  static late SectionService service;

  Future<List<MunicipioRef>> municipios(Session session, String uf) =>
      service.municipios(uf);

  Future<List<int>> zonas(Session session, String uf, int municipio) =>
      service.zonas(uf, municipio);

  Future<List<int>> secoes(
    Session session,
    String uf,
    int municipio,
    int zona,
  ) => service.secoes(uf, municipio, zona);

  Future<SectionReport> consultar(
    Session session,
    String uf,
    int municipio,
    int zona,
    int secao,
  ) => service.lookup(
    session,
    SectionId(uf: uf, municipio: municipio, zona: zona, secao: secao),
  );
}

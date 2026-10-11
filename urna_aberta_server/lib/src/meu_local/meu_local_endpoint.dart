import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../secao/section_service.dart';

/// Meu local: the signed-in viewer's own polling place, so Minha seção and
/// Resultados open on it. Only what the viewer typed is kept, and they can
/// delete it.
class MeuLocalEndpoint extends Endpoint {
  /// Set at startup: places are checked against TSE's section config.
  static late SectionService sections;

  @override
  bool get requireLogin => true;

  Future<VoterPlace?> ler(Session session) => VoterPlace.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(session.authenticated!.authUserId),
  );

  /// Saves a municipality, optionally down to zone and section, once TSE's
  /// section config lists it.
  Future<VoterPlace> salvar(
    Session session,
    String uf,
    int municipio,
    int? zona,
    int? secao,
  ) async {
    uf = uf.toLowerCase();
    final nome = await _check(uf, municipio, zona, secao);
    final place = VoterPlace(
      authUserId: session.authenticated!.authUserId,
      uf: uf,
      municipio: municipio,
      municipioNome: nome,
      zona: zona,
      secao: secao,
      updatedAt: DateTime.now().toUtc(),
    );
    return session.db.transaction((tx) async {
      final old = await VoterPlace.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(place.authUserId),
        transaction: tx,
      );
      return old == null
          ? VoterPlace.db.insertRow(session, place, transaction: tx)
          : VoterPlace.db.updateRow(
              session,
              place.copyWith(id: old.id),
              transaction: tx,
            );
    });
  }

  Future<void> apagar(Session session) async {
    await VoterPlace.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(session.authenticated!.authUserId),
    );
  }

  /// The municipality's name, or [SectionNotFoundException] if TSE does not
  /// list the place.
  Future<String> _check(String uf, int municipio, int? zona, int? secao) async {
    Never refuse() => throw SectionNotFoundException(
      message: 'TSE não lista o local $uf/$municipio/$zona/$secao.',
    );
    final List<MunicipioRef> municipios;
    try {
      municipios = await sections.municipios(uf);
    } on ArgumentError {
      refuse();
    }
    final m = municipios.where((m) => m.codigo == municipio).firstOrNull;
    if (m == null) refuse();
    if (zona == null) {
      if (secao != null) refuse();
      return m.nome;
    }
    if (!(await sections.zonas(uf, municipio)).contains(zona)) refuse();
    if (secao != null &&
        !(await sections.secoes(uf, municipio, zona)).contains(secao)) {
      refuse();
    }
    return m.nome;
  }
}

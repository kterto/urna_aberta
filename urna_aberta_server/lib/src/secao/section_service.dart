import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart' hide Scope;

import '../generated/protocol.dart';
import '../tse/tse_client.dart';
import '../tse/tse_urls.dart';
import 'assinatura.dart';
import 'aux_file.dart';
import 'boletim.dart';
import 'section_directory.dart';

/// Looks up one polling section on demand: aux file, BU and the urna's
/// signature file, fetched through the rate-limited client and stored raw.
class SectionService {
  SectionService({
    required this._client,
    required this._urls,
    required this._directory,
    this.pleito = 3220,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final TseClient _client;
  final TseUrls _urls;
  final Future<SectionDirectory> Function(String uf) _directory;
  final int pleito;
  final DateTime Function() _now;

  /// Section statuses that no later aux file will change.
  static const _finalStatuses = {
    'Totalizada',
    'Anulada',
    'Não instalada',
    'Não apurada',
  };

  /// How long a non-final lookup is reused before asking TSE again.
  static const refreshAfter = Duration(minutes: 5);

  /// Elections whose candidates the result files name: President comes from
  /// the national file, state offices from each UF's file.
  static const _federal = 6257, _estadual = 6259;

  Future<List<MunicipioRef>> municipios(String uf) async => [
    for (final m in (await _directory(Scope.uf(uf).code)).municipios)
      MunicipioRef(codigo: m.codigo, nome: m.nome),
  ];

  Future<List<int>> zonas(String uf, int municipio) async =>
      (await _directory(Scope.uf(uf).code)).zonas(municipio);

  Future<List<int>> secoes(String uf, int municipio, int zona) async =>
      (await _directory(Scope.uf(uf).code)).secoes(municipio, zona);

  Future<SectionReport> lookup(Session session, SectionId id) async {
    final dir = await _directory(id.uf);
    if (!dir.contains(id)) {
      throw SectionNotFoundException(message: 'TSE não lista a seção $id.');
    }
    final nome = dir.municipios
        .firstWhere((m) => m.codigo == id.municipio)
        .nome;

    final stored = await _stored(session, id);
    if (stored != null && !_stale(stored)) {
      return _report(session, id, nome, stored);
    }
    if (stored == null && dir.auxGeneratedAt(id) == null) {
      // No aux file yet: asking for it would be a 404.
      return _waiting(id, nome);
    }
    return _report(session, id, nome, await _fetchAndStore(session, id));
  }

  bool _stale(SectionCheck c) =>
      !_finalStatuses.contains(c.auxStatus) &&
      _now().difference(c.fetchedAt) > refreshAfter;

  Future<SectionCheck?> _stored(Session session, SectionId id) =>
      SectionCheck.db.findFirstRow(
        session,
        where: (t) =>
            t.pleito.equals(pleito) &
            t.uf.equals(id.uf) &
            t.municipio.equals(id.municipio) &
            t.zona.equals(id.zona) &
            t.secao.equals(id.secao),
        include: SectionCheck.include(files: SectionFile.includeList()),
      );

  Future<SectionCheck> _fetchAndStore(Session session, SectionId id) async {
    final fetched = <({String kind, Uri url, List<int> body, DateTime? at})>[];
    final AuxFile aux;
    try {
      final auxUrl = _urls.sectionAux(pleito, id);
      final auxBody = await _get(auxUrl);
      aux = parseAux(auxBody);
      fetched.add((kind: 'aux', url: auxUrl, body: auxBody, at: null));
      final entry = _current(aux);
      if (entry != null) {
        for (final kind in ['bu', 'vota']) {
          final name = entry.files[kind];
          if (name == null) continue;
          final url = _urls.urnaFile(pleito, id, entry.hash, name);
          fetched.add((
            kind: kind,
            url: url,
            body: await _get(url),
            at: entry.receivedAt,
          ));
        }
      }
    } on TseException catch (e) {
      throw SectionUnavailableException(
        message: 'O TSE não respondeu agora ($e). Tente de novo mais tarde.',
      );
    } on FormatException catch (e) {
      throw SectionUnavailableException(
        message: 'O TSE publicou um arquivo que não pôde ser lido ($e).',
      );
    }

    return session.db.transaction((tx) async {
      await SectionCheck.db.deleteWhere(
        session,
        where: (t) =>
            t.pleito.equals(pleito) &
            t.uf.equals(id.uf) &
            t.municipio.equals(id.municipio) &
            t.zona.equals(id.zona) &
            t.secao.equals(id.secao),
        transaction: tx,
      );
      final check = await SectionCheck.db.insertRow(
        session,
        SectionCheck(
          pleito: pleito,
          uf: id.uf,
          municipio: id.municipio,
          zona: id.zona,
          secao: id.secao,
          auxStatus: aux.status,
          auxGeneratedAt: aux.generatedAt,
          fetchedAt: _now().toUtc(),
        ),
        transaction: tx,
      );
      check.files = await SectionFile.db.insert(session, [
        for (final f in fetched)
          SectionFile(
            checkId: check.id!,
            kind: f.kind,
            name: f.url.pathSegments.last,
            url: f.url.toString(),
            sha256: sha256.convert(f.body).toString(),
            content: ByteData.sublistView(Uint8List.fromList(f.body)),
            receivedAt: f.at,
          ),
      ], transaction: tx);
      return check;
    });
  }

  Future<List<int>> _get(Uri url) async => switch (await _client.fetch(url)) {
    Fetched(:final body) => body,
    NotModified(:final cachedBody) => cachedBody,
  };

  /// The urna-file set TSE totalized, else the most recently received.
  static AuxEntry? _current(AuxFile aux) {
    if (aux.entries.isEmpty) return null;
    return aux.entries.where((e) => e.status == 'Totalizado').firstOrNull ??
        (aux.entries.toList()
              ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt)))
            .first;
  }

  SectionReport _waiting(SectionId id, String nome) => SectionReport(
    uf: id.uf,
    municipio: id.municipio,
    municipioNome: nome,
    zona: id.zona,
    secao: id.secao,
    status: 'Aguardando',
    buCheck: BuCheck.missing,
    urnaSignature: UrnaSignature.missing,
    cargos: [],
    files: [],
  );

  Future<SectionReport> _report(
    Session session,
    SectionId id,
    String nome,
    SectionCheck check,
  ) async {
    final files = {for (final f in check.files ?? <SectionFile>[]) f.kind: f};
    List<int> bytesOf(SectionFile f) => f.content.buffer.asUint8List(
      f.content.offsetInBytes,
      f.content.lengthInBytes,
    );

    final bu = files['bu'], vota = files['vota'];
    var buCheck = BuCheck.missing;
    var urnaSignature = UrnaSignature.missing;
    Boletim? boletim;
    if (vota != null) {
      final assinaturas = decodeAssinaturas(bytesOf(vota));
      urnaSignature = switch (assinaturas.hardwareSignature()) {
        HardwareSignature.valid => UrnaSignature.valid,
        HardwareSignature.invalid => UrnaSignature.invalid,
        HardwareSignature.unsupported => UrnaSignature.unsupported,
      };
      if (bu != null) {
        buCheck = switch (assinaturas.check(bu.name, bytesOf(bu))) {
          FileCheck.matches => BuCheck.matches,
          FileCheck.differs => BuCheck.differs,
          FileCheck.notListed => BuCheck.notListed,
          FileCheck.listingAltered => BuCheck.listingAltered,
        };
        if (buCheck == BuCheck.matches) boletim = decodeBoletim(bytesOf(bu));
      }
    }

    final names = boletim == null
        ? const <(int, int, int), String>{}
        : await _names(session, id);
    return SectionReport(
      uf: id.uf,
      municipio: id.municipio,
      municipioNome: nome,
      zona: id.zona,
      secao: id.secao,
      status: check.auxStatus,
      auxGeneratedAt: check.auxGeneratedAt,
      receivedAt: bu?.receivedAt,
      emitidoEm: boletim?.emitidoEm.iso,
      abertura: boletim?.abertura?.iso,
      encerramento: boletim?.encerramento?.iso,
      local: boletim?.local,
      aptos: boletim?.eleicoes.firstOrNull?.aptos,
      comparecimento: boletim?.comparecimento,
      buCheck: buCheck,
      urnaSignature: urnaSignature,
      cargos: [
        for (final e in boletim?.eleicoes ?? const <BoletimEleicao>[])
          for (final c in e.cargos)
            CargoResult(
              eleicao: e.eleicao,
              codigo: c.codigo,
              nome: c.nome,
              comparecimento: c.comparecimento,
              votos: [
                for (final v in _ordered(c.votos))
                  VotoResult(
                    tipo: v.tipo.name,
                    numero: v.numero,
                    partido: v.partido,
                    nome: v.numero == null
                        ? null
                        : names[(e.eleicao, c.codigo, v.numero!)],
                    votos: v.votos,
                  ),
              ],
            ),
      ],
      files: [
        for (final kind in ['aux', 'bu', 'vota'])
          if (files[kind] case final f?)
            SectionFileInfo(
              kind: f.kind,
              name: f.name,
              url: f.url,
              sha256: f.sha256,
              sizeBytes: f.content.lengthInBytes,
            ),
      ],
      fetchedAt: check.fetchedAt,
    );
  }

  /// Candidacies first, most voted first; then party, blank and null votes.
  static List<BoletimVoto> _ordered(List<BoletimVoto> votos) =>
      [...votos]..sort((a, b) {
        final byType = a.tipo.index.compareTo(b.tipo.index);
        return byType != 0 ? byType : b.votos.compareTo(a.votos);
      });

  /// Ballot names keyed by (election, office, number).
  Future<Map<(int, int, int), String>> _names(
    Session session,
    SectionId id,
  ) async {
    final rows = await Candidate.db.find(
      session,
      where: (t) =>
          (t.electionCode.equals(_federal) & t.scopeCode.equals('br')) |
          (t.electionCode.equals(_estadual) & t.scopeCode.equals(id.uf)),
    );
    return {
      for (final c in rows)
        (c.electionCode, c.officeCode, c.number): c.ballotName,
    };
  }
}

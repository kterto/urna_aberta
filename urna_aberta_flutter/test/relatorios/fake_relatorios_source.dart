import 'dart:async';

import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/relatorios/relatorios_source.dart';

ReportRequest sampleRequest({
  int id = 1,
  ReportStatus status = ReportStatus.ready,
  int filesDone = 23,
  int filesTotal = 23,
  String? publicToken,
  String? errorReason,
}) => ReportRequest(
  id: id,
  authUserId: UuidValue.fromString('6f1c6a8e-0d3c-4a55-9d3e-4f5b1c2a7e10'),
  spec: ReportSpec(
    elections: [6257],
    offices: [1],
    places: [ReportPlace(kind: ReportPlaceKind.uf, uf: 'ac')],
    breakdown: ReportBreakdown.municipio,
    language: 'pt',
  ),
  placeNames: ['AC'],
  status: status,
  filesDone: filesDone,
  filesTotal: filesTotal,
  errorReason: errorReason,
  createdAt: DateTime.utc(2026, 10, 11, 12),
  finishedAt: status == ReportStatus.ready
      ? DateTime.utc(2026, 10, 11, 12, 1)
      : null,
  sha256: status == ReportStatus.ready ? 'a' * 64 : null,
  publicToken: publicToken,
);

class FakeRelatoriosSource implements RelatoriosSource {
  final quoted = <ReportSpec>[];
  final requested = <ReportSpec>[];
  final links = <(int, String)>[];
  final deleted = <int>[];
  ReportQuote quote = ReportQuote(
    files: 23,
    stored: 1,
    seconds: 2,
    limit: 3000,
    tables: 23,
    sectionsWithoutFiles: 0,
  );
  Object? refuse;
  List<ReportRequest> reports = [];
  final streams = <int, StreamController<ReportRequest>>{};
  var _nextId = 100;

  @override
  Future<ReportQuote> orcar(ReportSpec spec) async {
    quoted.add(spec);
    if (refuse != null) throw refuse!;
    return quote;
  }

  @override
  Future<ReportRequest> pedir(ReportSpec spec) async {
    requested.add(spec);
    if (refuse != null) throw refuse!;
    final r = sampleRequest(
      id: _nextId++,
      status: ReportStatus.queued,
      filesDone: 0,
    ).copyWith(spec: spec);
    reports = [r, ...reports];
    return r;
  }

  @override
  Future<List<ReportRequest>> listar() async => reports;

  @override
  Stream<ReportRequest> acompanhar(int id) =>
      (streams[id] ??= StreamController<ReportRequest>()).stream;

  @override
  Future<String> link(int id, String formato) async {
    links.add((id, formato));
    return 'http://localhost:8082/d/token-$id-$formato';
  }

  @override
  Future<ReportRequest> publicar(int id, bool publico) async {
    final r = reports.firstWhere((r) => r.id == id);
    final updated = r.copyWith(publicToken: publico ? 'tok$id' : null);
    reports = [for (final x in reports) x.id == id ? updated : x];
    return updated;
  }

  @override
  Future<String?> linkPublico(int id) async {
    final r = reports.firstWhere((r) => r.id == id);
    return r.publicToken == null
        ? null
        : 'http://localhost:8082/r/${r.publicToken}';
  }

  @override
  Future<void> apagar(int id) async {
    deleted.add(id);
    reports = [
      for (final r in reports)
        if (r.id != id) r,
    ];
  }
}

import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'report_service.dart';

/// Relatórios: reports anyone signed in can configure, over any election,
/// office and place Urna Aberta covers.
class RelatoriosEndpoint extends Endpoint {
  /// Set at startup; tests replace it with one backed by fixtures.
  static late ReportService service;

  @override
  bool get requireLogin => true;

  /// What [spec] would read, how much is already stored, and how long the
  /// rest would take. Refuses a spec naming anything TSE does not list.
  Future<ReportQuote> orcar(Session session, ReportSpec spec) =>
      service.quote(session, spec);

  /// Queues [spec]; the report is built in the background.
  Future<ReportRequest> pedir(Session session, ReportSpec spec) =>
      service.request(session, spec);

  /// The viewer's reports, newest first.
  Future<List<ReportRequest>> listar(Session session) => service.list(session);

  /// One report's state now, then each change until it is ready or failed.
  Stream<ReportRequest> acompanhar(Session session, int id) =>
      service.follow(session, id);

  /// A ready report's file: `csv`.
  Future<ByteData> baixar(Session session, int id, String formato) =>
      service.download(session, id, formato);

  /// Gives a ready report a public link (`/r/<publicToken>`), or removes it.
  Future<ReportRequest> publicar(Session session, int id, bool publico) =>
      service.publish(session, id, publico);

  Future<void> apagar(Session session, int id) => service.delete(session, id);
}

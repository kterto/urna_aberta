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
}

import 'package:serverpod/serverpod.dart';

import 'report_service.dart';

/// Builds the queued reports in the background (scheduled by
/// [ReportService] when a report is asked for, and at startup).
class ReportCall extends FutureCall {
  /// Set at startup.
  static ReportService? service;

  Future<void> drain(Session session) async {
    await service?.drain(session);
  }
}

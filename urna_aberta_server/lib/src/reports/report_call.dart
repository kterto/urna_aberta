import 'package:serverpod/serverpod.dart';

import 'report_service.dart';

/// Builds the queued reports in the background (scheduled by
/// [ReportService] when a report is asked for, or when [watch] finds one
/// waiting).
class ReportCall extends FutureCall {
  /// The one recurring [watch].
  static const watchId = 'report-watch';

  /// How often [watch] runs.
  static const watchEvery = Duration(minutes: 1);

  /// Set at startup.
  static ReportService? service;

  Future<void> drain(Session session) async {
    await service?.drain(session);
  }

  /// Queues again the reports whose server went quiet (scheduled in
  /// `server.dart`).
  Future<void> watch(Session session) async {
    await service?.watch(session);
  }
}

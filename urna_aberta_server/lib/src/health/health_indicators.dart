import 'package:serverpod/serverpod.dart';

import '../tse/tse_client.dart';

/// Whether TSE requests are paused after a 404 or a block. Always passes:
/// the server still serves every stored file, so a pause must not take it
/// out of traffic. The detailed `/readyz` answer says which.
class TseIndicator extends HealthIndicator<String> {
  TseIndicator(this._tse);

  final TseClient _tse;

  @override
  String get name => 'tse:client';

  @override
  String get componentType => HealthComponentType.component.name;

  @override
  Future<HealthCheckResult> check() async {
    final until = _tse.pausedUntil;
    if (until == null) return pass(observedValue: 'available');
    return pass(
      observedValue: 'paused',
      output:
          'Requests to TSE paused until ${until.toUtc().toIso8601String()} '
          'after a 404 or a block; stored files are still served.',
    );
  }
}

/// Startup waits for the archived 1st-round files to be stored, so no
/// viewer opens Apuração before its replay exists. A failed or skipped
/// seeding still completes startup; the log says why.
class ReplayIndicator extends HealthIndicator<String> {
  String? _outcome;

  /// Called once seeding has been tried.
  void stored(String outcome) => _outcome = outcome;

  @override
  String get name => 'urna:replay';

  @override
  String get componentType => HealthComponentType.component.name;

  @override
  Future<HealthCheckResult> check() async {
    final outcome = _outcome;
    if (outcome == null) {
      return fail(output: 'Archived 1st-round files are still being stored.');
    }
    return pass(output: outcome);
  }
}

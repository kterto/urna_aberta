import 'package:serverpod/serverpod.dart';

import 'live_ingestor.dart';

/// Runs every [LiveIngestor.pollEvery] (scheduled in `server.dart`); each
/// run polls TSE only when the ingestor is due: every run while a live
/// window is open, otherwise at the next opening or every
/// [LiveIngestor.idleCheck].
class LivePollCall extends FutureCall {
  /// The one recurring poll.
  static const id = 'live-poll';

  /// Set at startup when live ingestion is enabled; null leaves it off.
  static LiveIngestor? ingestor;

  Future<void> poll(Session session) async {
    await ingestor?.pollIfDue(session);
  }
}

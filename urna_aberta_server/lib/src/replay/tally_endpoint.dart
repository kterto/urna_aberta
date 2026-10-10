import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'replay_service.dart';

/// National file vs independent sum of states, on the replay clock.
///
/// The client owns the clock: it asks for the frame at its own virtual time,
/// so viewers never share play/pause state.
class TallyEndpoint extends Endpoint {
  Future<ReplayNight> night(Session session) => ReplayService.night(session);

  Future<TallyFrame> frame(Session session, DateTime at) =>
      ReplayService.frame(session, at);

  /// At most [ReplayService.maxTimelinePoints] samples from [from] to [to].
  Future<List<TimelinePoint>> timeline(
    Session session,
    DateTime from,
    DateTime to,
    int stepSeconds,
  ) =>
      ReplayService.timeline(session, from, to, Duration(seconds: stepSeconds));

  Future<List<DivergenceEvent>> divergence(Session session, DateTime at) =>
      ReplayService.divergence(session, at);
}

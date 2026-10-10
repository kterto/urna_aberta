import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/live/live_controller.dart';

import '../replay/replay_controller_test.dart' show FakeSource, FakeTimer;

LiveStatus liveWith({required bool open, double national = 40}) => LiveStatus(
  electionCode: 6258,
  round: 2,
  opensAt: DateTime.utc(2026, 10, 25, 20),
  closesAt: DateTime.utc(2026, 10, 26, 9),
  open: open,
  frame: TallyFrame(
    at: DateTime.utc(2026, 10, 25, 21),
    origin: DataOrigin.live,
    nationalPct: national,
    statesPct: 42,
    missingScopes: [],
    candidates: [],
    ufs: [],
  ),
  timeline: [],
  divergence: [],
);

class CountingSource extends FakeSource {
  int liveCalls = 0;
  Object? failLive;

  @override
  Future<LiveStatus> live() async {
    liveCalls++;
    if (failLive != null) throw failLive!;
    return liveStatus;
  }
}

void main() {
  late CountingSource source;
  late List<FakeTimer> timers;
  late LiveController c;

  setUp(() {
    source = CountingSource();
    timers = [];
    c = LiveController(
      source,
      timer: (period, tick) {
        expect(period, LiveController.refreshEvery);
        final t = FakeTimer(tick);
        timers.add(t);
        return t;
      },
    );
  });

  test('before the count: the next opening, no refreshing', () async {
    await c.load();
    expect(c.status!.open, isFalse);
    expect(c.status!.frame, isNull);
    expect(timers, isEmpty);
  });

  test('while the count is open it refreshes every 30 seconds', () async {
    source.liveStatus = liveWith(open: true);
    await c.load();
    expect(timers, hasLength(1));
    source.liveStatus = liveWith(open: true, national: 55);
    timers.single.callback(timers.single);
    await pumpEventQueue();
    expect(source.liveCalls, 2);
    expect(c.status!.frame!.nationalPct, 55);
  });

  test('stops refreshing once the window closes', () async {
    source.liveStatus = liveWith(open: true);
    await c.load();
    source.liveStatus = liveWith(open: false);
    timers.single.callback(timers.single);
    await pumpEventQueue();
    expect(timers.single.cancelled, isTrue);
  });

  test('a failed refresh keeps the last figures and says so', () async {
    source.liveStatus = liveWith(open: true);
    await c.load();
    source.failLive = StateError('offline');
    timers.single.callback(timers.single);
    await pumpEventQueue();
    expect(c.status!.frame!.nationalPct, 40);
    expect(c.stale, isTrue);
    source.failLive = null;
    timers.single.callback(timers.single);
    await pumpEventQueue();
    expect(c.stale, isFalse);
  });

  test('a failed first load is an error with nothing to show', () async {
    source.failLive = StateError('offline');
    await c.load();
    expect(c.status, isNull);
    expect(c.error, isA<StateError>());
  });

  test('dispose cancels the refresh', () async {
    source.liveStatus = liveWith(open: true);
    await c.load();
    c.dispose();
    expect(timers.single.cancelled, isTrue);
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';
import 'package:urna_aberta_flutter/replay/replay_controller.dart';

DateTime brt(int day, int hour, int minute) =>
    DateTime.utc(2026, 10, day, hour + 3, minute);

final _night = ReplayNight(
  origin: DataOrigin.synthetic,
  electionCode: 6257,
  officeCode: 1,
  start: brt(4, 17, 0),
  end: brt(5, 1, 0),
  freezeStart: brt(4, 19, 14),
  freezeEnd: brt(4, 20, 4),
  finalsGeneratedAt: brt(5, 12, 52),
);

TallyFrame frameAt(DateTime at) => TallyFrame(
  at: at,
  origin: DataOrigin.synthetic,
  nationalPct: 50,
  statesPct: 60,
  missingScopes: [],
  candidates: [],
  ufs: [],
);

class FakeSource implements TallySource {
  /// Before the 2nd round: nothing live yet.
  LiveStatus liveStatus = LiveStatus(
    electionCode: 6258,
    round: 2,
    opensAt: DateTime.utc(2026, 10, 25, 20),
    closesAt: DateTime.utc(2026, 10, 26, 9),
    open: false,
    timeline: [],
    divergence: [],
  );

  final frameRequests = <DateTime>[];
  final pending = <Completer<TallyFrame>>[];
  bool holdFrames = false;
  Object? failNight;

  @override
  Future<ReplayNight> night() async {
    if (failNight != null) throw failNight!;
    return _night;
  }

  @override
  Future<TallyFrame> frame(DateTime at) {
    frameRequests.add(at);
    if (!holdFrames) return Future.value(frameAt(at));
    final c = Completer<TallyFrame>();
    pending.add(c);
    return c.future;
  }

  @override
  Future<List<TimelinePoint>> timeline(
    DateTime from,
    DateTime to,
    int stepSeconds,
  ) async => [
    for (
      var t = from;
      !t.isAfter(to);
      t = t.add(Duration(seconds: stepSeconds))
    )
      TimelinePoint(at: t, nationalPct: 0, statesPct: 0),
  ];

  @override
  Future<LiveStatus> live() async => liveStatus;
}

class FakeTimer implements Timer {
  FakeTimer(this.callback);
  final void Function(Timer) callback;
  bool cancelled = false;

  @override
  void cancel() => cancelled = true;
  @override
  bool get isActive => !cancelled;
  @override
  int get tick => 0;
}

void main() {
  late FakeSource source;
  late List<FakeTimer> timers;
  late ReplayController c;
  late DateTime wall;

  setUp(() {
    source = FakeSource();
    timers = [];
    wall = DateTime.utc(2026, 10, 10, 12);
    c = ReplayController(
      source,
      wallClock: () => wall,
      timer: (period, tick) {
        final t = FakeTimer(tick);
        timers.add(t);
        return t;
      },
    );
  });

  test('load opens at the start of the count, paused', () async {
    await c.load();
    expect(c.night, _night);
    expect(c.now, brt(4, 17, 0));
    expect(c.playing, isFalse);
    expect(c.frame!.at, brt(4, 17, 0));
    expect(c.timeline, hasLength(8 * 60 + 1));
    expect(c.nowIndex, 0);
  });

  test('a failed load keeps the error and can be retried', () async {
    source.failNight = Exception('offline');
    await c.load();
    expect(c.error, isNotNull);
    expect(c.night, isNull);
    source.failNight = null;
    await c.load();
    expect(c.error, isNull);
    expect(c.night, isNotNull);
  });

  test('playing at 10x moves 10 virtual seconds per real second', () async {
    await c.load();
    c.setSpeed(10);
    c.togglePlay();
    expect(timers.single.isActive, isTrue);
    c.advance(const Duration(seconds: 6));
    expect(c.now, brt(4, 17, 1));
  });

  test('a new frame is fetched once per virtual minute', () async {
    await c.load();
    c.setSpeed(60);
    c.togglePlay();
    source.frameRequests.clear();
    c.advance(const Duration(milliseconds: 500));
    c.advance(const Duration(milliseconds: 500));
    expect(source.frameRequests, [brt(4, 17, 1)]);
  });

  test(
    'a late response for an older minute never replaces a newer one',
    () async {
      await c.load();
      source.holdFrames = true;
      c.setSpeed(60);
      c.togglePlay();
      c.advance(const Duration(seconds: 1)); // asks 17:01
      c.advance(const Duration(seconds: 1)); // asks 17:02
      source.pending[1].complete(frameAt(brt(4, 17, 2)));
      await pumpEventQueue();
      source.pending[0].complete(frameAt(brt(4, 17, 1)));
      await pumpEventQueue();
      expect(c.frame!.at, brt(4, 17, 2));
    },
  );

  test('the clock stops at the end of the night', () async {
    await c.load();
    c.setSpeed(60);
    c.togglePlay();
    c.advance(const Duration(hours: 1));
    expect(c.now, _night.end);
    expect(c.playing, isFalse);
    expect(timers.last.isActive, isFalse);
  });

  test('play at the end starts the night over', () async {
    await c.load();
    c.setSpeed(60);
    c.togglePlay();
    c.advance(const Duration(hours: 1));
    c.togglePlay();
    expect(c.now, _night.start);
    expect(c.playing, isTrue);
  });

  test('jump to the freeze', () async {
    await c.load();
    c.jumpToFreeze();
    expect(c.now, _night.freezeStart);
    expect(source.frameRequests.last, _night.freezeStart);
  });

  test('ticks advance by real elapsed time, even when throttled', () async {
    await c.load();
    c.setSpeed(60);
    c.togglePlay();
    // A background tab delivers one tick after 1 s instead of every 250 ms.
    wall = wall.add(const Duration(seconds: 1));
    timers.single.callback(timers.single);
    expect(c.now, brt(4, 17, 1));
  });

  test('pausing cancels the timer', () async {
    await c.load();
    c.togglePlay();
    c.togglePlay();
    expect(c.playing, isFalse);
    expect(timers.single.isActive, isFalse);
  });
}

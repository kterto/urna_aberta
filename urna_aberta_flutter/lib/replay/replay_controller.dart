import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

/// What the replay needs from the server; [ServerTallySource] wraps the
/// generated client.
abstract interface class TallySource {
  Future<ReplayNight> night();
  Future<TallyFrame> frame(DateTime at);
  Future<List<TimelinePoint>> timeline(
    DateTime from,
    DateTime to,
    int stepSeconds,
  );

  /// The presidential count TSE is publishing now, or the next one.
  Future<LiveStatus> live();
}

class ServerTallySource implements TallySource {
  ServerTallySource(this._client);

  final Client _client;

  @override
  Future<ReplayNight> night() => _client.tally.night();

  @override
  Future<TallyFrame> frame(DateTime at) => _client.tally.frame(at);

  @override
  Future<List<TimelinePoint>> timeline(
    DateTime from,
    DateTime to,
    int stepSeconds,
  ) => _client.tally.timeline(from, to, stepSeconds);

  @override
  Future<LiveStatus> live() => _client.tally.live();
}

typedef PeriodicTimer =
    Timer Function(Duration period, void Function(Timer) tick);

/// Drives the replay on a virtual clock owned by this viewer.
class ReplayController extends ChangeNotifier {
  ReplayController(
    this._source, {
    PeriodicTimer? timer,
    DateTime Function()? wallClock,
  }) : _timer = timer ?? Timer.periodic,
       _wallClock = wallClock ?? DateTime.now;

  final TallySource _source;
  final PeriodicTimer _timer;
  final DateTime Function() _wallClock;

  static const tick = Duration(milliseconds: 250);
  static const speeds = [1, 10, 60];

  ReplayNight? _night;
  List<TimelinePoint> _timeline = const [];
  TallyFrame? _frame;
  DateTime? _now;
  bool _playing = false;
  int _speed = 10;
  Object? _error;
  Timer? _ticker;
  DateTime? _requestedMinute;
  int _requestSeq = 0;
  int _appliedSeq = 0;

  ReplayNight? get night => _night;
  List<TimelinePoint> get timeline => _timeline;
  TallyFrame? get frame => _frame;
  DateTime? get now => _now;
  bool get playing => _playing;
  int get speed => _speed;
  Object? get error => _error;

  /// Index of the timeline point at [now].
  int get nowIndex {
    final n = _night, t = _now;
    if (n == null || t == null || _timeline.isEmpty) return 0;
    return t.difference(n.start).inMinutes.clamp(0, _timeline.length - 1);
  }

  Future<void> load() async {
    _error = null;
    notifyListeners();
    try {
      final n = await _source.night();
      _timeline = await _source.timeline(n.start, n.end, 60);
      _night = n;
      // Opens paused where the count starts (17:00); "jump to the pause"
      // goes straight to the freeze.
      _now = n.start;
      await _fetch();
    } catch (e) {
      _error = e;
    }
    notifyListeners();
  }

  void togglePlay() {
    final n = _night;
    if (n == null) return;
    if (_playing) {
      _stop();
    } else {
      if (!_now!.isBefore(n.end)) {
        _now = n.start;
        _fetch();
      }
      _playing = true;
      // Advance by real elapsed time: browsers throttle timers in background
      // tabs, so ticks can arrive far apart.
      var last = _wallClock();
      _ticker = _timer(tick, (_) {
        final t = _wallClock();
        advance(t.difference(last));
        last = t;
      });
    }
    notifyListeners();
  }

  void setSpeed(int speed) {
    if (!speeds.contains(speed)) {
      throw ArgumentError.value(speed, 'speed', 'one of $speeds');
    }
    _speed = speed;
    notifyListeners();
  }

  void jumpToFreeze() {
    final n = _night;
    if (n == null) return;
    _now = n.freezeStart;
    _fetch();
    notifyListeners();
  }

  /// Advances the clock by [real] wall time at the current speed.
  void advance(Duration real) {
    final n = _night;
    if (!_playing || n == null) return;
    var next = _now!.add(real * _speed);
    if (!next.isBefore(n.end)) {
      next = n.end;
      _stop();
    }
    _now = next;
    if (_minute(next) != _requestedMinute) _fetch();
    notifyListeners();
  }

  void _stop() {
    _playing = false;
    _ticker?.cancel();
    _ticker = null;
  }

  /// Requests the frame for the current minute. A response for an older
  /// request never replaces a newer one.
  Future<void> _fetch() async {
    final at = _minute(_now!);
    _requestedMinute = at;
    final seq = ++_requestSeq;
    try {
      final f = await _source.frame(at);
      if (seq < _appliedSeq) return;
      _appliedSeq = seq;
      _frame = f;
      _error = null;
    } catch (e) {
      if (seq < _appliedSeq) return;
      _error = e;
    }
    notifyListeners();
  }

  static DateTime _minute(DateTime t) => DateTime.utc(
    t.year,
    t.month,
    t.day,
    t.hour,
    t.minute,
  );

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

/// Provides the [TallySource] to the screens below it.
class TallyScope extends InheritedWidget {
  const TallyScope({super.key, required this.source, required super.child});

  final TallySource source;

  static TallySource of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TallyScope>();
    assert(scope != null, 'No TallyScope above this widget');
    return scope!.source;
  }

  @override
  bool updateShouldNotify(TallyScope old) => source != old.source;
}

/// Brasília wall time (UTC-3, no daylight saving) for display, kept as a UTC
/// value so `hour` and `minute` read as Brasília time.
DateTime brasilia(DateTime t) => t.toUtc().subtract(const Duration(hours: 3));

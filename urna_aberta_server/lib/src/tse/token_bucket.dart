/// Global request budget for the TSE CDN.
///
/// TSE allows 100 req/s per IP; going over blocks the IP for 10 minutes and
/// retrying during the block resets the timer. Keep the configured rate well
/// below the limit (HANDOFF.md suggests 20–30 req/s). Callers are served in
/// order: concurrent [acquire] calls queue behind each other.
class TokenBucket {
  TokenBucket({
    required this.ratePerSecond,
    required this.burst,
    DateTime Function()? now,
    Future<void> Function(Duration)? sleep,
  }) : _now = now ?? DateTime.now,
       _sleep = sleep ?? Future<void>.delayed {
    if (ratePerSecond <= 0 || ratePerSecond > tseLimitPerSecond) {
      throw ArgumentError.value(
        ratePerSecond,
        'ratePerSecond',
        'must be in (0, $tseLimitPerSecond]',
      );
    }
    if (burst < 1) throw ArgumentError.value(burst, 'burst', 'must be >= 1');
    _tokens = burst.toDouble();
    _last = _now();
  }

  static const tseLimitPerSecond = 100;

  final double ratePerSecond;
  final int burst;
  final DateTime Function() _now;
  final Future<void> Function(Duration) _sleep;

  late double _tokens;
  late DateTime _last;
  Future<void> _queue = Future.value();

  /// Completes when one request may be sent.
  Future<void> acquire() {
    final turn = _queue.then((_) => _take());
    _queue = turn;
    return turn;
  }

  Future<void> _take() async {
    _refill();
    if (_tokens < 1) {
      final micros = ((1 - _tokens) / ratePerSecond * 1e6).ceil();
      await _sleep(Duration(microseconds: micros));
      _refill();
    }
    _tokens -= 1;
  }

  void _refill() {
    final now = _now();
    final elapsed = now.difference(_last).inMicroseconds / 1e6;
    _last = now;
    _tokens = (_tokens + elapsed * ratePerSecond).clamp(0, burst.toDouble());
  }
}

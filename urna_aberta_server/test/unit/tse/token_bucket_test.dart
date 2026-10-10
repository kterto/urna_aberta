import 'package:test/test.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';

/// Fake clock: sleeping advances time instantly and records the wait.
class FakeClock {
  DateTime now = DateTime.utc(2026, 10, 4, 21);
  final sleeps = <Duration>[];

  DateTime call() => now;

  Future<void> sleep(Duration d) async {
    sleeps.add(d);
    now = now.add(d);
  }
}

void main() {
  late FakeClock clock;
  late TokenBucket bucket;

  setUp(() {
    clock = FakeClock();
    bucket = TokenBucket(
      ratePerSecond: 25,
      burst: 5,
      now: clock.call,
      sleep: clock.sleep,
    );
  });

  test('a burst up to capacity goes out without waiting', () async {
    for (var i = 0; i < 5; i++) {
      await bucket.acquire();
    }
    expect(clock.sleeps, isEmpty);
  });

  test(
    'past the burst, each request waits one token interval (40 ms at 25/s)',
    () async {
      for (var i = 0; i < 7; i++) {
        await bucket.acquire();
      }
      expect(clock.sleeps, [
        const Duration(milliseconds: 40),
        const Duration(milliseconds: 40),
      ]);
    },
  );

  test('idle time refills tokens, never above the burst', () async {
    for (var i = 0; i < 5; i++) {
      await bucket.acquire();
    }
    clock.now = clock.now.add(const Duration(seconds: 10));
    for (var i = 0; i < 5; i++) {
      await bucket.acquire();
    }
    expect(clock.sleeps, isEmpty);
    await bucket.acquire();
    expect(clock.sleeps, [const Duration(milliseconds: 40)]);
  });

  test('sustained throughput never exceeds the configured rate', () async {
    final start = clock.now;
    for (var i = 0; i < 105; i++) {
      await bucket.acquire();
    }
    final elapsed = clock.now.difference(start);
    // 105 requests = 5 burst + 100 at 25/s => at least 4 s.
    expect(elapsed, greaterThanOrEqualTo(const Duration(seconds: 4)));
  });

  test('rejects a rate above the TSE limit of 100 req/s', () {
    expect(
      () => TokenBucket(ratePerSecond: 101, burst: 1),
      throwsArgumentError,
    );
  });
}

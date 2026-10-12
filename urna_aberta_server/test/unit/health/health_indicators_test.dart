import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:urna_aberta_server/src/health/health_indicators.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';

class _Reply implements TseHttp {
  _Reply(this.status);

  final int status;

  @override
  Future<TseHttpResponse> get(Uri uri, Map<String, String> headers) async =>
      TseHttpResponse(status, const [], const {});
}

class _NoWait extends TokenBucket {
  _NoWait() : super(ratePerSecond: 20, burst: 1);

  @override
  Future<void> acquire() async {}
}

void main() {
  final uri = Uri.parse('https://resultados.tse.jus.br/oficial/x.json');

  group('TseIndicator', () {
    late DateTime now;
    TseClient client(int status) =>
        TseClient(http: _Reply(status), bucket: _NoWait(), now: () => now);

    setUp(() => now = DateTime.utc(2026, 10, 4, 21));

    test('passes while TSE answers', () async {
      final tse = client(200);
      await tse.fetch(uri);
      final r = await TseIndicator(tse).check();
      expect(r.status, HealthStatus.pass);
      expect(r.observedValue, 'available');
    });

    test(
      'still passes when TSE requests are paused: stored files are served',
      () async {
        final tse = client(404);
        await expectLater(tse.fetch(uri), throwsA(isA<TseNotFound>()));
        final r = await TseIndicator(tse).check();
        expect(r.status, HealthStatus.pass);
        expect(r.observedValue, 'paused');
        expect(r.output, contains('2026-10-04T21:01:00'));

        now = now.add(TseClient.notFoundBackoff);
        expect((await TseIndicator(tse).check()).observedValue, 'available');
      },
    );
  });

  group('ReplayIndicator', () {
    test('fails until the archived files have been stored', () async {
      final replay = ReplayIndicator();
      final before = await replay.check();
      expect(before.status, HealthStatus.fail);

      replay.stored('12 new snapshots');
      final after = await replay.check();
      expect(after.status, HealthStatus.pass);
      expect(after.output, '12 new snapshots');
    });
  });
}

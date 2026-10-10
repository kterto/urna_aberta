import 'dart:convert';

import 'package:test/test.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';

class FakeHttp implements TseHttp {
  final requests = <(Uri, Map<String, String>)>[];
  final responses = <TseHttpResponse>[];

  void reply(
    int status, {
    String body = '',
    Map<String, String> headers = const {},
  }) => responses.add(TseHttpResponse(status, utf8.encode(body), headers));

  @override
  Future<TseHttpResponse> get(Uri uri, Map<String, String> headers) async {
    requests.add((uri, headers));
    return responses.removeAt(0);
  }
}

void main() {
  final uri = Uri.parse(
    'https://resultados.tse.jus.br/oficial/ele2026/6257/dados/br/br-c0001-e006257-u.json',
  );
  late FakeHttp http;
  late DateTime now;
  late int acquired;
  late TseClient client;

  setUp(() {
    http = FakeHttp();
    now = DateTime.utc(2026, 10, 4, 21);
    acquired = 0;
    client = TseClient(
      http: http,
      bucket: _CountingBucket(() => acquired++),
      now: () => now,
    );
  });

  test('first fetch is unconditional and returns the body', () async {
    http.reply(200, body: '{"s":"64.81"}', headers: {'etag': '"v1"'});
    final r = await client.fetch(uri);
    expect(r, isA<Fetched>());
    expect(utf8.decode((r as Fetched).body), '{"s":"64.81"}');
    expect(http.requests.single.$2.containsKey('if-none-match'), isFalse);
  });

  test(
    'refetch sends the stored ETag; a 304 returns the cached body',
    () async {
      http.reply(
        200,
        body: 'A',
        headers: {
          'etag': '"v1"',
          'last-modified': 'Sun, 04 Oct 2026 21:02:00 GMT',
        },
      );
      http.reply(304);
      await client.fetch(uri);
      final r = await client.fetch(uri);
      expect(http.requests.last.$2['if-none-match'], '"v1"');
      expect(
        http.requests.last.$2['if-modified-since'],
        'Sun, 04 Oct 2026 21:02:00 GMT',
      );
      expect(r, isA<NotModified>());
      expect(utf8.decode((r as NotModified).cachedBody), 'A');
    },
  );

  test('every request, 304s included, spends a rate-limit token', () async {
    http.reply(200, body: 'A', headers: {'etag': '"v1"'});
    http.reply(304);
    await client.fetch(uri);
    await client.fetch(uri);
    expect(acquired, 2);
  });

  test('a 404 throws and pauses all requests for the backoff window', () async {
    http.reply(404);
    await expectLater(client.fetch(uri), throwsA(isA<TseNotFound>()));
    await expectLater(client.fetch(uri), throwsA(isA<TseBackingOff>()));
    expect(http.requests, hasLength(1));

    now = now.add(TseClient.notFoundBackoff);
    http.reply(200, body: 'B');
    expect(await client.fetch(uri), isA<Fetched>());
  });

  for (final status in [403, 429]) {
    test(
      'a $status (TSE block) stops all requests for over 10 minutes',
      () async {
        http.reply(status);
        await expectLater(client.fetch(uri), throwsA(isA<TseBlocked>()));

        now = now.add(const Duration(minutes: 10));
        await expectLater(client.fetch(uri), throwsA(isA<TseBackingOff>()));
        expect(
          http.requests,
          hasLength(1),
          reason: 'retrying during a block resets it',
        );

        now = now.add(const Duration(minutes: 2));
        http.reply(200, body: 'C');
        expect(await client.fetch(uri), isA<Fetched>());
      },
    );
  }

  test('other errors throw without poisoning the cache', () async {
    http.reply(200, body: 'A', headers: {'etag': '"v1"'});
    http.reply(500);
    http.reply(304);
    await client.fetch(uri);
    await expectLater(client.fetch(uri), throwsA(isA<TseHttpError>()));
    final r = await client.fetch(uri);
    expect(utf8.decode((r as NotModified).cachedBody), 'A');
  });
}

class _CountingBucket extends TokenBucket {
  _CountingBucket(this._onAcquire) : super(ratePerSecond: 25, burst: 1);

  final void Function() _onAcquire;

  @override
  Future<void> acquire() async => _onAcquire();
}

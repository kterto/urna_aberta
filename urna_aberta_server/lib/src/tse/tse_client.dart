import 'dart:async';
import 'dart:io';

import 'token_bucket.dart';

class TseHttpResponse {
  TseHttpResponse(this.status, this.body, this.headers);

  final int status;
  final List<int> body;

  /// Lowercase header names.
  final Map<String, String> headers;
}

/// Transport seam so the client can be tested without the network.
abstract interface class TseHttp {
  Future<TseHttpResponse> get(Uri uri, Map<String, String> headers);
}

sealed class TseFetch {}

/// A new version of the file.
class Fetched extends TseFetch {
  Fetched(this.body, {this.etag, this.lastModified});

  final List<int> body;
  final String? etag;
  final String? lastModified;
}

/// The file has not changed since the cached copy.
class NotModified extends TseFetch {
  NotModified(this.cachedBody);

  final List<int> cachedBody;
}

sealed class TseException implements Exception {
  TseException(this.uri);

  final Uri uri;
}

/// The file does not exist (yet). All requests pause for
/// [TseClient.notFoundBackoff], since repeated 404s can block the IP.
class TseNotFound extends TseException {
  TseNotFound(super.uri);

  @override
  String toString() => 'TseNotFound: $uri';
}

/// TSE refused us (rate-limit block). All requests stop for
/// [TseClient.blockBackoff]; retrying during a block resets TSE's timer.
class TseBlocked extends TseException {
  TseBlocked(super.uri, this.status);

  final int status;

  @override
  String toString() => 'TseBlocked($status): $uri';
}

/// The client refused to send: a 404 or block backoff is in effect.
class TseBackingOff extends TseException {
  TseBackingOff(super.uri, this.until);

  final DateTime until;

  @override
  String toString() => 'TseBackingOff until $until: $uri';
}

/// No answer: a timeout or a dropped connection. Nothing pauses, since TSE
/// did not refuse anything; asking again later may work.
class TseUnreachable extends TseException {
  TseUnreachable(super.uri, this.cause);

  final Object cause;

  @override
  String toString() => 'TseUnreachable($cause): $uri';
}

class TseHttpError extends TseException {
  TseHttpError(super.uri, this.status);

  final int status;

  @override
  String toString() => 'TseHttpError($status): $uri';
}

class _Cached {
  _Cached(this.body, this.etag, this.lastModified);

  final List<int> body;
  final String? etag;
  final String? lastModified;
}

/// Rate-limited, cache-aware fetcher for TSE static files. Never let
/// clients hit TSE directly; everything goes through one instance.
class TseClient {
  TseClient({
    required this._http,
    required this._bucket,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  static const notFoundBackoff = Duration(minutes: 1);

  /// TSE blocks for 10 minutes; wait a margin past it.
  static const blockBackoff = Duration(minutes: 11);

  final TseHttp _http;
  final TokenBucket _bucket;
  final DateTime Function() _now;
  final _cache = <Uri, _Cached>{};
  DateTime? _pausedUntil;

  /// When requests resume, while a 404 or block backoff is in effect.
  DateTime? get pausedUntil {
    final paused = _pausedUntil;
    return paused != null && _now().isBefore(paused) ? paused : null;
  }

  Future<TseFetch> fetch(Uri uri) async {
    final paused = pausedUntil;
    if (paused != null) throw TseBackingOff(uri, paused);

    final cached = _cache[uri];
    final headers = <String, String>{
      if (cached?.etag != null) 'if-none-match': cached!.etag!,
      if (cached?.lastModified != null)
        'if-modified-since': cached!.lastModified!,
    };

    await _bucket.acquire();
    final TseHttpResponse r;
    try {
      r = await _http.get(uri, headers);
    } on TimeoutException catch (e) {
      throw TseUnreachable(uri, e);
    } on SocketException catch (e) {
      throw TseUnreachable(uri, e);
    } on HttpException catch (e) {
      throw TseUnreachable(uri, e);
    }

    switch (r.status) {
      case 200:
        final etag = r.headers['etag'];
        final lastModified = r.headers['last-modified'];
        _cache[uri] = _Cached(r.body, etag, lastModified);
        return Fetched(r.body, etag: etag, lastModified: lastModified);
      case 304 when cached != null:
        return NotModified(cached.body);
      case 404:
        _pausedUntil = _now().add(notFoundBackoff);
        throw TseNotFound(uri);
      case 403 || 429:
        _pausedUntil = _now().add(blockBackoff);
        throw TseBlocked(uri, r.status);
      default:
        throw TseHttpError(uri, r.status);
    }
  }
}

/// Production transport on `dart:io`.
class IoTseHttp implements TseHttp {
  IoTseHttp({HttpClient? client, this.timeout = const Duration(seconds: 15)})
    : _client = client ?? (HttpClient()..userAgent = 'urna-aberta/0.1');

  final HttpClient _client;
  final Duration timeout;

  @override
  Future<TseHttpResponse> get(Uri uri, Map<String, String> headers) async {
    final req = await _client.getUrl(uri).timeout(timeout);
    headers.forEach(req.headers.set);
    final res = await req.close().timeout(timeout);
    final body = await res
        .fold<List<int>>(<int>[], (a, b) => a..addAll(b))
        .timeout(timeout);
    final out = <String, String>{};
    res.headers.forEach(
      (name, values) => out[name.toLowerCase()] = values.join(','),
    );
    return TseHttpResponse(res.statusCode, body, out);
  }

  void close() => _client.close();
}

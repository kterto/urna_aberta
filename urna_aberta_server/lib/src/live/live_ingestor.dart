import 'package:serverpod/serverpod.dart' hide Scope;

import '../generated/protocol.dart';
import '../ingestion/snapshot_store.dart';
import '../tse/tse_client.dart';
import '../tse/tse_urls.dart';
import '../verify/jws.dart';
import 'elections.dart';

class LiveTick {
  LiveTick({
    required this.recorded,
    required this.unchanged,
    required this.waiting,
    required this.errors,
  });

  /// New file versions stored.
  final int recorded;

  /// Files TSE answered with 304 Not Modified.
  final int unchanged;

  /// Elections whose first file TSE has not published yet.
  final List<int> waiting;

  final List<String> errors;
}

/// Election-night ingestion: polls every result file of the elections
/// whose live window is open, with conditional GETs through the shared
/// rate-limited client, and stores each new signed version as a `live`
/// snapshot.
///
/// Each file is fetched as its `.jws` only: the payload is the `.json`, so
/// one request gives both the file and its signature.
class LiveIngestor {
  LiveIngestor({
    required this._client,
    required this._urls,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final TseClient _client;
  final TseUrls _urls;
  final DateTime Function() _now;

  /// Between polls while a window is open: ~33–83 requests per poll, far
  /// under TSE's 100 req/s.
  static const pollEvery = Duration(seconds: 30);

  /// Outside a window: how often to look again (and refresh EA11).
  static const idleCheck = Duration(hours: 6);

  /// After a 404 on an election's first file: TSE has not started
  /// publishing it. Repeated 404s can block the IP, so wait.
  static const probeBackoff = Duration(minutes: 5);

  /// Elections from EA11; see [refreshElections].
  List<Election> elections = const [];

  /// Elections whose first file has answered 200 this night.
  final _published = <int>{};
  final _probeAfter = <int, DateTime>{};

  DateTime? _electionsRead;
  DateTime? _dueAt;

  /// [pollOnce] when the last one asked to be called again by now.
  Future<void> pollIfDue(Session session) async {
    final due = _dueAt;
    if (due != null && _now().isBefore(due)) return;
    _dueAt = _now().add(await pollOnce(session));
  }

  /// One scheduled poll: re-reads EA11 when due, polls the open windows,
  /// logs what happened and returns how long to wait before the next one.
  Future<Duration> pollOnce(Session session) async {
    final now = _now();
    final read = _electionsRead;
    if (read == null || now.difference(read) >= idleCheck) {
      try {
        await refreshElections();
        _electionsRead = now;
      } on Exception catch (e) {
        session.log('EA11 not refreshed: $e', level: LogLevel.warning);
      }
    }
    final r = await tick(session);
    if (r.recorded > 0 || r.waiting.isNotEmpty || r.errors.isNotEmpty) {
      session.log(
        'Live: ${r.recorded} new, ${r.unchanged} unchanged, '
        'waiting ${r.waiting}, errors ${r.errors}',
        level: r.errors.isEmpty ? LogLevel.info : LogLevel.warning,
      );
    }
    final next = nextDelay();
    if (!elections.any((e) => e.isLiveAt(now))) {
      session.log('Live: no window open; next look in $next.');
    }
    return next;
  }

  /// Reads EA11 again (a conditional GET; 304 when unchanged).
  Future<void> refreshElections() async {
    final r = await _client.fetch(_urls.electionsConfig());
    elections = parseElections(switch (r) {
      Fetched(:final body) => body,
      NotModified(:final cachedBody) => cachedBody,
    });
  }

  Duration nextDelay() {
    final now = _now();
    if (elections.any((e) => e.isLiveAt(now))) return pollEvery;
    final opens = nextLiveWindow(elections, now);
    if (opens == null) return idleCheck;
    final until = opens.difference(now);
    return until < idleCheck ? until : idleCheck;
  }

  Future<LiveTick> tick(Session session) async {
    final now = _now();
    var recorded = 0, unchanged = 0;
    final waiting = <int>[];
    final errors = <String>[];

    for (final e in elections.where((e) => e.isLiveAt(now))) {
      final targets = e.targets;
      if (!_published.contains(e.code)) {
        final after = _probeAfter[e.code];
        if (after != null && now.isBefore(after)) {
          waiting.add(e.code);
          continue;
        }
      }
      for (final (i, (scope, office)) in targets.indexed) {
        final url = _urls.signatureOf(_urls.result(e.code, scope, office));
        try {
          final r = await _client.fetch(url);
          _published.add(e.code);
          switch (r) {
            case NotModified():
              unchanged++;
            case Fetched(:final body):
              final compact = String.fromCharCodes(body);
              final stored = await SnapshotStore.record(
                session,
                origin: DataOrigin.live,
                electionCode: e.code,
                office: office,
                bytes: TseJws.parse(compact).payload,
                jws: compact,
                fetchedAt: now.toUtc(),
              );
              if (stored.isNew) recorded++;
          }
        } on TseNotFound {
          if (i == 0 && !_published.contains(e.code)) {
            _probeAfter[e.code] = now.add(probeBackoff);
            waiting.add(e.code);
            break;
          }
          errors.add('404 $url');
        } on TseBackingOff catch (err) {
          // The client is paused (a 404 or a block): stop this poll.
          errors.add('$err');
          return LiveTick(
            recorded: recorded,
            unchanged: unchanged,
            waiting: waiting,
            errors: errors,
          );
        } on TseException catch (err) {
          errors.add('$err');
        } on FormatException catch (err) {
          errors.add('$url: ${err.message}');
        }
      }
    }
    return LiveTick(
      recorded: recorded,
      unchanged: unchanged,
      waiting: waiting,
      errors: errors,
    );
  }
}

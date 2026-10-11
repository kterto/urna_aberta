import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart' hide Scope;
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../tse/tse_client.dart';
import 'report_builder.dart';
import 'report_csv.dart';
import 'report_pdf.dart';
import 'report_plan.dart';

/// Reports: quoting a spec, queuing it, building it in the background one
/// at a time, and handing out its files.
class ReportService {
  ReportService({
    required this.planner,
    required this.builder,
    required this.ratePerSecond,
    Uri? webBase,
    Future<void> Function()? schedule,
    DateTime Function()? now,
  }) : webBase = webBase ?? Uri.parse('http://localhost:8082/'),
       _schedule = schedule ?? (() async {}),
       _now = now ?? DateTime.now;

  /// The web server's public address, for links.
  final Uri webBase;

  final ReportPlanner planner;
  final ReportBuilder builder;

  /// The TSE client's rate, for the time estimate.
  final double ratePerSecond;

  /// Asks for [drain] to run soon, outside the request (a FutureCall).
  final Future<void> Function() _schedule;
  final DateTime Function() _now;

  /// Private storage, so a report is read only through its owner or its
  /// public link while published.
  static const storageId = 'private';

  /// How often progress is saved and sent while a report is built.
  static const progressEvery = Duration(seconds: 1);

  static String channel(int id) => 'relatorio-$id';

  static String filePath(int id, String format) =>
      'relatorios/$id/relatorio.$format';

  /// The report's formats, by extension.
  static const formats = {
    'pdf': 'application/pdf',
    'csv': 'text/csv; charset=utf-8',
  };

  /// Queues [spec] for the viewer. Refused when it names anything TSE does
  /// not list, reads more than [ReportPlanner.fileLimit] files, or the
  /// viewer already has a report waiting or running.
  Future<ReportRequest> request(Session session, ReportSpec spec) async {
    final owner = session.authenticated!.authUserId;
    final plan = await planner.plan(spec);
    final pending = await ReportRequest.db.count(
      session,
      where: (t) =>
          t.authUserId.equals(owner) &
          t.status.inSet({ReportStatus.queued, ReportStatus.running}),
    );
    if (pending > 0) {
      throw ReportRefused(
        message: 'Você já tem um relatório na fila. Espere ele terminar.',
        reason: 'busy',
      );
    }
    final request = await ReportRequest.db.insertRow(
      session,
      ReportRequest(
        authUserId: owner,
        spec: spec,
        status: ReportStatus.queued,
        filesDone: 0,
        filesTotal: plan.files,
        placeNames: {
          for (final i in plan.items) i.placeName,
        }.toList(),
        createdAt: _now().toUtc(),
      ),
    );
    try {
      await _schedule();
    } catch (_) {
      // Nothing would ever run it, and it would hold the viewer's one slot.
      await ReportRequest.db.deleteRow(session, request);
      rethrow;
    }
    return request;
  }

  /// The viewer's reports, newest first.
  Future<List<ReportRequest>> list(Session session) => ReportRequest.db.find(
    session,
    where: (t) => t.authUserId.equals(session.authenticated!.authUserId),
    orderBy: (t) => t.createdAt.desc(),
  );

  /// The viewer's report [id]: its current state, then every change until
  /// it is ready or failed.
  Stream<ReportRequest> follow(Session session, int id) async* {
    final updates = session.messages.createStream<ReportRequest>(channel(id));
    // Read after subscribing, so no change falls between the two.
    var current = await _owned(session, id);
    yield current;
    if (_finished(current)) return;
    await for (final r in updates) {
      if (r.filesDone < current.filesDone && r.status == current.status) {
        continue;
      }
      current = r;
      yield r;
      if (_finished(r)) return;
    }
  }

  /// One of the viewer's ready reports, in [format].
  Future<ByteData> download(Session session, int id, String format) async {
    final r = await _owned(session, id);
    return _file(session, r, format);
  }

  /// How long a download link works.
  static const linkLifetime = Duration(minutes: 10);

  /// Signs download links; new on every start, so a restart only ends the
  /// links already handed out.
  final _linkKey = List<int>.generate(32, (_) => _random.nextInt(256));

  /// A link anyone holding it can download one of the viewer's ready
  /// reports from, for [linkLifetime]: `/d/<payload>.<signature>`. Lets
  /// every platform download through the browser.
  Future<String> downloadLink(Session session, int id, String format) async {
    final r = await _owned(session, id);
    if (r.status != ReportStatus.ready || !formats.containsKey(format)) {
      throw ReportRefused(
        message: 'Este relatório não tem o arquivo $format.',
        reason: 'notFound',
      );
    }
    final expires = _now().add(linkLifetime).millisecondsSinceEpoch ~/ 1000;
    final payload = '$id.$format.$expires';
    final token = '${_b64(utf8.encode(payload))}.${_b64(_sign(payload))}';
    return webBase.resolve('d/$token').toString();
  }

  /// The report and format a download link names, while it is valid.
  (int, String)? openLink(String token) {
    final parts = token.split('.');
    if (parts.length != 2) return null;
    final String payload;
    final List<int> signature;
    try {
      payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[0])));
      signature = base64Url.decode(base64Url.normalize(parts[1]));
    } on FormatException {
      return null;
    }
    final expected = _sign(payload);
    var diff = expected.length ^ signature.length;
    for (var i = 0; i < expected.length && i < signature.length; i++) {
      diff |= expected[i] ^ signature[i];
    }
    if (diff != 0) return null;
    final fields = payload.split('.');
    if (fields.length != 3) return null;
    final id = int.tryParse(fields[0]);
    final expires = int.tryParse(fields[2]);
    if (id == null || expires == null) return null;
    if (_now().millisecondsSinceEpoch ~/ 1000 > expires) return null;
    return (id, fields[1]);
  }

  /// The file a valid download link names; null otherwise.
  Future<ByteData?> linkedFile(Session session, String token) async {
    final opened = openLink(token);
    if (opened == null) return null;
    final (id, format) = opened;
    final r = await ReportRequest.db.findById(session, id);
    if (r == null || r.status != ReportStatus.ready) return null;
    return _file(session, r, format);
  }

  /// The public page of the viewer's published report; null when it is not
  /// published.
  Future<String?> publicLink(Session session, int id) async {
    final r = await _owned(session, id);
    return r.publicToken == null
        ? null
        : webBase.resolve('r/${r.publicToken}').toString();
  }

  List<int> _sign(String payload) =>
      Hmac(sha256, _linkKey).convert(utf8.encode(payload)).bytes;

  static String _b64(List<int> bytes) =>
      base64Url.encode(bytes).replaceAll('=', '');

  /// Gives a ready report a public link, or takes it away.
  Future<ReportRequest> publish(Session session, int id, bool public) async {
    final r = await _owned(session, id);
    if (r.status != ReportStatus.ready) {
      throw ReportRefused(
        message: 'Só um relatório pronto pode ser publicado.',
        reason: 'invalidRequest',
      );
    }
    if (public == (r.publicToken != null)) return r;
    return ReportRequest.db.updateRow(
      session,
      r.copyWith(publicToken: public ? _token() : null),
    );
  }

  /// Deletes the viewer's report and its files.
  Future<void> delete(Session session, int id) async {
    final r = await _owned(session, id);
    if (r.status == ReportStatus.running) {
      throw ReportRefused(
        message: 'Espere o relatório terminar para apagá-lo.',
        reason: 'busy',
      );
    }
    for (final format in formats.keys) {
      await session.storage.deleteFile(
        storageId: storageId,
        path: filePath(id, format),
      );
    }
    await ReportRequest.db.deleteRow(session, r);
  }

  /// A published report, by its public token; null when there is none.
  Future<ReportRequest?> published(Session session, String token) =>
      ReportRequest.db.findFirstRow(
        session,
        where: (t) =>
            t.publicToken.equals(token) & t.status.equals(ReportStatus.ready),
      );

  /// A published report's file, by its public token; null when there is
  /// no such report or format.
  Future<ByteData?> publishedFile(
    Session session,
    String token,
    String format,
  ) async {
    if (!formats.containsKey(format)) return null;
    final r = await published(session, token);
    return r == null ? null : _file(session, r, format);
  }

  /// Builds every queued report, oldest first, one at a time on this
  /// server. Called by the FutureCall [_schedule] starts.
  Future<void> drain(Session session) => _running = _running.then(
    (_) => _drainNow(session),
    onError: (_) => _drainNow(session),
  );

  Future<void> _running = Future.value();

  Future<void> _drainNow(Session session) async {
    while (true) {
      final next = await ReportRequest.db.findFirstRow(
        session,
        where: (t) => t.status.equals(ReportStatus.queued),
        orderBy: (t) => t.createdAt,
      );
      if (next == null) return;
      await _build(session, next);
    }
  }

  /// After a restart: a report left running is queued again. Returns
  /// whether any report is waiting.
  Future<bool> recover(Session session) async {
    final stuck = await ReportRequest.db.find(
      session,
      where: (t) => t.status.equals(ReportStatus.running),
    );
    for (final r in stuck) {
      await ReportRequest.db.updateRow(
        session,
        r.copyWith(status: ReportStatus.queued, filesDone: 0),
      );
    }
    return await ReportRequest.db.count(
          session,
          where: (t) => t.status.equals(ReportStatus.queued),
        ) >
        0;
  }

  Future<void> _build(Session session, ReportRequest request) async {
    var r = await _save(
      session,
      request.copyWith(
        status: ReportStatus.running,
        startedAt: _now().toUtc(),
        filesDone: 0,
      ),
    );
    var lastSaved = _now();
    // Progress is saved in order, and always before the outcome: a late
    // progress write would otherwise put a finished report back to running.
    var progressWrites = Future<void>.value();
    try {
      final plan = await planner.plan(r.spec);
      r = await _save(session, r.copyWith(filesTotal: plan.files));
      final tables = await builder.build(
        session,
        plan,
        onProgress: (done, total) {
          if (_now().difference(lastSaved) < progressEvery) return;
          lastSaved = _now();
          final snapshot = r = r.copyWith(filesDone: done);
          // Sent as it happens; saved for whoever reconnects.
          session.messages.postMessage(channel(r.id!), snapshot).ignore();
          progressWrites = progressWrites.then(
            (_) => ReportRequest.db.updateRow(session, snapshot),
          );
        },
      );
      await progressWrites;
      // Every file is read; what is left is writing the report.
      r = await _save(session, r.copyWith(filesDone: plan.files));
      final finishedAt = _now().toUtc();
      final (:csv, :dataSha256, :pdf) = await _render(r, tables, finishedAt);
      for (final (format, bytes) in [('csv', csv), ('pdf', pdf)]) {
        await session.storage.storeFile(
          storageId: storageId,
          path: filePath(r.id!, format),
          byteData: ByteData.sublistView(Uint8List.fromList(bytes)),
        );
      }
      r = await _save(
        session,
        r.copyWith(
          status: ReportStatus.ready,
          filesDone: plan.files,
          finishedAt: finishedAt,
          sha256: dataSha256,
        ),
      );
    } on Exception catch (e, st) {
      await progressWrites.catchError((_) {});
      final reason = switch (e) {
        ReportRefused(:final reason) => reason,
        ResultUnavailable() ||
        SectionUnavailableException() ||
        TseException() => 'tseUnavailable',
        _ => 'internal',
      };
      if (reason == 'internal') {
        session.log(
          'Relatório ${r.id} falhou: $e',
          level: LogLevel.error,
          exception: e,
          stackTrace: st,
        );
      }
      await _save(
        session,
        r.copyWith(
          status: ReportStatus.failed,
          errorReason: reason,
          finishedAt: _now().toUtc(),
        ),
      );
    }
  }

  /// The report's CSV, its hash and its PDF, written on another isolate:
  /// Brazil by municipality keeps the CPU for tens of seconds, and a server
  /// that stops answering its health checks for that long is restarted.
  static Future<({List<int> csv, String dataSha256, List<int> pdf})> _render(
    ReportRequest request,
    List<ReportTable> tables,
    DateTime generatedAt,
  ) => Isolate.run(() async {
    final csv = reportCsv(tables);
    final dataSha256 = sha256.convert(csv).toString();
    final pdf = await reportPdf(
      request: request,
      tables: tables,
      dataSha256: dataSha256,
      generatedAt: generatedAt,
      fonts: await ReportFonts.load(),
    );
    return (csv: csv, dataSha256: dataSha256, pdf: pdf);
  });

  Future<ReportRequest> _save(Session session, ReportRequest r) async {
    final saved = await ReportRequest.db.updateRow(session, r);
    await session.messages.postMessage(channel(saved.id!), saved);
    return saved;
  }

  Future<ByteData> _file(Session session, ReportRequest r, String format) {
    if (r.status != ReportStatus.ready || !formats.containsKey(format)) {
      throw ReportRefused(
        message: 'Este relatório não tem o arquivo $format.',
        reason: 'notFound',
      );
    }
    return session.storage.retrieveFile(
      storageId: storageId,
      path: filePath(r.id!, format),
    );
  }

  Future<ReportRequest> _owned(Session session, int id) async {
    final r = await ReportRequest.db.findById(session, id);
    if (r == null || r.authUserId != session.authenticated!.authUserId) {
      throw ReportRefused(
        message: 'Relatório não encontrado.',
        reason: 'notFound',
      );
    }
    return r;
  }

  static bool _finished(ReportRequest r) =>
      r.status == ReportStatus.ready || r.status == ReportStatus.failed;

  static final _random = Random.secure();

  /// 128 random bits, URL-safe.
  static String _token() => base64Url
      .encode(List<int>.generate(16, (_) => _random.nextInt(256)))
      .replaceAll('=', '');

  Future<ReportQuote> quote(Session session, ReportSpec spec) async {
    final plan = await planner.plan(spec);
    final stored = await _stored(session, plan);
    return ReportQuote(
      files: plan.files,
      stored: stored,
      seconds: ((plan.files - stored) / ratePerSecond).ceil(),
      limit: ReportPlanner.fileLimit,
      tables: plan.tables,
      sectionsWithoutFiles: plan.sectionsWithoutFiles,
    );
  }

  /// Plans [spec] and reads every file it needs into its tables.
  Future<List<ReportTable>> build(
    Session session,
    ReportSpec spec, {
    void Function(int done, int total)? onProgress,
  }) async =>
      builder.build(session, await planner.plan(spec), onProgress: onProgress);

  /// Files of [plan] already stored: a result file of that scope, or a
  /// looked-up section (its three files).
  Future<int> _stored(Session session, ReportPlan plan) async {
    var stored = 0;
    final results = <(int, int), Set<String>>{};
    for (final r in plan.results) {
      results
          .putIfAbsent((r.election, r.office.code), () => {})
          .add(
            r.scope.code,
          );
    }
    for (final MapEntry(key: (election, office), value: scopes)
        in results.entries) {
      final rows = await ResultFile.db.find(
        session,
        where: (t) =>
            t.electionCode.equals(election) &
            t.officeCode.equals(office) &
            t.scopeCode.inSet(scopes),
      );
      stored += {for (final r in rows) r.scopeCode}.length;
    }

    final sections = <(int, String), Set<(int, int, int)>>{};
    for (final s in plan.sections) {
      sections.putIfAbsent((s.pleito, s.id.uf), () => {}).add((
        s.id.municipio,
        s.id.zona,
        s.id.secao,
      ));
    }
    for (final MapEntry(key: (pleito, uf), value: ids) in sections.entries) {
      final rows = await SectionCheck.db.find(
        session,
        where: (t) =>
            t.pleito.equals(pleito) &
            t.uf.equals(uf) &
            t.municipio.inSet({for (final (m, _, _) in ids) m}),
      );
      stored +=
          3 *
          rows
              .where((r) => ids.contains((r.municipio, r.zona, r.secao)))
              .length;
    }
    return stored;
  }
}

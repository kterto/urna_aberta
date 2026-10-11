import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/cache_busting.dart';
import 'src/generated/serverpod.dart';
import 'src/health/health_indicators.dart';
import 'src/live/elections.dart';
import 'src/live/live_ingestor.dart';
import 'src/live/live_poll_call.dart';
import 'src/meu_local/meu_local_endpoint.dart';
import 'src/replay/fixture_seeder.dart';
import 'src/reports/relatorios_endpoint.dart';
import 'src/reports/report_call.dart';
import 'src/reports/report_builder.dart';
import 'src/reports/report_plan.dart';
import 'src/reports/report_service.dart';
import 'src/results/resultados_endpoint.dart';
import 'src/results/results_service.dart';
import 'src/secao/secao_endpoint.dart';
import 'src/secao/section_directories.dart';
import 'src/secao/section_service.dart';
import 'src/tse/token_bucket.dart';
import 'src/tse/tse_client.dart';
import 'src/tse/tse_urls.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/public_report_route.dart';
import 'src/web/routes/root.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // One rate-limited TSE client for the whole server, well under the
  // 100 req/s per-IP limit.
  final tse = TseClient(
    http: IoTseHttp(),
    bucket: TokenBucket(ratePerSecond: 20, burst: 5),
  );
  final replay = ReplayIndicator();

  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code. Besides the database, /readyz
  // reports whether TSE requests are paused, and /startupz waits for the
  // replay files.
  final pod = Serverpod(
    args,
    configOverride: _scheduleFutureCalls,
    healthConfig: HealthConfig(
      additionalReadinessIndicators: [TseIndicator(tse)],
      additionalStartupIndicators: [replay],
    ),
  );

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      // The default setup works with Serverpod Cloud without configuration. In
      // development the verification codes are logged to the console, and in
      // staging and production they are sent through the Serverpod Cloud email
      // service. If you want to use a custom provider for sending emails, use
      // `EmailIdpConfigFromPasswords`.
      ServerpodCloudEmailIdpConfig(
        appDisplayName: 'urna_aberta',
      ),
    ],
  );

  // The site root opens the app.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve all files in the web/static relative directory under /web.
  // These are used by the default web page.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // If building the Flutter app with WASM, set the below parameter to
        // true and add the --wasm flag to the flutter build command.
        enableWasmHeaders: false,
      ),
      '/app',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    final defaultRoute = StaticRoute.file(
      File(
        Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
      ),
    );

    pod.webServer.addRoute(
      defaultRoute,
      '/app/**',
    );
  }

  // Configure cloud storage.
  // This setup works with Serverpod Cloud without extra configuration.
  // If you want to use a custom provider for cloud storage, replace these
  // with your preferred provider.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  final urls = TseUrls.oficial();
  // Section configs per pleito, each read once per UF.
  final directories = <int, SectionDirectories>{};
  SectionDirectories sectionDirectories(int pleito, int year) =>
      directories[pleito] ??= SectionDirectories(
        client: tse,
        urls: TseUrls.oficial(year: year),
        pleito: pleito,
        archive: _archive,
      );
  final sectionServices = <int, SectionService>{};
  SectionService sectionService(int pleito, int year) =>
      sectionServices[pleito] ??= SectionService(
        client: tse,
        urls: TseUrls.oficial(year: year),
        directory: sectionDirectories(pleito, year).call,
        pleito: pleito,
      );
  MeuLocalEndpoint.sections = SecaoEndpoint.service = sectionService(
    3220,
    2026,
  );

  final live = _liveIngestor(tse, urls);
  // EA11 as the live poller last read it, else as archived.
  final archivedElections = _archivedElections();
  final results = ResultadosEndpoint.service = ResultsService(
    client: tse,
    elections: () => live?.elections ?? archivedElections,
  );
  final reports = RelatoriosEndpoint.service = ReportService(
    planner: ReportPlanner(
      elections: () => live?.elections ?? archivedElections,
      municipalities: results.municipalities,
      sections: (pleito, year, uf) => sectionDirectories(pleito, year)(uf),
    ),
    builder: ReportBuilder.fromServices(results, sectionService),
    ratePerSecond: 20,
    webBase: _webBase(pod.config.webServer),
    schedule: () =>
        pod.futureCalls.callWithDelay(Duration.zero).reportCall.drain(),
  );
  ReportCall.service = reports;
  pod.webServer.addRoute(PublicReportRoute(reports), '/r/**');
  pod.webServer.addRoute(ReportDownloadRoute(reports), '/d/**');

  // Start the server.
  await pod.start();

  await _seedReplayFixtures(pod, replay);
  await _resumeReports(pod, reports);

  if (live != null) {
    LivePollCall.ingestor = live;
    final session = await pod.createSession();
    try {
      await pod.futureCalls.cancel(LivePollCall.id);
      await pod.futureCalls
          .callRecurring(identifier: LivePollCall.id)
          .every(LiveIngestor.pollEvery, start: DateTime.now().toUtc())
          .livePollCall
          .poll();
      session.log('Live polling scheduled.');
    } catch (e, st) {
      session.log(
        'Live polling not scheduled: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: st,
      );
    } finally {
      await session.close();
    }
  }
}

/// Live polling and the report queue are FutureCalls, so scheduling them
/// must stay on. Serverpod 4.0.3 added `futureCall.enabled` (off stops
/// every schedule call), and on Serverpod Cloud it came up off once this
/// project moved from 4.0.0 to 4.0.4. Running them is still up to
/// `futureCallExecutionEnabled`.
ServerpodConfig _scheduleFutureCalls(ServerpodConfig config) {
  final f = config.futureCall;
  if (f.enabled) return config;
  stdout.writeln(
    'futureCall.enabled was off '
    '(SERVERPOD_FUTURE_CALL_ENABLED='
    '${Platform.environment['SERVERPOD_FUTURE_CALL_ENABLED']}, '
    'executionEnabled=${config.futureCallExecutionEnabled}); '
    'turning scheduling on.',
  );
  return config.copyWith(
    futureCall: FutureCallConfig(
      concurrencyLimit: f.concurrencyLimit,
      scanInterval: f.scanInterval,
      checkBrokenCalls: f.checkBrokenCalls,
      deleteBrokenCalls: f.deleteBrokenCalls,
      enabled: true,
    ),
  );
}

/// The archived 1st-round files: the repository's `fixtures/` in development,
/// a copy in `web/archive/` on Serverpod Cloud, which uploads only this
/// package and keeps only `config/`, `web/` and `migrations/` at runtime.
/// No route serves `web/archive/`.
final Directory _archive =
    [
      Directory('../fixtures/2026-1t'),
      Directory('web/archive/2026-1t'),
    ].firstWhere(
      (d) => d.existsSync(),
      orElse: () => Directory('web/archive/2026-1t'),
    );

List<Election> _archivedElections() {
  final f = File('${_archive.path}/oficial/comum/config/ele-c.json');
  return f.existsSync() ? parseElections(f.readAsBytesSync()) : const [];
}

/// Election-night polling of TSE, on unless `URNA_LIVE=off`. Outside a
/// live window it only re-reads EA11 every few hours.
LiveIngestor? _liveIngestor(TseClient tse, TseUrls urls) {
  if (Platform.environment['URNA_LIVE'] == 'off') return null;
  final live = LiveIngestor(client: tse, urls: urls);
  // Known elections until the first EA11 refresh succeeds.
  final archived = File('${_archive.path}/oficial/comum/config/ele-c.json');
  if (archived.existsSync()) {
    live.elections = parseElections(archived.readAsBytesSync());
  }
  return live;
}

/// Stores the archived 1st-round files so the replay works offline.
Future<void> _seedReplayFixtures(Serverpod pod, ReplayIndicator replay) async {
  final root = _archive;
  final session = await pod.createSession();
  var outcome = 'Replay fixtures failed to load.';
  try {
    if (!root.existsSync()) {
      outcome = 'Replay fixtures not found at ${root.path}; replay is off.';
      session.log(outcome);
      return;
    }
    final added = await FixtureSeeder.seed(session, root);
    outcome = 'Replay fixtures: $added new snapshots from ${root.path}.';
    session.log(outcome);
  } catch (e, st) {
    session.log(
      outcome,
      level: LogLevel.error,
      exception: e,
      stackTrace: st,
    );
  } finally {
    replay.stored(outcome);
    await session.close();
  }
}

/// Reports left running by a restart are queued again, and the queue is
/// drained if anything waits.
Future<void> _resumeReports(Serverpod pod, ReportService reports) async {
  final session = await pod.createSession();
  try {
    if (await reports.recover(session)) {
      await pod.futureCalls.callWithDelay(Duration.zero).reportCall.drain();
    }
  } catch (e, st) {
    session.log(
      'Reports not resumed: $e',
      level: LogLevel.error,
      exception: e,
      stackTrace: st,
    );
  } finally {
    await session.close();
  }
}

/// The web server's public address, for links handed to viewers.
Uri _webBase(ServerConfig? web) {
  if (web == null) return Uri.parse('http://localhost:8082/');
  final port = switch ((web.publicScheme, web.publicPort)) {
    ('https', 443) || ('http', 80) => null,
    (_, final p) => p,
  };
  return Uri(
    scheme: web.publicScheme,
    host: web.publicHost,
    port: port,
    path: '/',
  );
}

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';

/// Archives the 1st-round 2026 TSE files used by the replay demo.
///
/// Usage: dart run bin/archive_fixtures.dart [output-dir]
///
/// Stays at 20 req/s through [TseClient] and stops at the first error so a
/// bad pattern never turns into a run of 404s. Each file is written under its
/// URL path, and `manifest.json` records URL, SHA-256, size and HTTP
/// validators for every file.
Future<void> main(List<String> args) async {
  final out = Directory(args.isEmpty ? '../fixtures/2026-1t' : args.first);
  const pleito = 3220, federal = 6257, estadual = 6259;
  final urls = TseUrls.oficial();
  final ufs = Scope.ufs.where((u) => u != 'zz').toList();

  final targets = <Uri>[
    urls.electionsConfig(),
    urls.municipalitiesConfig(federal),
    urls.municipalitiesConfig(estadual),
    urls.brazilTracking(federal),
    urls.result(federal, Scope.brazil(), Office.presidente),
    for (final uf in Scope.ufs) urls.result(federal, Scope.uf(uf), Office.presidente),
    for (final uf in Scope.ufs) urls.ufTracking(federal, uf),
    for (final uf in ufs) urls.result(estadual, Scope.uf(uf), Office.governador),
    for (final uf in ufs) urls.result(estadual, Scope.uf(uf), Office.senador),
    for (final uf in Scope.ufs) urls.sectionConfig(pleito, uf),
  ];

  final http = IoTseHttp();
  final client = TseClient(
    http: http,
    bucket: TokenBucket(ratePerSecond: 20, burst: 5),
  );
  final manifest = <Map<String, Object?>>[];
  var bytes = 0;
  try {
    for (final (i, uri) in targets.indexed) {
      final r = await client.fetch(uri);
      if (r is! Fetched) throw StateError('unexpected $r for $uri');
      final file = File('${out.path}${uri.path}');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(r.body);
      bytes += r.body.length;
      manifest.add({
        'url': uri.toString(),
        'path': uri.path.substring(1),
        'sha256': sha256.convert(r.body).toString(),
        'bytes': r.body.length,
        'etag': r.etag,
        'lastModified': r.lastModified,
        'fetchedAt': DateTime.now().toUtc().toIso8601String(),
      });
      stdout.writeln('[${i + 1}/${targets.length}] ${r.body.length} B ${uri.path}');
    }
  } on TseException catch (e) {
    stderr.writeln('Stopped: $e');
    exitCode = 1;
  } finally {
    http.close();
    await File('${out.path}/manifest.json').writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'source': 'TSE, resultados.tse.jus.br (ambiente oficial)',
        'pleito': pleito,
        'elections': {'federal': federal, 'estadual': estadual},
        'complete': exitCode == 0,
        'files': manifest,
      }),
    );
    stdout.writeln('${manifest.length} files, ${(bytes / 1e6).toStringAsFixed(1)} MB → ${out.path}');
  }
}

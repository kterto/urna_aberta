import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:urna_aberta_server/src/secao/aux_file.dart';
import 'package:urna_aberta_server/src/secao/section_directory.dart';
import 'package:urna_aberta_server/src/tse/ea12.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

/// Archives what the report tests sum, so each sum can be checked against
/// TSE's own total:
///
/// - EA12 for election 6257, signed (`mun-e006257-cm.jws`);
/// - President in each of the 22 AC cities (their sum must equal the AC
///   file);
/// - every section of Porto Walter (AC 01066), zona 0004: aux file, BU and
///   signature file (their sum must equal the Porto Walter file).
///
/// Files already archived are read, not fetched again.
///
/// Usage: dart run bin/archive_report_fixtures.dart
///
/// URLs come only from the archived EA12, the section config and each aux
/// file. 5 req/s; stops at the first error.
Future<void> main() async {
  const root = '../fixtures/2026-1t';
  final urls = TseUrls.oficial();
  final http = IoTseHttp();
  final client = TseClient(
    http: http,
    bucket: TokenBucket(ratePerSecond: 5, burst: 2),
  );
  final manifestFile = File('$root/manifest-reports.json');
  // Entries of earlier runs, by URL; files archived without one get an
  // entry rebuilt from their bytes (no HTTP validators).
  final previous = {
    if (manifestFile.existsSync())
      for (final f
          in (jsonDecode(manifestFile.readAsStringSync())['files'] as List))
        (f as Map<String, Object?>)['url']: f,
  };
  final manifest = <Map<String, Object?>>[];

  Future<List<int>> save(Uri uri, {bool signed = false}) async {
    final archived = File('$root${uri.path}');
    if (archived.existsSync()) {
      final body = archived.readAsBytesSync();
      manifest.add(
        previous['$uri'] ??
            {
              'url': uri.toString(),
              'path': uri.path.substring(1),
              'sha256': sha256.convert(body).toString(),
              'bytes': body.length,
            },
      );
      return body;
    }
    final r = await client.fetch(uri);
    if (r is! Fetched) throw StateError('unexpected $r for $uri');
    if (signed) {
      final check = await checkJws(TseJws.parse(utf8.decode(r.body)));
      if (check != JwsCheck.valid) throw StateError('$check signature: $uri');
    }
    final file = File('$root${uri.path}');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(r.body);
    manifest.add({
      'url': uri.toString(),
      'path': uri.path.substring(1),
      'sha256': sha256.convert(r.body).toString(),
      'bytes': r.body.length,
      'etag': r.etag,
      'lastModified': r.lastModified,
      'fetchedAt': DateTime.now().toUtc().toIso8601String(),
    });
    stdout.writeln('[${manifest.length}] ${r.body.length} B ${uri.path}');
    return r.body;
  }

  try {
    final ea12 = await save(urls.municipalitiesConfigJws(6257), signed: true);
    final cities = parseEa12(TseJws.parse(utf8.decode(ea12)).payload);
    for (final m in cities.byUf['ac']!) {
      await save(
        urls.resultJws(
          6257,
          Scope.municipality('ac', m.code),
          Office.presidente,
        ),
        signed: true,
      );
    }
    await save(
      urls.resultJws(6259, Scope.municipality('ac', 1066), Office.governador),
      signed: true,
    );

    final dir = parseSectionConfig(
      File(
        '$root${urls.sectionConfig(3220, 'ac').path}',
      ).readAsBytesSync(),
    );
    for (final s in dir.secoes(1066, 4)) {
      final id = SectionId(uf: 'ac', municipio: 1066, zona: 4, secao: s);
      final aux = parseAux(await save(urls.sectionAux(3220, id)));
      final entry = aux.entries
          .where((e) => e.status == 'Totalizado')
          .firstOrNull;
      if (entry == null) continue;
      for (final kind in ['bu', 'vota']) {
        final name = entry.files[kind];
        if (name != null) {
          await save(urls.urnaFile(3220, id, entry.hash, name));
        }
      }
    }
  } on Object catch (e) {
    stderr.writeln('Stopped: $e');
    exitCode = 1;
  } finally {
    http.close();
    await manifestFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'source': 'TSE, resultados.tse.jus.br (ambiente oficial)',
        'set': 'reports',
        'complete': exitCode == 0,
        'files': manifest,
      }),
    );
  }
}

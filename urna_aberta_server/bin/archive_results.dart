import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:urna_aberta_server/src/live/elections.dart';
import 'package:urna_aberta_server/src/tse/ea12.dart';
import 'package:urna_aberta_server/src/tse/token_bucket.dart';
import 'package:urna_aberta_server/src/tse/tse_client.dart';
import 'package:urna_aberta_server/src/tse/tse_urls.dart';
import 'package:urna_aberta_server/src/verify/jws.dart';

/// Archives signed result files for every office: the 2026 deputies (all
/// UFs) and the 2024 municipal election (EA12, plus Prefeito and Vereador for
/// the 26 state capitals, both rounds).
///
/// Usage: dart run bin/archive_results.dart [deputados|municipal2024]
///
/// Every URL comes from EA11/EA12 entries, never from a guess. Fetches only
/// `.jws` files (as TSE's own Resultados app does), checks each signature
/// before writing it, stays at 5 req/s and stops at the first error.
Future<void> main(List<String> args) async {
  final set = args.isEmpty ? 'deputados' : args.first;
  final elections = parseElections(
    File(
      '../fixtures/2026-1t/oficial/comum/config/ele-c.json',
    ).readAsBytesSync(),
  );
  Election byCode(int code) => elections.singleWhere((e) => e.code == code);

  final (Directory out, List<Uri> targets) = switch (set) {
    'deputados' => (
      Directory('../fixtures/2026-1t'),
      [
        for (final (scope, office) in byCode(6259).targets)
          if (office.proportional)
            TseUrls.oficial().resultJws(6259, scope, office),
      ],
    ),
    'municipal2024' => (Directory('../fixtures/2024'), _municipal2024(byCode)),
    _ => throw ArgumentError.value(set, 'set'),
  };

  final http = IoTseHttp();
  final client = TseClient(
    http: http,
    bucket: TokenBucket(ratePerSecond: 5, burst: 2),
  );
  // One manifest per set; later runs add to it, keyed by URL.
  final manifestFile = File('${out.path}/manifest-$set.json');
  final previous = manifestFile.existsSync()
      ? [
          for (final f
              in (jsonDecode(manifestFile.readAsStringSync())['files'] as List))
            f as Map<String, Object?>,
        ]
      : <Map<String, Object?>>[];
  final manifest = <Map<String, Object?>>[];
  var bytes = 0;
  try {
    for (final (i, uri) in targets.indexed) {
      final r = await client.fetch(uri);
      if (r is! Fetched) throw StateError('unexpected $r for $uri');
      final check = await checkJws(TseJws.parse(utf8.decode(r.body)));
      if (check != JwsCheck.valid) throw StateError('$check signature: $uri');
      final file = File('${out.path}${uri.path}');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(r.body);
      bytes += r.body.length;
      manifest.add({
        'url': uri.toString(),
        'path': uri.path.substring(1),
        'sha256': sha256.convert(r.body).toString(),
        'bytes': r.body.length,
        'jws': check.name,
        'etag': r.etag,
        'lastModified': r.lastModified,
        'fetchedAt': DateTime.now().toUtc().toIso8601String(),
      });
      stdout.writeln(
        '[${i + 1}/${targets.length}] ${r.body.length} B ${uri.path}',
      );
    }
  } on Object catch (e) {
    stderr.writeln('Stopped: $e');
    exitCode = 1;
  } finally {
    http.close();
    await out.create(recursive: true);
    await manifestFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'source': 'TSE, resultados.tse.jus.br (ambiente oficial), .jws only',
        'set': set,
        'complete': exitCode == 0,
        'files': [
          for (final f in previous)
            if (!manifest.any((m) => m['url'] == f['url'])) f,
          ...manifest,
        ],
      }),
    );
    stdout.writeln(
      '${manifest.length} files, ${(bytes / 1e6).toStringAsFixed(1)} MB → ${manifestFile.path}',
    );
  }
}

/// EA12 for both rounds; Prefeito and Vereador in every capital (from the
/// archived EA12 once it exists), Prefeito in each capital with a 2nd round.
List<Uri> _municipal2024(Election Function(int) byCode) {
  final urls = TseUrls.oficial(year: 2024);
  final configs = [
    urls.municipalitiesConfigJws(619),
    urls.municipalitiesConfigJws(620),
  ];
  final ea12 = File('../fixtures/2024${configs.first.path}');
  if (!ea12.existsSync()) return configs;
  final capitals = _capitals(ea12.readAsStringSync());
  final second = byCode(620).targets.map((t) => t.$1).toSet();
  return [
    for (final c in capitals) ...[
      urls.resultJws(619, c, Office.prefeito),
      urls.resultJws(619, c, Office.vereador),
      if (second.contains(c)) urls.resultJws(620, c, Office.prefeito),
    ],
  ];
}

List<Scope> _capitals(String jws) => [
  for (final m in parseEa12(TseJws.parse(jws).payload).all)
    if (m.capital) Scope.municipality(m.uf, m.code),
];

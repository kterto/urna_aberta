import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../reports/report_service.dart';

/// A published report: `/r/<token>` is a page saying what the report is,
/// with its hash, and `/r/<token>/relatorio.<format>` its file. Anything
/// else, or a report its owner stopped publishing, is a 404.
class PublicReportRoute extends Route {
  PublicReportRoute(this.service);

  final ReportService service;

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final segments = request.url.pathSegments
        .skipWhile((s) => s != 'r')
        .skip(1)
        .where((s) => s.isNotEmpty)
        .toList();
    if (segments.isEmpty || segments.length > 2) return Response.notFound();
    final token = segments.first;
    if (segments.length == 1) {
      final r = await service.published(session, token);
      if (r == null) return Response.notFound();
      return Response.ok(
        body: Body.fromString(publicReportPage(r), mimeType: MimeType.html),
      );
    }
    final match = RegExp(r'^relatorio\.(\w+)$').firstMatch(segments[1]);
    final format = match?[1];
    if (format == null || !ReportService.formats.containsKey(format)) {
      return Response.notFound();
    }
    final data = await service.publishedFile(session, token, format);
    if (data == null) return Response.notFound();
    return reportFileResponse(data, format, token.substring(0, 8));
  }
}

/// A download link from `relatorios.link`: `/d/<token>`, valid for
/// [ReportService.linkLifetime].
class ReportDownloadRoute extends Route {
  ReportDownloadRoute(this.service);

  final ReportService service;

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final token = request.url.pathSegments.lastOrNull ?? '';
    final opened = service.openLink(token);
    if (opened == null) return Response.notFound();
    final data = await service.linkedFile(session, token);
    if (data == null) return Response.notFound();
    return reportFileResponse(data, opened.$2, '${opened.$1}');
  }
}

/// A report file, saved by the browser as `urna-aberta-relatorio-<name>`.
Response reportFileResponse(ByteData data, String format, String name) =>
    Response.ok(
      body: Body.fromData(
        Uint8List.sublistView(data),
        mimeType: MimeType.parse(
          ReportService.formats[format]!.split(';').first,
        ),
        encoding: format == 'csv' ? utf8 : null,
      ),
      headers: Headers.fromMap({
        'content-disposition': [
          'attachment; filename="urna-aberta-relatorio-$name.$format"',
        ],
        'cache-control': ['private, no-store'],
      }),
    );

/// The page of a published report, in Portuguese and English.
String publicReportPage(ReportRequest r) {
  final s = r.spec;
  String esc(Object v) => const HtmlEscape().convert('$v');
  final places = s.places
      .map(
        (p) => [
          p.kind.name,
          ?p.regiao,
          ?p.uf?.toUpperCase(),
          ?p.municipio,
          if (p.zona != null) 'zona ${p.zona}',
          if (p.secao != null) 'seção ${p.secao}',
        ].join(' '),
      )
      .join('; ');
  final files = [
    for (final f in ReportService.formats.keys)
      '<a href="${esc(r.publicToken!)}/relatorio.$f">relatorio.$f</a>',
  ].join(' · ');
  return '''<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex">
<title>Relatório Urna Aberta</title>
<style>
  body { font: 16px/1.5 system-ui, sans-serif; max-width: 40rem; margin: 2rem auto; padding: 0 1rem; color: #1d1d1b; background: #fbfaf7; }
  h1 { font-size: 1.4rem; }
  dt { font-weight: 600; margin-top: .75rem; }
  dd { margin: 0; overflow-wrap: anywhere; }
  code { font-size: .85rem; }
  p.note { color: #55524c; font-size: .9rem; }
  @media (prefers-color-scheme: dark) { body { color: #ece9e2; background: #1a1916; } p.note { color: #a9a49a; } a { color: #9cc3ff; } }
</style>
</head>
<body>
<h1>Relatório Urna Aberta <small>· report</small></h1>
<dl>
  <dt>Eleições · elections</dt><dd>${esc(s.elections.join(', '))}</dd>
  <dt>Cargos · offices</dt><dd>${esc(s.offices.join(', '))}</dd>
  <dt>Locais · places</dt><dd>${esc(places)}</dd>
  <dt>Detalhamento · breakdown</dt><dd>${esc(s.breakdown.name)}</dd>
  <dt>Gerado em · generated</dt><dd>${esc(r.finishedAt!.toUtc().toIso8601String())}</dd>
  <dt>Relatório · report</dt><dd>#${r.id}</dd>
  <dt>SHA-256 dos dados · of the data</dt><dd><code>${esc(r.sha256 ?? '')}</code></dd>
  <dt>Arquivos · files</dt><dd>$files</dd>
</dl>
<p class="note">Dados lidos dos arquivos assinados do TSE; somas feitas pela Urna Aberta são marcadas como tais. Não é uma fonte oficial.<br>
Read from TSE's signed files; sums made by Urna Aberta are marked as such. Not an official source.</p>
<p class="note"><a href="/app/">Urna Aberta</a></p>
</body>
</html>
''';
}

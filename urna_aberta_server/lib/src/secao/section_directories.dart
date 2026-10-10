import 'dart:io';

import '../tse/tse_client.dart';
import '../tse/tse_urls.dart';
import 'section_directory.dart';

/// Section directories per UF, read once: from the archived EA16 file when
/// present, otherwise from TSE through the shared rate-limited client.
class SectionDirectories {
  SectionDirectories({
    required this._client,
    required this._urls,
    required this.pleito,
    this.archive,
  });

  final TseClient _client;
  final TseUrls _urls;
  final int pleito;

  /// Root of an archived round (e.g. `fixtures/2026-1t`), or null.
  final Directory? archive;

  final _cache = <String, Future<SectionDirectory>>{};

  Future<SectionDirectory> call(String uf) {
    final code = Scope.uf(uf).code;
    final pending = _cache[code] ??= _load(code);
    // A failed load is retried on the next call instead of cached.
    pending.ignore();
    return pending.catchError((Object e) {
      _cache.remove(code);
      throw e;
    });
  }

  Future<SectionDirectory> _load(String uf) async {
    final url = _urls.sectionConfig(pleito, uf);
    final archived = archive == null
        ? null
        : File('${archive!.path}${url.path}');
    if (archived != null && archived.existsSync()) {
      return parseSectionConfig(await archived.readAsBytes());
    }
    return switch (await _client.fetch(url)) {
      Fetched(:final body) => parseSectionConfig(body),
      NotModified(:final cachedBody) => parseSectionConfig(cachedBody),
    };
  }
}

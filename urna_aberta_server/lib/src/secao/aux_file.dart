/// EA18: a section's aux file, listing the urna files TSE received for it.
library;

import 'dart:convert';

import '../tse/tse_time.dart';

class AuxFile {
  const AuxFile({
    required this.generatedAt,
    required this.status,
    required this.oficial,
    required this.entries,
  });

  /// When TSE generated this aux file (UTC).
  final DateTime generatedAt;

  /// Section status: Recebida, Não instalada, Não apurada, Anulada, Totalizada.
  final String status;
  final bool oficial;

  /// One entry per urna-file set received (more than one when an urna was
  /// replaced).
  final List<AuxEntry> entries;
}

class AuxEntry {
  const AuxEntry({
    required this.hash,
    required this.receivedAt,
    required this.status,
    required this.files,
  });

  /// Folder name of this set of urna files.
  final String hash;

  /// When TSE received the urna files (UTC).
  final DateTime receivedAt;

  /// Recebido, Totalizado, Rejeitado or Excluído.
  final String status;

  /// File name by type (`bu`, `vota`, `rdv`, `log`).
  final Map<String, String> files;
}

/// Throws [FormatException] when a required field is missing.
AuxFile parseAux(List<int> bytes) {
  final json = jsonDecode(utf8.decode(bytes));
  if (json is! Map<String, dynamic> || json['hashes'] is! List) {
    throw const FormatException('EA18: not an aux file');
  }
  return AuxFile(
    generatedAt: parseTseDateTime(json['dg'], json['hg'], what: 'EA18 dg/hg'),
    status: _str(json['st'], 'st'),
    oficial: json['f'] == 'o',
    entries: [
      for (final h in json['hashes'] as List)
        if (h is Map<String, dynamic>)
          AuxEntry(
            hash: _str(h['hash'], 'hash'),
            receivedAt: parseTseDateTime(h['dr'], h['hr'], what: 'EA18 dr/hr'),
            status: _str(h['st'], 'hashes.st'),
            files: {
              for (final a in (h['arq'] as List?) ?? const [])
                if (a is Map<String, dynamic>)
                  _str(a['tp'], 'arq.tp'): _str(a['nm'], 'arq.nm'),
            },
          )
        else
          throw const FormatException('EA18: hash entry is not an object'),
    ],
  );
}

String _str(Object? v, String field) =>
    v is String ? v : throw FormatException('EA18: $field missing');

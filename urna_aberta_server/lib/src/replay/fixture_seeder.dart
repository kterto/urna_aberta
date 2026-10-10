import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../ingestion/snapshot_store.dart';
import '../tse/tse_urls.dart';

/// Loads archived EA20 files (`fixtures/<round>/manifest.json`) as replay
/// snapshots, each checked against its archived `.jws` when present. Other
/// archived files are left alone.
abstract final class FixtureSeeder {
  static final _ea20 = RegExp(
    r'/(\d+)/dados/[a-z]+/[a-z]+-c(\d{4})-e\d{6}-u\.json$',
  );

  /// Returns how many snapshots were new; reseeding the same files adds none.
  static Future<int> seed(Session session, Directory root) async {
    final manifest =
        jsonDecode(
              await File('${root.path}/manifest.json').readAsString(),
            )
            as Map<String, dynamic>;
    var added = 0;
    for (final entry in manifest['files'] as List) {
      final file = entry as Map<String, dynamic>;
      final path = file['path'] as String;
      final m = _ea20.firstMatch('/$path');
      if (m == null) continue;
      final officeCode = int.parse(m.group(2)!);
      final signature = File(
        '${root.path}/${path.substring(0, path.length - 5)}.jws',
      );
      final r = await SnapshotStore.record(
        session,
        origin: DataOrigin.replay,
        electionCode: int.parse(m.group(1)!),
        office: Office.values.firstWhere((o) => o.code == officeCode),
        bytes: await File('${root.path}/$path').readAsBytes(),
        jws: signature.existsSync() ? await signature.readAsString() : null,
        fetchedAt: DateTime.parse(file['fetchedAt'] as String),
      );
      if (r.isNew) added++;
    }
    return added;
  }
}

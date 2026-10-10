import 'package:serverpod/serverpod.dart' hide Scope;

import '../generated/protocol.dart';
import '../tse/tse_urls.dart';

/// Verificar: how each stored TSE result file's signature checked out, and
/// the signed files themselves so the app can check them again on its own.
class VerificarEndpoint extends Endpoint {
  static final _urls = TseUrls.oficial();

  /// The newest stored version of each result file: President (Brazil,
  /// then UFs and exterior), then Governor, then Senator.
  Future<List<FileVerification>> arquivos(Session session) async {
    final rows = await ResultSnapshot.db.find(
      session,
      orderBy: (t) => t.tseGeneratedAt.desc(),
    );
    final newest = <(int, int, String), ResultSnapshot>{};
    for (final r in rows) {
      final key = (r.electionCode, r.officeCode, r.scopeCode);
      final kept = newest[key];
      // Same TSE generation from two origins: the live fetch wins.
      if (kept == null ||
          (kept.tseGeneratedAt == r.tseGeneratedAt &&
              r.origin == DataOrigin.live)) {
        newest[key] = r;
      }
    }
    final ordered = newest.values.toList()
      ..sort((a, b) {
        final byOffice = a.officeCode.compareTo(b.officeCode);
        if (byOffice != 0) return byOffice;
        if (a.scopeCode == 'br' || b.scopeCode == 'br') {
          return a.scopeCode == 'br' ? -1 : 1;
        }
        return a.scopeCode.compareTo(b.scopeCode);
      });
    return [for (final r in ordered) _info(r)];
  }

  /// The stored `.jws` of one file, exactly as TSE served it.
  Future<String> jws(Session session, int snapshotId) async {
    final row = await ResultSnapshot.db.findById(session, snapshotId);
    final compact = row?.jws;
    if (compact == null) {
      throw FileNotStoredException(
        message: 'Nenhum arquivo assinado guardado com o id $snapshotId.',
      );
    }
    return compact;
  }

  static FileVerification _info(ResultSnapshot r) {
    final scope = r.scopeCode == 'br' ? Scope.brazil() : Scope.uf(r.scopeCode);
    final office = Office.values.firstWhere((o) => o.code == r.officeCode);
    final url = _urls.signatureOf(_urls.result(r.electionCode, scope, office));
    return FileVerification(
      snapshotId: r.id!,
      origin: r.origin,
      electionCode: r.electionCode,
      officeCode: r.officeCode,
      scopeCode: r.scopeCode,
      fileName: url.pathSegments.last,
      url: url.toString(),
      tseGeneratedAt: r.tseGeneratedAt,
      sha256: r.rawSha256,
      signature: r.signature,
      kid: r.signatureKid,
    );
  }
}

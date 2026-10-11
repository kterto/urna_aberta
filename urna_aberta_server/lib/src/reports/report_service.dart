import 'package:serverpod/serverpod.dart' hide Scope;

import '../generated/protocol.dart';
import 'report_builder.dart';
import 'report_plan.dart';

/// Reports: quoting a spec, and (later) queuing and building it.
class ReportService {
  ReportService({
    required this.planner,
    required this.builder,
    required this.ratePerSecond,
  });

  final ReportPlanner planner;
  final ReportBuilder builder;

  /// The TSE client's rate, for the time estimate.
  final double ratePerSecond;

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

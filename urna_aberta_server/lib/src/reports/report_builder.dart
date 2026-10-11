import 'package:serverpod/serverpod.dart' hide Scope;

import '../generated/protocol.dart' hide Candidate;
import '../results/ea20_result.dart';
import '../results/results_service.dart';
import '../secao/section_service.dart';
import 'report_plan.dart';
import 'tally.dart';

/// One table of a finished report.
class ReportTable {
  ReportTable({
    required this.item,
    required this.tally,
    required this.breakdown,
    required this.check,
  });

  final ReportItem item;
  final Tally tally;

  /// One tally per breakdown row, in the plan's order.
  final List<(ReportPlace, Tally)> breakdown;

  /// TSE's total for the place against our sum of its breakdown rows: empty
  /// when every figure matches, null when there is nothing to compare (the
  /// place has no TSE file of its own, or no breakdown was asked).
  final List<Difference>? check;
}

/// Reads every file a [ReportPlan] needs, once each, then sums them into
/// [ReportTable]s.
class ReportBuilder {
  ReportBuilder({required this.result, required this.section});

  /// Reads result files through [results] and sections through the
  /// [sections] service of their pleito.
  factory ReportBuilder.fromServices(
    ResultsService results,
    SectionService Function(int pleito, int year) sections,
  ) => ReportBuilder(
    result: (session, need) async {
      final (r, file, uri) = await results.load(
        session,
        need.election,
        need.office,
        need.scope,
      );
      return (
        r,
        TallySource(
          name: uri.pathSegments.last,
          url: uri.toString(),
          sha256: file.rawSha256,
          check: file.signature.name,
        ),
      );
    },
    section: (session, need) =>
        sections(need.pleito, need.year).lookup(session, need.id),
  );

  final Future<(OfficeResult, TallySource)> Function(Session, ResultNeed)
  result;
  final Future<SectionReport> Function(Session, SectionNeed) section;

  Future<List<ReportTable>> build(
    Session session,
    ReportPlan plan, {
    void Function(int done, int total)? onProgress,
  }) async {
    var done = 0;
    final results = <ResultNeed, (OfficeResult, TallySource)>{};
    for (final need in plan.results) {
      results[need] = await result(session, need);
      onProgress?.call(++done, plan.files);
    }
    final sections = <SectionNeed, SectionReport>{};
    for (final need in plan.sections) {
      sections[need] = await section(session, need);
      done += 3;
      onProgress?.call(done, plan.files);
    }

    Tally tallyOf(List<ReportItem> items) {
      final first = items.first;
      if (first.sections.isEmpty) {
        return sumResults(first.office, [
          for (final i in items)
            for (final r in i.results) results[r]!,
        ]);
      }
      return sumSections(
        first.election.code,
        first.office,
        [
          for (final i in items)
            for (final s in i.sections) sections[s]!,
        ],
        reference: results[first.reference!]!.$1,
        listed: items.fold(
          0,
          (n, i) => n + i.sections.length + i.sectionsWithoutFiles,
        ),
      );
    }

    return [
      for (final item in plan.items) _table(item, tallyOf([item]), tallyOf),
    ];
  }

  ReportTable _table(
    ReportItem item,
    Tally tally,
    Tally Function(List<ReportItem>) tallyOf,
  ) {
    final hasOwnFile = item.sections.isEmpty && !item.summed;
    return ReportTable(
      item: item,
      tally: tally,
      breakdown: [
        for (final b in item.breakdown) (b.place, tallyOf([b])),
      ],
      check: hasOwnFile && item.breakdown.isNotEmpty
          ? compareTallies(tally, tallyOf(item.breakdown))
          : null,
    );
  }
}

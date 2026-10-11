import 'dart:convert';

import 'report_builder.dart';
import 'report_plan.dart';
import 'tally.dart';

/// The report's data in long format, one figure per line, for spreadsheets
/// and scripts. UTF-8 with a BOM (so spreadsheet apps read the accents),
/// comma-separated, RFC 4180 quoting.
///
/// Columns: the table (election, round, office, place) and the row the
/// figure belongs to (`local` for the place itself, otherwise the breakdown
/// row), whether the figure is TSE's or our sum, then the figure: `total`,
/// `validos`, `nominais`, `legenda`, `brancos`, `nulos`, `anulados_sub_judice`,
/// `eleitorado`, `comparecimento`, `secoes`, `secoes_somadas`, or a
/// candidacy (`candidato`) or party (`partido`) with its votes and, where
/// TSE gives them, seats and status. A table with a breakdown and a TSE
/// total of its own ends with its check (`origem` `conferencia`).
List<int> reportCsv(List<ReportTable> tables) {
  final out = StringBuffer('\uFEFF')
    ..writeln(
      _line([
        'eleicao',
        'turno',
        'cargo',
        'local',
        'nome_local',
        'linha',
        'nome_linha',
        'origem',
        'item',
        'numero',
        'nome',
        'partido',
        'votos',
        'vagas',
        'situacao',
      ]),
    );
  for (final t in tables) {
    final head = [
      '${t.item.election.code}',
      '${t.item.election.round}',
      '${t.item.office.code}',
      placeCode(t.item.place),
      t.item.placeName,
    ];
    void tally(String row, String rowName, Tally tally, bool summed) {
      final origin = summed ? 'soma' : 'tse';
      void figure(String item, int? value) {
        if (value == null) return;
        out.writeln(
          _line([
            ...head,
            row,
            rowName,
            origin,
            item,
            '',
            '',
            '',
            '$value',
            '',
            '',
          ]),
        );
      }

      figure('total', tally.total);
      figure('validos', tally.valid);
      figure('nominais', tally.nominal);
      figure('legenda', tally.legend);
      figure('brancos', tally.blank);
      figure('nulos', tally.nullVotes);
      figure('anulados_sub_judice', tally.annulledSubJudice);
      figure('eleitorado', tally.electorate);
      figure('comparecimento', tally.turnout);
      figure('secoes', tally.sectionsTotal);
      figure('secoes_somadas', tally.sectionsCounted);
      for (final r in tally.rows) {
        out.writeln(
          _line([
            ...head,
            row,
            rowName,
            origin,
            tally.byCandidate ? 'candidato' : 'partido',
            '${r.number ?? ''}',
            r.label,
            r.party ?? '',
            '${r.votes}',
            '${r.seats ?? ''}',
            r.status ?? '',
          ]),
        );
      }
    }

    tally('local', t.item.placeName, t.tally, t.item.summed);
    for (final (i, (place, rowTally)) in t.breakdown.indexed) {
      tally(
        placeCode(place),
        t.item.breakdown[i].placeName,
        rowTally,
        t.item.breakdown[i].summed,
      );
    }
    // TSE's total against the sum of the rows: `confere` 1 when every
    // figure matches, else 0 and one pair of lines per difference.
    if (t.check case final diffs?) {
      void check(String item, String name, int value) => out.writeln(
        _line([
          ...head,
          'local',
          t.item.placeName,
          'conferencia',
          item,
          '',
          name,
          '',
          '$value',
          '',
          '',
        ]),
      );
      check('confere', '', diffs.isEmpty ? 1 : 0);
      for (final d in diffs) {
        check(d.what, 'tse', d.tse);
        check(d.what, 'soma', d.ours);
      }
    }
  }
  return utf8.encode(out.toString());
}

String _line(List<String> fields) => fields.map(_quote).join(',');

String _quote(String v) =>
    v.contains(RegExp('[",\r\n]')) ? '"${v.replaceAll('"', '""')}"' : v;

/// The printable report: a cover saying what was asked and what the report
/// proves, one plate per table, and every file read. Laid out like the
/// app's Atlas plates: Archivo for labels and figures, Source Serif for
/// prose, hairline rules, no colour for any candidacy.
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../generated/protocol.dart';
import '../tse/tse_urls.dart';
import 'report_builder.dart';
import 'tally.dart';

/// The static font instances in `web/pdf/fonts` (OFL; cut from the app's
/// variable fonts, which the PDF format cannot use).
class ReportFonts {
  ReportFonts._(this.sans, this.sansBold, this.serif, this.serifItalic);

  final pw.Font sans, sansBold, serif, serifItalic;

  static Future<ReportFonts> load([String dir = 'web/pdf/fonts']) async {
    Future<pw.Font> font(String name) async => pw.Font.ttf(
      ByteData.sublistView(await File('$dir/$name.ttf').readAsBytes()),
    );
    return ReportFonts._(
      await font('Archivo-Regular'),
      await font('Archivo-SemiBold'),
      await font('SourceSerif4-Regular'),
      await font('SourceSerif4-Italic'),
    );
  }
}

// Atlas palette (light), from the app's design tokens.
const _ink = PdfColor.fromInt(0xFF16252B);
const _inkSecondary = PdfColor.fromInt(0xFF44565C);
const _inkMuted = PdfColor.fromInt(0xFF5E6F74);
const _rule = PdfColor.fromInt(0xFFD3DBD8);
const _ruleStrong = PdfColor.fromInt(0xFF9AA8A6);
const _plateSunk = PdfColor.fromInt(0xFFE9EEEB);
const _shell = PdfColor.fromInt(0xFF123A4C);
const _valid = PdfColor.fromInt(0xFF2E7D4F);
const _invalid = PdfColor.fromInt(0xFFB3261E);
const _alertGround = PdfColor.fromInt(0xFFFFF1D6);
const _alertInk = PdfColor.fromInt(0xFF5C3B00);
const _alertRule = PdfColor.fromInt(0xFFD9A441);

/// Builds the PDF of [request] from its [tables]. [dataSha256] is the
/// CSV's hash, printed on every page so a paper copy can be matched to the
/// stored data.
Future<List<int>> reportPdf({
  required ReportRequest request,
  required List<ReportTable> tables,
  required String dataSha256,
  required DateTime generatedAt,
  required ReportFonts fonts,
}) async {
  final t = _Strings(request.spec.language);
  final doc = pw.Document(
    title: t.title(request.id!),
    author: 'Urna Aberta',
    creator: 'Urna Aberta',
    theme: pw.ThemeData.withFont(
      base: fonts.sans,
      bold: fonts.sansBold,
      italic: fonts.serifItalic,
    ).copyWith(defaultTextStyle: pw.TextStyle(fontSize: 9, color: _ink)),
  );
  final f = _Fmt(t);
  final serif = pw.TextStyle(font: fonts.serif, fontSize: 10.5, lineSpacing: 2);
  final label = pw.TextStyle(
    font: fonts.sansBold,
    fontSize: 7,
    letterSpacing: 0.8,
    color: _inkMuted,
  );

  doc.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(48, 40, 48, 40),
      ),
      header: (ctx) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 14),
        padding: const pw.EdgeInsets.only(bottom: 5),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _rule, width: 0.5)),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(t.header(request.id!).toUpperCase(), style: label),
            pw.Text(
              t.page(ctx.pageNumber, ctx.pagesCount).toUpperCase(),
              style: label,
            ),
          ],
        ),
      ),
      footer: (ctx) => pw.Container(
        width: double.infinity,
        margin: const pw.EdgeInsets.only(top: 10),
        padding: const pw.EdgeInsets.only(top: 5),
        decoration: const pw.BoxDecoration(
          border: pw.Border(top: pw.BorderSide(color: _rule, width: 0.5)),
        ),
        child: pw.Text(
          '${t.dataHash}: $dataSha256',
          style: pw.TextStyle(fontSize: 6.5, color: _inkMuted),
        ),
      ),
      build: (ctx) => [
        ..._cover(request, tables, dataSha256, generatedAt, t, f, serif, label),
        for (final table in tables) ..._plate(table, t, f, serif, label),
        ..._appendix(tables, t, label),
      ],
    ),
  );
  return doc.save();
}

List<pw.Widget> _cover(
  ReportRequest request,
  List<ReportTable> tables,
  String dataSha256,
  DateTime generatedAt,
  _Strings t,
  _Fmt f,
  pw.TextStyle serif,
  pw.TextStyle label,
) {
  final spec = request.spec;
  final elections = {
    for (final table in tables) table.item.election.code: table.item.election,
  }.values;
  final offices = {for (final table in tables) table.item.office};
  final places = {for (final table in tables) t.place(table.item.placeName)};
  final files = {
    for (final table in tables) ...[
      ...table.tally.sources,
      for (final (_, b) in table.breakdown) ...b.sources,
    ],
  }.map((s) => s.url).toSet().length;

  pw.Widget fact(String name, String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 110,
          child: pw.Text(name.toUpperCase(), style: label),
        ),
        pw.Expanded(
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 9.5)),
        ),
      ],
    ),
  );

  return [
    pw.Text(t.kicker.toUpperCase(), style: label.copyWith(color: _shell)),
    pw.SizedBox(height: 6),
    pw.Text(
      t.headline(
        [for (final o in offices) t.office(o)],
        places.toList(),
      ),
      style: serif.copyWith(fontSize: 22, lineSpacing: 3),
    ),
    pw.SizedBox(height: 8),
    pw.Text(
      t.lede(f.dateTime(generatedAt)),
      style: serif.copyWith(color: _inkSecondary),
    ),
    pw.SizedBox(height: 18),
    fact(
      t.electionsLabel,
      elections.map((e) => t.election(e.name, f.day(e.day))).join('\n'),
    ),
    fact(t.officesLabel, offices.map(t.office).join(', ')),
    fact(t.placesLabel, places.join('; ')),
    fact(t.breakdownLabel, t.breakdown(spec.breakdown)),
    fact(t.filesLabel, f.integer(files)),
    fact(t.requestLabel, '#${request.id} · ${f.dateTime(request.createdAt)}'),
    fact(t.dataHash, dataSha256),
    pw.SizedBox(height: 12),
    pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: const pw.BoxDecoration(
        color: _plateSunk,
        border: pw.Border(left: pw.BorderSide(color: _shell, width: 2)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            t.provesTitle.toUpperCase(),
            style: label.copyWith(color: _ink),
          ),
          pw.SizedBox(height: 4),
          pw.Text(t.proves, style: serif.copyWith(fontSize: 9.5)),
          pw.SizedBox(height: 8),
          pw.Text(
            t.notProvesTitle.toUpperCase(),
            style: label.copyWith(color: _ink),
          ),
          pw.SizedBox(height: 4),
          pw.Text(t.notProves, style: serif.copyWith(fontSize: 9.5)),
        ],
      ),
    ),
    pw.SizedBox(height: 24),
  ];
}

List<pw.Widget> _plate(
  ReportTable table,
  _Strings t,
  _Fmt f,
  pw.TextStyle serif,
  pw.TextStyle label,
) {
  final item = table.item;
  final tally = table.tally;
  final summed = item.summed;
  final rows = tally.rows;
  final hasSeats = rows.any((r) => r.seats != null);
  final hasStatus = rows.any((r) => (r.status ?? '').isNotEmpty);

  pw.Widget stat(String name, String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(right: 18),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(name.toUpperCase(), style: label),
        pw.SizedBox(height: 2),
        pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
      ],
    ),
  );

  final header = pw.Container(
    margin: const pw.EdgeInsets.only(top: 6, bottom: 8),
    padding: const pw.EdgeInsets.only(top: 8),
    decoration: const pw.BoxDecoration(
      border: pw.Border(top: pw.BorderSide(color: _ink, width: 1)),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                '${t.office(item.office)} · ${t.place(item.placeName)}',
                style: pw.TextStyle(font: label.font, fontSize: 13),
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: summed ? _alertRule : _ruleStrong,
                  width: 0.75,
                ),
                color: summed ? _alertGround : null,
              ),
              child: pw.Text(
                (summed ? t.ourSum : t.tseFile).toUpperCase(),
                style: label.copyWith(
                  color: summed ? _alertInk : _inkSecondary,
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          t.election(item.election.name, f.day(item.election.day)),
          style: const pw.TextStyle(color: _inkSecondary),
        ),
      ],
    ),
  );

  final stats = pw.Wrap(
    runSpacing: 6,
    children: [
      if (tally.electorate case final e? when e > 0)
        stat(t.electorate, f.integer(e)),
      if (tally.turnout case final c? when c > 0)
        stat(
          t.turnout,
          (tally.electorate ?? 0) > 0
              ? '${f.integer(c)} (${f.percent(c, tally.electorate!)})'
              : f.integer(c),
        ),
      stat(t.valid, f.integer(tally.valid)),
      stat(t.blank, f.integer(tally.blank)),
      stat(t.nullVotes, f.integer(tally.nullVotes)),
      if (tally.sectionsTotal > 0)
        stat(
          tally.fromBallots ? t.sectionsSummed : t.sectionsTotalized,
          '${f.integer(tally.sectionsCounted)} / ${f.integer(tally.sectionsTotal)}',
        ),
    ],
  );

  pw.Widget cell(String text, {bool right = false, pw.TextStyle? style}) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 3),
        child: pw.Text(
          text,
          textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
          style: style,
        ),
      );

  final rowsTable = pw.Table(
    columnWidths: {
      0: const pw.FixedColumnWidth(34),
      1: const pw.FlexColumnWidth(),
      if (tally.byCandidate) 2: const pw.FixedColumnWidth(84),
    },
    border: const pw.TableBorder(
      horizontalInside: pw.BorderSide(color: _rule, width: 0.4),
      bottom: pw.BorderSide(color: _rule, width: 0.4),
    ),
    children: [
      pw.TableRow(
        repeat: true,
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(color: _ruleStrong, width: 0.6),
          ),
        ),
        children: [
          cell(t.number.toUpperCase(), style: label),
          cell(
            (tally.byCandidate ? t.candidacy : t.party).toUpperCase(),
            style: label,
          ),
          if (tally.byCandidate) cell(t.party.toUpperCase(), style: label),
          cell(t.votes.toUpperCase(), right: true, style: label),
          cell(t.ofValid.toUpperCase(), right: true, style: label),
          if (hasSeats) cell(t.seats.toUpperCase(), right: true, style: label),
          if (hasStatus) cell(t.status.toUpperCase(), style: label),
        ],
      ),
      for (final r in rows)
        pw.TableRow(
          children: [
            cell(
              '${r.number ?? ''}',
              style: const pw.TextStyle(color: _inkMuted),
            ),
            cell(r.label),
            if (tally.byCandidate) cell(r.party ?? ''),
            cell(f.integer(r.votes), right: true),
            cell(f.percent(r.votes, tally.valid), right: true),
            if (hasSeats)
              cell(r.seats == null ? '' : '${r.seats}', right: true),
            if (hasStatus) cell(r.status ?? ''),
          ],
        ),
    ],
  );

  final notes = <pw.Widget>[
    if (tally.races > 0)
      pw.Text(
        t.seatsCheck(tally.racesMatching, tally.races),
        style: serif.copyWith(fontSize: 9),
      ),
    if (tally.excluded.isNotEmpty)
      pw.Text(
        t.excluded(tally.excluded.length),
        style: serif.copyWith(fontSize: 9, color: _alertInk),
      ),
  ];

  return [
    header,
    stats,
    pw.SizedBox(height: 10),
    rowsTable,
    if (notes.isNotEmpty) ...[pw.SizedBox(height: 6), ...notes],
    if (table.breakdown.isNotEmpty) ...[
      pw.SizedBox(height: 12),
      pw.Text(
        t.byBreakdown(table.breakdown.first.$1.kind).toUpperCase(),
        style: label,
      ),
      pw.SizedBox(height: 4),
      _breakdownTable(table, rows, t, f, label, cell),
    ],
    if (table.check case final diffs?) ...[
      pw.SizedBox(height: 8),
      _check(diffs, t, f, label, serif),
    ],
    pw.SizedBox(height: 6),
    pw.Text(
      _sourceLine(tally, t),
      style: pw.TextStyle(fontSize: 7.5, color: _inkMuted),
    ),
    pw.SizedBox(height: 18),
  ];
}

/// One row per breakdown place with its valid votes. When the rows are
/// tallied like the place (the same candidacies or parties), the place's
/// three leaders get a column each; otherwise each row shows its own most
/// voted.
pw.Widget _breakdownTable(
  ReportTable table,
  List<TallyRow> leaders,
  _Strings t,
  _Fmt f,
  pw.TextStyle label,
  pw.Widget Function(String, {bool right, pw.TextStyle? style}) cell,
) {
  final alike = table.breakdown.every(
    (b) => b.$2.byCandidate == table.tally.byCandidate,
  );
  final top = alike ? leaders.take(3).toList() : const <TallyRow>[];
  int votesOf(Tally b, TallyRow r) =>
      b.rows.where((x) => x.key == r.key).firstOrNull?.votes ?? 0;
  return pw.Table(
    columnWidths: {
      0: const pw.FlexColumnWidth(),
      1: const pw.FixedColumnWidth(64),
      if (alike)
        for (var i = 0; i <= top.length; i++)
          2 + i: const pw.FixedColumnWidth(72),
    },
    border: const pw.TableBorder(
      horizontalInside: pw.BorderSide(color: _rule, width: 0.4),
      bottom: pw.BorderSide(color: _rule, width: 0.4),
    ),
    children: [
      pw.TableRow(
        repeat: true,
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(color: _ruleStrong, width: 0.6),
          ),
        ),
        children: [
          cell(t.placeColumn.toUpperCase(), style: label),
          cell(t.valid.toUpperCase(), right: true, style: label),
          if (alike) ...[
            for (final r in top)
              cell(r.label.toUpperCase(), right: true, style: label),
            cell(t.others.toUpperCase(), right: true, style: label),
          ] else
            cell(t.mostVoted.toUpperCase(), style: label),
        ],
      ),
      for (final (i, (_, b)) in table.breakdown.indexed)
        pw.TableRow(
          children: [
            cell(t.place(table.item.breakdown[i].placeName)),
            cell(f.integer(b.valid), right: true),
            if (alike) ...[
              for (final r in top)
                cell(f.percent(votesOf(b, r), b.valid), right: true),
              cell(
                f.percent(
                  b.valid - top.fold(0, (s, r) => s + votesOf(b, r)),
                  b.valid,
                ),
                right: true,
              ),
            ] else
              cell(
                b.rows.isEmpty
                    ? ''
                    : '${b.rows.first.label} · ${f.percent(b.rows.first.votes, b.valid)}',
              ),
          ],
        ),
    ],
  );
}

pw.Widget _check(
  List<Difference> diffs,
  _Strings t,
  _Fmt f,
  pw.TextStyle label,
  pw.TextStyle serif,
) {
  final ok = diffs.isEmpty;
  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(
      border: pw.Border(
        left: pw.BorderSide(color: ok ? _valid : _invalid, width: 2),
      ),
      color: _plateSunk,
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          (ok ? t.checkOk : t.checkDiffers(diffs.length)).toUpperCase(),
          style: label.copyWith(color: ok ? _valid : _invalid),
        ),
        pw.SizedBox(height: 3),
        pw.Text(t.checkExplain, style: serif.copyWith(fontSize: 9)),
        for (final d in diffs.take(40))
          pw.Text(
            '${d.what}: TSE ${f.integer(d.tse)} · ${t.sum} ${f.integer(d.ours)}',
            style: const pw.TextStyle(fontSize: 8),
          ),
      ],
    ),
  );
}

String _sourceLine(Tally tally, _Strings t) {
  final s = tally.sources;
  if (s.length <= 3) {
    return '${t.source}: TSE, ${s.map((x) => '${x.name} (${t.check(x.check)})').join('; ')}.';
  }
  return '${t.source}: ${t.manyFiles(s.length)}';
}

List<pw.Widget> _appendix(
  List<ReportTable> tables,
  _Strings t,
  pw.TextStyle label,
) {
  final sources = <String, TallySource>{
    for (final table in tables) ...{
      for (final s in table.tally.sources) s.url: s,
      for (final (_, b) in table.breakdown)
        for (final s in b.sources) s.url: s,
    },
  };
  const small = pw.TextStyle(fontSize: 6.5);
  return [
    pw.NewPage(),
    pw.Text(t.appendixTitle.toUpperCase(), style: label.copyWith(color: _ink)),
    pw.SizedBox(height: 4),
    pw.Text(
      t.appendixLede,
      style: const pw.TextStyle(fontSize: 8, color: _inkSecondary),
    ),
    pw.SizedBox(height: 8),
    pw.Table(
      columnWidths: {
        0: const pw.FlexColumnWidth(1.4),
        1: const pw.FlexColumnWidth(2.2),
        2: const pw.FlexColumnWidth(0.9),
      },
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: _rule, width: 0.3),
      ),
      children: [
        pw.TableRow(
          repeat: true,
          children: [
            for (final h in [t.file, 'SHA-256', t.verification])
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Text(
                  h.toUpperCase(),
                  style: label.copyWith(fontSize: 6),
                ),
              ),
          ],
        ),
        for (final s in sources.values)
          pw.TableRow(
            children: [
              pw.Text(s.name, style: small),
              pw.Text(s.sha256, style: small),
              pw.Text(t.check(s.check), style: small),
            ],
          ),
      ],
    ),
  ];
}

class _Fmt {
  _Fmt(this.t);

  final _Strings t;

  String integer(int v) {
    final s = v.abs().toString();
    final b = StringBuffer(v < 0 ? '-' : '');
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write(t.en ? ',' : '.');
      b.write(s[i]);
    }
    return b.toString();
  }

  String percent(int part, int whole) {
    if (whole == 0) return '–';
    final v = (part * 10000 / whole).round();
    final s =
        '${v ~/ 100}${t.en ? '.' : ','}${(v % 100).toString().padLeft(2, '0')}%';
    return s;
  }

  String day((int, int, int) d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return t.en
        ? '${d.$1}-${two(d.$2)}-${two(d.$3)}'
        : '${two(d.$3)}/${two(d.$2)}/${d.$1}';
  }

  String dateTime(DateTime at) {
    final u = at.toUtc();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${day((u.year, u.month, u.day))} ${two(u.hour)}:${two(u.minute)} UTC';
  }
}

/// Every string of the PDF, in the report's language.
class _Strings {
  _Strings(String language) : en = language == 'en';

  final bool en;

  String _(String pt, String english) => en ? english : pt;

  String title(int id) =>
      _('Relatório Urna Aberta nº $id', 'Urna Aberta report #$id');
  String header(int id) =>
      _('Urna Aberta · relatório nº $id', 'Urna Aberta · report #$id');
  String page(int n, int of) => _('página $n de $of', 'page $n of $of');
  String get kicker => _('Relatório', 'Report');
  String get dataHash =>
      _('SHA-256 dos dados (CSV)', 'SHA-256 of the data (CSV)');
  String lede(String at) => _(
    'Montado em $at a partir dos arquivos assinados que o TSE publica em '
        'resultados.tse.jus.br.',
    'Built on $at from the signed files TSE publishes at '
        'resultados.tse.jus.br.',
  );
  String headline(List<String> offices, List<String> places) {
    final o = _join(offices);
    final p = places.length > 4
        ? _('${places.length} locais', '${places.length} places')
        : _join(places);
    return _('$o — $p', '$o — $p');
  }

  String _join(List<String> items) => items.length <= 1
      ? items.join()
      : '${items.sublist(0, items.length - 1).join(', ')} ${_('e', 'and')} ${items.last}';

  String get electionsLabel => _('Eleições', 'Elections');
  String get officesLabel => _('Cargos', 'Offices');
  String get placesLabel => _('Locais', 'Places');
  String get breakdownLabel => _('Detalhamento', 'Breakdown');
  String get filesLabel => _('Arquivos lidos', 'Files read');
  String get requestLabel => _('Pedido', 'Requested');
  String get provesTitle =>
      _('O que este relatório comprova', 'What this report proves');
  String get proves => _(
    'Cada número vem de um arquivo do TSE cuja assinatura foi verificada '
        'com a chave oficial, ou do boletim de urna de uma seção que confere '
        'com a lista assinada pela própria urna. Somas feitas pela Urna '
        'Aberta são marcadas como soma e, quando o TSE publica o total do '
        'mesmo local, comparadas a ele número a número.',
    "Every figure comes from a TSE file whose signature was checked against "
        "TSE's official key, or from a section's ballot box report that "
        "matches the list its voting machine signed. Sums made by Urna "
        "Aberta are marked as such and, where TSE publishes the same "
        "place's total, compared with it figure by figure.",
  );
  String get notProvesTitle =>
      _('O que não comprova', 'What it does not prove');
  String get notProves => _(
    'Nada sobre o funcionamento da urna, seu software, ou se cada voto foi '
        'registrado como o eleitor quis. Não é uma fonte oficial: confira '
        'sempre no TSE.',
    'Anything about how a voting machine works, its software, or whether '
        'each vote was recorded as the voter intended. It is not an official '
        'source: always check with TSE.',
  );

  String breakdown(ReportBreakdown b) => switch (b) {
    ReportBreakdown.none => _('nenhum', 'none'),
    ReportBreakdown.uf => _('por UF', 'by state'),
    ReportBreakdown.municipio => _('por município', 'by city'),
    ReportBreakdown.zona => _('por zona', 'by zone'),
  };

  String byBreakdown(ReportPlaceKind k) => switch (k) {
    ReportPlaceKind.uf => _('Por UF', 'By state'),
    ReportPlaceKind.municipio => _('Por município', 'By city'),
    _ => _('Por zona', 'By zone'),
  };

  /// EA11 names already say the round (`… 2026 1º Turno`).
  String election(String name, String day) => '$name · $day';

  String office(Office o) => switch (o) {
    Office.presidente => _('Presidente', 'President'),
    Office.governador => _('Governador', 'Governor'),
    Office.senador => _('Senador', 'Senator'),
    Office.deputadoFederal => _('Deputado Federal', 'Federal Deputy'),
    Office.deputadoEstadual => _('Deputado Estadual', 'State Deputy'),
    Office.deputadoDistrital => _('Deputado Distrital', 'District Deputy'),
    Office.prefeito => _('Prefeito', 'Mayor'),
    Office.vereador => _('Vereador', 'City Councillor'),
  };

  static const _regions = {
    'Brasil': 'Brazil',
    'Norte': 'North',
    'Nordeste': 'Northeast',
    'Centro-Oeste': 'Center-West',
    'Sudeste': 'Southeast',
    'Sul': 'South',
    'Exterior': 'Abroad',
  };

  /// The planner names places in Portuguese.
  String place(String name) => en
      ? (_regions[name] ??
            name
                .replaceAll(', zona ', ', zone ')
                .replaceAll(', seção ', ', section '))
      : name;

  String get tseFile => _('Arquivo do TSE', 'TSE file');
  String get ourSum => _('Soma Urna Aberta', 'Urna Aberta sum');
  String get electorate => _('Eleitorado', 'Electorate');
  String get turnout => _('Comparecimento', 'Turnout');
  String get valid => _('Válidos', 'Valid');
  String get blank => _('Brancos', 'Blank');
  String get nullVotes => _('Nulos', 'Null');
  String get sectionsSummed => _('Seções somadas', 'Sections summed');
  String get sectionsTotalized => _('Seções totalizadas', 'Sections totalized');
  String get number => _('Nº', 'No.');
  String get candidacy => _('Candidatura', 'Candidacy');
  String get party => _('Partido', 'Party');
  String get votes => _('Votos', 'Votes');
  String get ofValid => _('% válidos', '% valid');
  String get seats => _('Vagas', 'Seats');
  String get status => _('Situação', 'Status');
  String get placeColumn => _('Local', 'Place');
  String get others => _('Outros', 'Others');
  String get mostVoted => _('Mais votado', 'Most voted');
  String get sum => _('soma', 'sum');
  String seatsCheck(int matching, int races) => _(
    'Vagas segundo o TSE. A distribuição refeita pela Urna Aberta confere '
        'com a do TSE em $matching de $races disputa${races == 1 ? '' : 's'}.',
    "Seats as TSE awarded them. Urna Aberta's own allocation matches TSE's "
        'in $matching of $races race${races == 1 ? '' : 's'}.',
  );
  String excluded(int n) => _(
    '$n seç${n == 1 ? 'ão ficou' : 'ões ficaram'} fora da soma: o boletim '
        'não estava disponível ou não confere com a lista assinada pela urna.',
    '$n section${n == 1 ? ' was' : 's were'} left out of the sum: the '
        'ballot box report was missing or does not match the list its '
        'voting machine signed.',
  );
  String get checkOk => _('Confere com o total do TSE', "Matches TSE's total");
  String checkDiffers(int n) => _(
    '$n diferença${n == 1 ? '' : 's'} em relação ao total do TSE',
    "$n difference${n == 1 ? '' : 's'} from TSE's total",
  );
  String get checkExplain => _(
    'A soma das linhas acima foi comparada, número a número, com o arquivo '
        'do TSE para este local.',
    "The rows above, added up, were compared figure by figure with TSE's "
        'file for this place.',
  );
  String get source => _('Fonte', 'Source');
  String manyFiles(int n) => _(
    '$n arquivos do TSE, listados ao final com seu SHA-256 e a verificação '
        'de cada um.',
    '$n TSE files, listed at the end with their SHA-256 and how each was '
        'checked.',
  );
  String get appendixTitle => _('Arquivos lidos', 'Files read');
  String get appendixLede => _(
    'Cada arquivo do TSE que este relatório leu, com o SHA-256 dos bytes '
        'como foram recebidos e o resultado da verificação.',
    'Every TSE file this report read, with the SHA-256 of its bytes as '
        'received and how it was checked.',
  );
  String get file => _('Arquivo', 'File');
  String get verification => _('Verificação', 'Check');

  String check(String code) => switch (code) {
    'valid' => _('assinatura TSE válida', 'valid TSE signature'),
    'invalid' => _('assinatura TSE inválida', 'invalid TSE signature'),
    'unknownKey' => _('chave desconhecida', 'unknown key'),
    _ when code.contains('/') => _section(code),
    _ => code,
  };

  String _section(String code) {
    final [bu, urna] = code.split('/');
    final buText = bu == 'matches'
        ? _('BU confere', 'BU matches')
        : _('BU não confere', 'BU does not match');
    final urnaText = switch (urna) {
      'valid' => _('urna assinou', 'machine signed'),
      'unsupported' => _(
        'urna: algoritmo não verificável',
        'machine: unverifiable algorithm',
      ),
      'invalid' => _(
        'assinatura da urna inválida',
        'invalid machine signature',
      ),
      _ => _('sem assinatura da urna', 'no machine signature'),
    };
    return '$buText; $urnaText';
  }
}

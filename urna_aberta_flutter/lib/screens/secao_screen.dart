import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../l10n/format.dart';
import '../l10n/l10n.dart';
import '../secao/secao_controller.dart';

/// My polling section: locate it, read the official BU, compare with paper.
class SecaoScreen extends StatefulWidget {
  const SecaoScreen({super.key});

  @override
  State<SecaoScreen> createState() => _SecaoScreenState();
}

class _SecaoScreenState extends State<SecaoScreen> {
  SecaoController? _c;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _c ??= SecaoController(SecaoScope.of(context));
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _c!;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final wide = isWideLayout(context);
        final l = context.l10n;
        return AtlasPage(
          title: l.secaoTitle,
          lede: l.secaoLede,
          maxWidth: 1040,
          children: [
            _form(context, c, wide),
            if (c.error != null) ...[
              const SizedBox(height: Space.x5),
              _ErrorPlate(error: c.error!, onRetry: c.consultar),
            ] else if (c.report case final r?) ...[
              const SizedBox(height: Space.x5),
              _Result(report: r, key: ValueKey(r)),
            ],
          ],
        );
      },
    );
  }

  Widget _form(BuildContext context, SecaoController c, bool wide) {
    String two(int v, int w) => v.toString().padLeft(w, '0');
    final l = context.l10n;
    final fields = <Widget>[
      _PickerField(
        label: l.secaoFieldUf,
        value: c.uf,
        options: SecaoController.ufs,
        display: (o) =>
            o == 'zz' ? l.secaoUfExterior : (o as String).toUpperCase(),
        onChanged: (v) => c.selectUf(v as String),
      ),
      _PickerField(
        label: l.secaoFieldMunicipio,
        value: c.municipio,
        options: c.municipios,
        display: (o) => (o as MunicipioRef).nome,
        filter: true,
        loading: c.loading == SecaoLoad.municipios
            ? l.secaoLoadingMunicipios
            : null,
        onChanged: (v) => c.selectMunicipio(v as MunicipioRef),
      ),
      _PickerField(
        label: l.secaoFieldZona,
        value: c.zona,
        options: c.zonas,
        display: (o) => two(o as int, 4),
        loading: c.loading == SecaoLoad.zonas ? l.secaoLoadingZonas : null,
        onChanged: (v) => c.selectZona(v as int),
      ),
      _PickerField(
        label: l.secaoFieldSecao,
        value: c.secao,
        options: c.secoes,
        display: (o) => two(o as int, 4),
        filter: true,
        loading: c.loading == SecaoLoad.secoes ? l.secaoLoadingSecoes : null,
        onChanged: (v) => c.selectSecao(v as int),
      ),
    ];
    return Plate(
      title: l.secaoLocatePlate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, f) in fields.indexed) ...[
                  if (i > 0) const SizedBox(width: Space.x3),
                  Expanded(flex: i == 1 ? 3 : 1, child: f),
                ],
              ],
            )
          else
            for (final (i, f) in fields.indexed) ...[
              if (i > 0) const SizedBox(height: Space.x3),
              f,
            ],
          const SizedBox(height: Space.x2),
          Text(
            l.secaoFormHint,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.atlas.inkMuted),
          ),
          const SizedBox(height: Space.x4),
          Row(
            children: [
              Flexible(
                child: FilledButton(
                  onPressed: c.canConsult && !c.busy ? c.consultar : null,
                  child: Text(
                    l.secaoSearchButton,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (c.loading == SecaoLoad.report) ...[
                const SizedBox(width: Space.x3),
                const _Spinner(),
                const SizedBox(width: Space.x2),
                Flexible(
                  flex: 2,
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      l.secaoSearchingTse,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.atlas.inkMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// `YYYY-MM-DDThh:mm:ss` on the urna's own clock (local to the urna, not
/// Brasília) → `hh:mm`.
String _urnaHhmm(String iso) => iso.substring(11, 16);

class _Result extends StatefulWidget {
  const _Result({super.key, required this.report});

  final SectionReport report;

  @override
  State<_Result> createState() => _ResultState();
}

class _ResultState extends State<_Result> {
  int _cargo = 0;
  final _paper = <String, TextEditingController>{};

  @override
  void dispose() {
    for (final c in _paper.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _field(String key) =>
      _paper.putIfAbsent(key, TextEditingController.new);

  @override
  Widget build(BuildContext context) {
    final r = widget.report;
    final wide = isWideLayout(context);
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    final l = context.l10n;
    final sectionTitle = l.secaoSectionTitle(
      '${r.zona}',
      '${r.secao}',
      r.municipioNome,
    );

    if (r.status == 'Aguardando' || r.buCheck == BuCheck.missing) {
      return Plate(
        title: sectionTitle,
        child: Text(
          r.status == 'Aguardando'
              ? l.secaoNotPublished
              : l.secaoNoBu(r.status),
          style: t.bodyMedium,
        ),
      );
    }

    if (r.buCheck != BuCheck.matches) {
      return Plate(
        title: sectionTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusBadge(VerificationStatus.invalid, label: l.secaoHashMismatch),
            const SizedBox(height: Space.x3),
            Text(
              switch (r.buCheck) {
                BuCheck.differs => l.secaoBuDiffers,
                BuCheck.notListed => l.secaoBuNotListed,
                _ => l.secaoListingAltered,
              },
              style: t.bodyMedium,
            ),
            const SizedBox(height: Space.x3),
            for (final f in r.files) ...[
              HashRow(label: f.kind.toUpperCase(), hash: f.sha256),
              const SizedBox(height: Space.x2),
            ],
          ],
        ),
      );
    }

    final cargo = r.cargos[_cargo.clamp(0, r.cargos.length - 1)];
    final rows = [
      for (final v in cargo.votos)
        (
          key: '${cargo.eleicao}-${cargo.codigo}-${v.tipo}-${v.numero}',
          label: _label(l, v),
          votos: v.votos,
        ),
    ];
    final mismatches = [
      for (final row in rows)
        if (_field(row.key).text.isNotEmpty &&
            int.tryParse(_field(row.key).text) != row.votos)
          row.key,
    ];
    final bu = r.files.where((f) => f.kind == 'bu').firstOrNull;

    final compare = Plate(
      title: l.secaoComparePlate,
      fonte: FonteLine(
        plateNumber: 9,
        source: l.secaoCompareSource(
          r.zona.toString().padLeft(4, '0'),
          r.secao.toString().padLeft(4, '0'),
          r.municipioNome,
          r.uf.toUpperCase(),
          _urnaHhmm(r.emitidoEm!),
          context.hm(r.receivedAt!),
        ),
        codes: [if (bu != null) FileCode(bu.name, url: Uri.parse(bu.url))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: Space.x2,
            runSpacing: Space.x2,
            children: [
              for (final (i, c) in r.cargos.indexed)
                ChoiceChip(
                  label: Text(_cargoNome(l, c)),
                  selected: i == _cargo,
                  onSelected: (_) => setState(() => _cargo = i),
                ),
            ],
          ),
          const SizedBox(height: Space.x3),
          Text(
            l.secaoTurnout(
              context.integer(r.aptos ?? 0),
              context.integer(cargo.comparecimento),
            ),
            style: t.bodySmall?.copyWith(color: p.inkSecondary),
          ),
          const SizedBox(height: Space.x3),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2.4),
              1: FlexColumnWidth(1),
              2: FixedColumnWidth(96),
              3: FlexColumnWidth(1.1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder(horizontalInside: BorderSide(color: p.rule)),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: p.ink, width: 1.5)),
                ),
                children: [
                  for (final (i, h) in [
                    l.secaoColCandidatura,
                    l.secaoColArquivo,
                    l.secaoColPapel,
                    l.secaoColConfere,
                  ].indexed)
                    Padding(
                      padding: EdgeInsets.only(
                        top: Space.x2,
                        bottom: Space.x2,
                        right: i == 1 ? Space.x4 : 0,
                      ),
                      child: Text(
                        h,
                        style: t.labelMedium?.copyWith(color: p.inkSecondary),
                        textAlign: i == 1 ? TextAlign.end : TextAlign.start,
                      ),
                    ),
                ],
              ),
              for (final row in rows)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Space.x2),
                      child: Text(row.label, style: t.bodyMedium),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: Space.x4),
                      child: Text(
                        context.integer(row.votos),
                        textAlign: TextAlign.end,
                        style: AtlasType.tableFigure.copyWith(color: p.ink),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: TextField(
                        controller: _field(row.key),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.end,
                        style: AtlasType.tableFigure.copyWith(color: p.ink),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: l.secaoPaperHint,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: Space.x3),
                      child: _field(row.key).text.isEmpty
                          ? const SizedBox.shrink()
                          : _Match(ok: !mismatches.contains(row.key)),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: Space.x4),
          if (mismatches.isNotEmpty)
            Text(
              l.secaoMismatch(mismatches.length),
              style: t.bodyMedium?.copyWith(color: p.ink),
            )
          else if (rows.every((row) => _field(row.key).text.isNotEmpty))
            Text(
              l.secaoAllMatch,
              style: t.bodyMedium?.copyWith(color: p.statusValid),
            ),
        ],
      ),
    );

    final files = Plate(
      title: l.secaoFilesPlate,
      fonte: FonteLine(plateNumber: 10, source: l.secaoFilesSource),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: Space.x3,
            runSpacing: Space.x2,
            children: [
              StatusBadge(VerificationStatus.valid, label: l.secaoHashMatches),
              switch (r.urnaSignature) {
                UrnaSignature.valid => StatusBadge(
                  VerificationStatus.valid,
                  label: l.secaoUrnaSignatureValid,
                ),
                UrnaSignature.invalid => StatusBadge(
                  VerificationStatus.invalid,
                  label: l.secaoUrnaSignatureInvalid,
                ),
                UrnaSignature.unsupported ||
                UrnaSignature.missing => StatusBadge(
                  VerificationStatus.pending,
                  label: l.secaoUrnaSignatureUnchecked,
                ),
              },
            ],
          ),
          const SizedBox(height: Space.x3),
          for (final f in r.files) ...[
            HashRow(
              label: l.secaoHashLabel(_kindLabel(l, f.kind)),
              hash: f.sha256,
            ),
            const SizedBox(height: Space.x2),
          ],
          const SizedBox(height: Space.x2),
          if (r.urnaSignature == UrnaSignature.invalid) ...[
            Text(
              l.secaoSignatureInvalidNote,
              style: t.bodyMedium?.copyWith(color: p.ink),
            ),
            const SizedBox(height: Space.x2),
          ],
          if (r.urnaSignature
              case UrnaSignature.unsupported || UrnaSignature.missing) ...[
            Text(
              l.secaoSignatureUncheckedNote,
              style: t.bodySmall?.copyWith(color: p.inkSecondary),
            ),
            const SizedBox(height: Space.x2),
          ],
          if (r.urnaSignature != UrnaSignature.invalid)
            Text.rich(
              TextSpan(
                style: t.bodySmall?.copyWith(color: p.inkSecondary),
                children: [
                  TextSpan(
                    text: l.secaoProvesLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: r.urnaSignature == UrnaSignature.valid
                        ? l.secaoProves
                        : l.secaoProvesHashOnly,
                  ),
                  TextSpan(
                    text: l.secaoNotYetLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: l.secaoNotYet),
                ],
              ),
            ),
        ],
      ),
    );

    if (!wide) {
      return Column(
        children: [
          compare,
          const SizedBox(height: Space.x5),
          files,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: compare),
        const SizedBox(width: Space.x5),
        Expanded(flex: 5, child: files),
      ],
    );
  }

  static String _label(AppLocalizations l, VotoResult v) => switch (v.tipo) {
    'branco' => l.secaoVoteBranco,
    'nulo' => l.secaoVoteNulo,
    'legenda' => l.secaoVoteLegenda('${v.numero ?? v.partido}'),
    'cargoSemCandidato' => l.secaoVoteCargoSemCandidato,
    _ => v.nome == null ? '${v.numero}' : '${v.numero} · ${v.nome}',
  };

  /// Office names by TSE code; any other office keeps the server's name.
  static String _cargoNome(AppLocalizations l, CargoResult c) =>
      switch (c.codigo) {
        1 => l.secaoCargoPresidente,
        3 => l.secaoCargoGovernador,
        5 => l.secaoCargoSenador,
        6 => l.secaoCargoDeputadoFederal,
        7 => l.secaoCargoDeputadoEstadual,
        8 => l.secaoCargoDeputadoDistrital,
        _ => c.nome,
      };

  static String _kindLabel(AppLocalizations l, String kind) => switch (kind) {
    'aux' => l.secaoKindAux,
    'bu' => l.secaoKindBu,
    'vota' => l.secaoKindVota,
    _ => kind,
  };
}

class _ErrorPlate extends StatelessWidget {
  const _ErrorPlate({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    // The server's messages are Portuguese; the type says what happened.
    final message = switch (error) {
      SectionUnavailableException() => l.secaoErrorUnavailable,
      SectionNotFoundException() => l.secaoErrorNotFound,
      _ => l.secaoErrorServer,
    };
    return Plate(
      title: l.secaoErrorTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: Space.x4),
          FilledButton(onPressed: onRetry, child: Text(l.secaoRetry)),
        ],
      ),
    );
  }
}

class _Match extends StatelessWidget {
  const _Match({required this.ok});

  final bool ok;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final c = ok ? p.statusValid : p.statusInvalid;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          ok ? AtlasIcons.valid(context) : AtlasIcons.invalid(context),
          size: 16,
          color: c,
        ),
        const SizedBox(width: 4),
        Text(
          ok ? context.l10n.secaoMatchYes : context.l10n.secaoMatchNo,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: c),
        ),
      ],
    );
  }
}

/// Small progress mark: activity indicator on iOS, a thin ring elsewhere.
class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) => shellKindOf(context) == ShellKind.ios
      ? const CupertinoActivityIndicator(radius: 8)
      : const SizedBox.square(
          dimension: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
}

/// A read-only field that opens the options. Short lists on iOS use the
/// native wheel; everything else opens a searchable list that builds only
/// the rows on screen (municípios run to ~850 per UF).
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.options,
    required this.display,
    required this.onChanged,
    this.filter = false,
    this.loading,
  });

  final String label;
  final Object? value;
  final List<Object> options;
  final String Function(Object) display;
  final ValueChanged<Object> onChanged;
  final bool filter;

  /// Shown in the field while its options load.
  final String? loading;

  @override
  Widget build(BuildContext context) {
    final enabled = loading == null && options.isNotEmpty;
    final muted = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: context.atlas.inkMuted);
    return InkWell(
      onTap: enabled ? () => _open(context) : null,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        isEmpty: value == null && loading == null,
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          suffixIcon: loading != null
              ? const Padding(
                  padding: EdgeInsets.all(Space.x3),
                  child: _Spinner(),
                )
              : Icon(AtlasIcons.expand(context)),
        ),
        child: loading != null
            ? Semantics(
                liveRegion: true,
                child: Text(
                  loading!,
                  style: muted,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : Text(
                value == null ? '' : display(value!),
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final ios = shellKindOf(context) == ShellKind.ios;
    if (ios && !filter) return _wheel(context);
    final sheet = _OptionList(
      label: label,
      value: value,
      options: options,
      display: display,
      filter: filter,
    );
    final picked = isWideLayout(context)
        ? await showDialog<Object>(
            context: context,
            builder: (_) => Dialog(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 440,
                  maxHeight: 560,
                ),
                child: sheet,
              ),
            ),
          )
        : await showModalBottomSheet<Object>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            showDragHandle: !ios,
            builder: (ctx) => SizedBox(
              height: MediaQuery.sizeOf(ctx).height * 0.8,
              child: sheet,
            ),
          );
    if (picked != null) {
      selectionHaptic();
      onChanged(picked);
    }
  }

  void _wheel(BuildContext context) {
    var picked = value == null
        ? 0
        : options.indexOf(value!).clamp(0, options.length - 1);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: 280,
        color: context.atlas.plate,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CupertinoButton(
                  child: Text(context.l10n.secaoWheelOk),
                  onPressed: () {
                    onChanged(options[picked]);
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
              Expanded(
                child: CupertinoPicker.builder(
                  itemExtent: 36,
                  childCount: options.length,
                  scrollController: FixedExtentScrollController(
                    initialItem: picked,
                  ),
                  onSelectedItemChanged: (i) => picked = i,
                  itemBuilder: (_, i) =>
                      Center(child: Text(display(options[i]))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The options as a lazily built list, with a search box for long lists.
/// Search ignores case and accents, so "sao paulo" finds "SÃO PAULO".
class _OptionList extends StatefulWidget {
  const _OptionList({
    required this.label,
    required this.value,
    required this.options,
    required this.display,
    required this.filter,
  });

  final String label;
  final Object? value;
  final List<Object> options;
  final String Function(Object) display;
  final bool filter;

  @override
  State<_OptionList> createState() => _OptionListState();
}

class _OptionListState extends State<_OptionList> {
  late final _folded = [
    for (final o in widget.options) _fold(widget.display(o)),
  ];
  late List<Object> _shown = widget.options;
  String _query = '';

  /// Opens with the current choice in view.
  late final _scroll = ScrollController(
    initialScrollOffset: switch (widget.value) {
      final v? => (widget.options.indexOf(v) - 3).clamp(0, 1 << 20) * 48.0,
      null => 0,
    },
  );

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  static const _plain = {
    'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', //
    'é': 'e', 'ê': 'e', 'è': 'e', 'í': 'i', 'î': 'i', //
    'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ú': 'u', //
    'ü': 'u', 'ç': 'c', "'": '', '-': ' ',
  };

  static String _fold(String s) {
    final b = StringBuffer();
    for (final ch in s.toLowerCase().split('')) {
      b.write(_plain[ch] ?? ch);
    }
    return b.toString();
  }

  void _search(String q) {
    final f = _fold(q.trim());
    if (_scroll.hasClients) _scroll.jumpTo(0);
    setState(() {
      _query = q.trim();
      _shown = f.isEmpty
          ? widget.options
          : [
              for (final (i, o) in widget.options.indexed)
                if (_folded[i].contains(f)) o,
            ];
    });
  }

  void _submit(String _) {
    if (_shown.length == 1) Navigator.of(context).pop(_shown.single);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final ios = shellKindOf(context) == ShellKind.ios;
    // Keyboard straight away on web/desktop; on touch devices the user
    // may just want to scroll.
    final autofocus = isWideLayout(context);
    final hint = context.l10n.secaoSearchHint(widget.label.toLowerCase());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Space.x5,
            Space.x4,
            Space.x5,
            Space.x2,
          ),
          child: Text(widget.label, style: t.titleMedium),
        ),
        if (widget.filter)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.x5,
              vertical: Space.x2,
            ),
            child: ios
                ? CupertinoSearchTextField(
                    placeholder: hint,
                    autofocus: autofocus,
                    onChanged: _search,
                    onSubmitted: _submit,
                  )
                : TextField(
                    autofocus: autofocus,
                    decoration: InputDecoration(
                      hintText: hint,
                      prefixIcon: Icon(AtlasIcons.search(context)),
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: _search,
                    onSubmitted: _submit,
                  ),
          ),
        const Divider(height: 1),
        Expanded(
          child: _shown.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(Space.x5),
                  child: Text(
                    context.l10n.secaoNothingFound(_query),
                    style: t.bodyMedium?.copyWith(
                      color: context.atlas.inkMuted,
                    ),
                  ),
                )
              : ListView.builder(
                  itemExtent: 48,
                  itemCount: _shown.length,
                  controller: _scroll,
                  itemBuilder: (context, i) {
                    final o = _shown[i];
                    final selected = o == widget.value;
                    return ListTile(
                      dense: true,
                      selected: selected,
                      title: Text(widget.display(o)),
                      trailing: selected
                          ? Icon(AtlasIcons.selected(context), size: 18)
                          : null,
                      onTap: () => Navigator.of(context).pop(o),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

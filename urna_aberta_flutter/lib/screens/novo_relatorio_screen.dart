import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import '../app/router.dart';
import '../conta/conta_controller.dart';
import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../l10n/format.dart';
import '../l10n/l10n.dart';
import '../relatorios/novo_relatorio_controller.dart';
import '../relatorios/relatorios_source.dart';
import '../resultados/resultados_controller.dart';
import '../secao/secao_controller.dart';
import 'conta_screen.dart';
import 'resultados_screen.dart' show officeName;

/// A place as the viewer reads it: `Brasil`, `Norte`, `AC`,
/// `PORTO WALTER (AC)`, `PORTO WALTER (AC), zona 4`…
String placeLabel(BuildContext context, ReportPlace p, String? city) {
  final l = context.l10n;
  final uf = p.uf?.toUpperCase();
  final cityLabel = city == null ? '$uf ${p.municipio}' : '$city ($uf)';
  return switch (p.kind) {
    ReportPlaceKind.br => l.ufBrasil,
    ReportPlaceKind.regiao => Regiao.fromSigla(
      p.regiao!.toUpperCase(),
    ).nome(context),
    ReportPlaceKind.uf => uf == 'ZZ' ? l.ufExterior : uf!,
    ReportPlaceKind.municipio => cityLabel,
    ReportPlaceKind.zona => l.relatoriosZoneLabel(cityLabel, '${p.zona}'),
    ReportPlaceKind.secao => l.relatoriosSectionLabel(
      cityLabel,
      '${p.zona}',
      '${p.secao}',
    ),
  };
}

/// Novo relatório: elections, offices, places, breakdown and language,
/// with the server's quote before anything is queued.
class NovoRelatorioScreen extends StatefulWidget {
  const NovoRelatorioScreen({
    super.key,
    this.draft = const ReportDraft(),
    this.debounce = const Duration(milliseconds: 400),
    this.now,
  });

  static const routeName = Paths.novoRelatorio;

  final ReportDraft draft;
  final Duration debounce;
  final DateTime Function()? now;

  static Future<void> open(
    BuildContext context, {
    ReportDraft draft = const ReportDraft(),
  }) => context.push<void>(Paths.novoRelatorio, extra: draft);

  @override
  State<NovoRelatorioScreen> createState() => _NovoRelatorioScreenState();
}

class _NovoRelatorioScreenState extends State<NovoRelatorioScreen> {
  NovoRelatorioController? _c;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final first = _c == null;
    final c = _c ??= NovoRelatorioController(
      reports: RelatoriosScope.maybeOf(context)!,
      results: ResultadosScope.of(context),
      sections: context.getInheritedWidgetOfExactType<SecaoScope>()?.source,
      draft: widget.draft,
      language: Localizations.localeOf(context).languageCode == 'en'
          ? 'en'
          : 'pt',
      debounce: widget.debounce,
      now: widget.now,
    );
    c.setSignedIn(ContaScope.maybeOf(context)?.signedIn ?? false);
    if (first) c.start();
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = _c!;
    return Scaffold(
      body: ListenableBuilder(
        listenable: c,
        builder: (context, _) => AtlasPage(
          title: l.relatoriosNew,
          lede: l.relatoriosNewLede,
          maxWidth: 880,
          showBack: true,
          children: [
            if (!c.signedIn) ...[
              const RelatoriosSignInPlate(),
              const SizedBox(height: Space.x4),
            ],
            if (c.loadError != null)
              Text(l.relatoriosElectionsError)
            else if (c.loading)
              const Center(child: CircularProgressIndicator())
            else ...[
              _DaysPlate(c: c),
              const SizedBox(height: Space.x4),
              _OfficesPlate(c: c),
              const SizedBox(height: Space.x4),
              _PlacesPlate(c: c),
              const SizedBox(height: Space.x4),
              _OptionsPlate(c: c),
              const SizedBox(height: Space.x4),
              _QuotePlate(c: c),
            ],
          ],
        ),
      ),
    );
  }
}

/// Reports live in the viewer's account: what a signed-out viewer sees.
class RelatoriosSignInPlate extends StatelessWidget {
  const RelatoriosSignInPlate({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Plate(
      title: l.relatoriosSignIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.relatoriosSignInBody),
          const SizedBox(height: Space.x3),
          FilledButton(
            onPressed: () => ContaScreen.open(context),
            child: Text(l.relatoriosSignInAction),
          ),
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Space.x3),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: context.atlas.inkMuted),
    ),
  );
}

class _DaysPlate extends StatelessWidget {
  const _DaysPlate({required this.c});

  final NovoRelatorioController c;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Plate(
      title: l.relatoriosDays,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Hint(l.relatoriosDaysHint),
          Wrap(
            spacing: Space.x2,
            runSpacing: Space.x2,
            children: [
              for (final r in c.rounds)
                FilterChip(
                  label: Text(
                    '${l.resultadosRound('${r.day.year}', r.round)} · '
                    '${context.day(r.day.add(const Duration(hours: 12)))}',
                  ),
                  selected: c.days.contains(r.day),
                  onSelected: (_) => c.toggleDay(r.day),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OfficesPlate extends StatelessWidget {
  const _OfficesPlate({required this.c});

  final NovoRelatorioController c;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Plate(
      title: l.relatoriosOffices,
      child: Wrap(
        spacing: Space.x2,
        runSpacing: Space.x2,
        children: [
          for (final o in c.availableOffices)
            FilterChip(
              label: Text(officeName(l, o)),
              selected: c.offices.contains(o),
              onSelected: (_) => c.toggleOffice(o),
            ),
        ],
      ),
    );
  }
}

class _PlacesPlate extends StatelessWidget {
  const _PlacesPlate({required this.c});

  final NovoRelatorioController c;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Plate(
      title: l.relatoriosPlaces,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (c.places.isEmpty)
            _Hint(l.relatoriosNoPlaces)
          else
            Padding(
              padding: const EdgeInsets.only(bottom: Space.x4),
              child: Wrap(
                spacing: Space.x2,
                runSpacing: Space.x2,
                children: [
                  for (final p in c.places)
                    InputChip(
                      label: Text(placeLabel(context, p, c.cityName(p))),
                      onDeleted: () => c.removePlace(p),
                      deleteButtonTooltipMessage: l.relatoriosRemovePlace(
                        placeLabel(context, p, c.cityName(p)),
                      ),
                    ),
                ],
              ),
            ),
          _PlaceAdder(c: c),
        ],
      ),
    );
  }
}

/// Kind of place, then each level it needs; lists load as levels are
/// chosen and only offer what TSE lists.
class _PlaceAdder extends StatefulWidget {
  const _PlaceAdder({required this.c});

  final NovoRelatorioController c;

  @override
  State<_PlaceAdder> createState() => _PlaceAdderState();
}

class _PlaceAdderState extends State<_PlaceAdder> {
  ReportPlaceKind _kind = ReportPlaceKind.uf;
  Regiao? _regiao;
  String? _uf;
  MunicipioRef? _municipio;
  int? _zona;
  int? _secao;
  List<MunicipioRef> _municipios = const [];
  List<int> _zonas = const [];
  List<int> _secoes = const [];

  NovoRelatorioController get c => widget.c;

  int _depth(ReportPlaceKind k) => ReportPlaceKind.values.indexOf(k);
  bool _needs(ReportPlaceKind level) =>
      _depth(_kind) >= _depth(level) && level != ReportPlaceKind.regiao ||
      (_kind == ReportPlaceKind.regiao && level == ReportPlaceKind.regiao);

  Future<void> _pickUf(String? uf) async {
    setState(() {
      _uf = uf;
      _municipio = null;
      _zona = null;
      _secao = null;
      _municipios = const [];
    });
    if (uf == null || !_needs(ReportPlaceKind.municipio)) return;
    final list = await c.municipios(uf).catchError((_) => <MunicipioRef>[]);
    if (mounted && _uf == uf) setState(() => _municipios = list);
  }

  Future<void> _pickMunicipio(MunicipioRef? m) async {
    setState(() {
      _municipio = m;
      _zona = null;
      _secao = null;
      _zonas = const [];
    });
    if (m == null || !_needs(ReportPlaceKind.zona)) return;
    final list = await c.zonas(_uf!, m.codigo).catchError((_) => <int>[]);
    if (mounted && _municipio == m) setState(() => _zonas = list);
  }

  Future<void> _pickZona(int? z) async {
    setState(() {
      _zona = z;
      _secao = null;
      _secoes = const [];
    });
    if (z == null || !_needs(ReportPlaceKind.secao)) return;
    final list = await c
        .secoes(_uf!, _municipio!.codigo, z)
        .catchError((_) => <int>[]);
    if (mounted && _zona == z) setState(() => _secoes = list);
  }

  ReportPlace? get _place => switch (_kind) {
    ReportPlaceKind.br => ReportPlace(kind: _kind),
    ReportPlaceKind.regiao when _regiao != null => ReportPlace(
      kind: _kind,
      regiao: _regiao!.sigla.toLowerCase(),
    ),
    ReportPlaceKind.uf when _uf != null => ReportPlace(kind: _kind, uf: _uf),
    ReportPlaceKind.municipio when _municipio != null => ReportPlace(
      kind: _kind,
      uf: _uf,
      municipio: _municipio!.codigo,
    ),
    ReportPlaceKind.zona when _zona != null => ReportPlace(
      kind: _kind,
      uf: _uf,
      municipio: _municipio!.codigo,
      zona: _zona,
    ),
    ReportPlaceKind.secao when _secao != null => ReportPlace(
      kind: _kind,
      uf: _uf,
      municipio: _municipio!.codigo,
      zona: _zona,
      secao: _secao,
    ),
    _ => null,
  };

  String _kindName(AppLocalizations l, ReportPlaceKind k) => switch (k) {
    ReportPlaceKind.br => l.relatoriosKindBr,
    ReportPlaceKind.regiao => l.relatoriosKindRegiao,
    ReportPlaceKind.uf => l.relatoriosKindUf,
    ReportPlaceKind.municipio => l.relatoriosKindMunicipio,
    ReportPlaceKind.zona => l.relatoriosKindZona,
    ReportPlaceKind.secao => l.relatoriosKindSecao,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final kinds = [
      for (final k in ReportPlaceKind.values)
        if (c.sectionsAvailable ||
            (k != ReportPlaceKind.zona && k != ReportPlaceKind.secao))
          k,
    ];
    if (!kinds.contains(_kind)) _kind = ReportPlaceKind.uf;
    final place = _place;
    const ufs = [...ResultadosController.ufs, 'zz'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: Space.x3,
          runSpacing: Space.x3,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropdownMenu<ReportPlaceKind>(
              key: ValueKey('kind $_kind ${kinds.length}'),
              label: Text(l.relatoriosPlaceKind),
              width: 170,
              initialSelection: _kind,
              dropdownMenuEntries: [
                for (final k in kinds)
                  DropdownMenuEntry(value: k, label: _kindName(l, k)),
              ],
              onSelected: (k) {
                if (k == null) return;
                setState(() => _kind = k);
                _pickUf(_uf);
              },
            ),
            if (_kind == ReportPlaceKind.regiao)
              DropdownMenu<Regiao>(
                key: const ValueKey('regiao'),
                label: Text(l.relatoriosKindRegiao),
                width: 190,
                initialSelection: _regiao,
                dropdownMenuEntries: [
                  for (final r in Regiao.values)
                    DropdownMenuEntry(value: r, label: r.nome(context)),
                ],
                onSelected: (r) => setState(() => _regiao = r),
              ),
            if (_needs(ReportPlaceKind.uf))
              DropdownMenu<String>(
                key: ValueKey('uf $_kind'),
                label: Text(l.relatoriosKindUf),
                width: 140,
                initialSelection: _uf,
                dropdownMenuEntries: [
                  for (final u in ufs)
                    if (u != 'zz' || _kind == ReportPlaceKind.uf)
                      DropdownMenuEntry(
                        value: u,
                        label: u == 'zz' ? l.ufExterior : u.toUpperCase(),
                      ),
                ],
                onSelected: _pickUf,
              ),
            if (_needs(ReportPlaceKind.municipio))
              DropdownMenu<MunicipioRef>(
                key: ValueKey('mun $_uf ${_municipios.length}'),
                label: Text(l.relatoriosKindMunicipio),
                width: 240,
                enableFilter: true,
                enabled: _municipios.isNotEmpty,
                initialSelection: _municipio,
                dropdownMenuEntries: [
                  for (final m in _municipios)
                    DropdownMenuEntry(value: m, label: m.nome),
                ],
                onSelected: _pickMunicipio,
              ),
            if (_needs(ReportPlaceKind.zona))
              DropdownMenu<int>(
                key: ValueKey('zona ${_municipio?.codigo} ${_zonas.length}'),
                label: Text(l.relatoriosKindZona),
                width: 120,
                enabled: _zonas.isNotEmpty,
                initialSelection: _zona,
                dropdownMenuEntries: [
                  for (final z in _zonas)
                    DropdownMenuEntry(value: z, label: '$z'),
                ],
                onSelected: _pickZona,
              ),
            if (_needs(ReportPlaceKind.secao))
              DropdownMenu<int>(
                key: ValueKey('secao $_zona ${_secoes.length}'),
                label: Text(l.relatoriosKindSecao),
                width: 120,
                enabled: _secoes.isNotEmpty,
                initialSelection: _secao,
                dropdownMenuEntries: [
                  for (final s in _secoes)
                    DropdownMenuEntry(value: s, label: '$s'),
                ],
                onSelected: (s) => setState(() => _secao = s),
              ),
            FilledButton.tonal(
              onPressed: place == null
                  ? null
                  : () => c.addPlace(place, city: _municipio?.nome),
              child: Text(l.relatoriosAddPlace),
            ),
          ],
        ),
        if (!c.sectionsAvailable) ...[
          const SizedBox(height: Space.x3),
          _Hint(l.relatoriosSectionsOnly),
        ],
      ],
    );
  }
}

class _OptionsPlate extends StatelessWidget {
  const _OptionsPlate({required this.c});

  final NovoRelatorioController c;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    return Plate(
      title: l.relatoriosBreakdown,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Hint(l.relatoriosBreakdownHint),
          Wrap(
            spacing: Space.x2,
            runSpacing: Space.x2,
            children: [
              for (final (b, label) in [
                (ReportBreakdown.none, l.relatoriosBreakdownNone),
                (ReportBreakdown.uf, l.relatoriosBreakdownUf),
                (ReportBreakdown.municipio, l.relatoriosBreakdownMunicipio),
                if (c.sectionsAvailable)
                  (ReportBreakdown.zona, l.relatoriosBreakdownZona),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: c.breakdown == b,
                  onSelected: (_) => c.setBreakdown(b),
                ),
            ],
          ),
          const SizedBox(height: Space.x5),
          Text(l.relatoriosLanguage, style: t.titleSmall),
          const SizedBox(height: Space.x2),
          Wrap(
            spacing: Space.x2,
            children: [
              for (final (code, label) in [
                ('pt', 'Português'),
                ('en', 'English'),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: c.language == code,
                  onSelected: (_) => c.setLanguage(code),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuotePlate extends StatelessWidget {
  const _QuotePlate({required this.c});

  final NovoRelatorioController c;

  String _time(BuildContext context, int seconds) {
    final l = context.l10n;
    return seconds < 60
        ? l.relatoriosSeconds(context.integer(seconds))
        : l.relatoriosMinutes(context.integer((seconds / 60).ceil()));
  }

  String _refusal(BuildContext context, ReportRefused r) {
    final l = context.l10n;
    return switch (r.reason) {
      'tooLarge' => l.relatoriosTooLarge(context.integer(6000)),
      'notPublished' => l.relatoriosRefusedNotPublished,
      'busy' => l.relatoriosRefusedBusy,
      _ => l.relatoriosRefusedInvalid,
    };
  }

  Future<void> _submit(BuildContext context) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      final r = await c.submit();
      if (r == null) return;
      router.pushReplacement(Paths.relatorio(r.id!));
    } on Object {
      messenger.showSnackBar(SnackBar(content: Text(l.relatoriosActionFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final q = c.quote;
    final refusal = c.refusal;

    final Widget message;
    if (!c.signedIn) {
      message = Text(l.relatoriosSignInBody);
    } else if (c.spec == null) {
      message = Text(l.relatoriosIncomplete);
    } else if (c.quoting) {
      message = Row(
        children: [
          const SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: Space.x3),
          Expanded(child: Text(l.relatoriosQuoting)),
        ],
      );
    } else if (refusal != null) {
      message = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AtlasIcons.warning(context), size: 18, color: p.alertInk),
          const SizedBox(width: Space.x2),
          Expanded(
            child: Text(
              _refusal(context, refusal),
              style: t.bodyMedium?.copyWith(color: p.alertInk),
            ),
          ),
        ],
      );
    } else if (c.quoteError != null) {
      message = Text(l.relatoriosQuoteError);
    } else if (q != null) {
      message = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.relatoriosQuoteBody(
              context.integer(q.files),
              context.integer(q.stored),
              _time(context, q.seconds),
              context.integer(q.tables),
            ),
            style: t.bodyLarge,
          ),
          if (q.sectionsWithoutFiles > 0) ...[
            const SizedBox(height: Space.x1),
            Text(
              l.relatoriosWithoutFiles(context.integer(q.sectionsWithoutFiles)),
              style: t.bodySmall?.copyWith(color: p.inkMuted),
            ),
          ],
        ],
      );
    } else {
      message = const SizedBox.shrink();
    }

    return Plate(
      title: l.relatoriosQuote,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(liveRegion: true, child: message),
          const SizedBox(height: Space.x4),
          FilledButton.icon(
            onPressed: q == null || c.submitting
                ? null
                : () => _submit(context),
            icon: Icon(AtlasIcons.report(context), size: 18),
            label: Text(l.relatoriosGenerate),
          ),
        ],
      ),
    );
  }
}

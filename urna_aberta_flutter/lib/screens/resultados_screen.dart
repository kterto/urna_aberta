import 'package:flutter/material.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import '../conta/conta_controller.dart';
import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/typography.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../l10n/format.dart';
import '../l10n/l10n.dart';
import '../resultados/resultados_controller.dart';

/// Resultados: any office, any state or municipality, from TSE's signed
/// file; for proportional offices, Urna Aberta's own seat allocation next
/// to TSE's.
class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({super.key, this.now, this.autoRefresh = true});

  /// Clock override for tests.
  final DateTime Function()? now;
  final bool autoRefresh;

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  ResultadosController? _c;
  (String, int)? _home;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final place = ContaScope.maybeOf(context)?.place;
    final home = place == null ? null : (place.uf, place.municipio);
    final first = _c == null;
    final c = _c ??= ResultadosController(
      ResultadosScope.of(context),
      now: widget.now,
      autoRefresh: widget.autoRefresh,
    );
    if (home != null && home != _home) c.useHome(home.$1, home.$2);
    _home = home;
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
    return ListenableBuilder(
      listenable: _c!,
      builder: (context, _) => AtlasPage(
        title: l.resultadosTitle,
        lede: l.resultadosLede,
        children: [
          _Controls(c: _c!),
          const SizedBox(height: Space.x5),
          _Body(c: _c!),
        ],
      ),
    );
  }
}

String officeName(AppLocalizations l, int code) => switch (code) {
  Cargo.presidente => l.secaoCargoPresidente,
  Cargo.governador => l.secaoCargoGovernador,
  Cargo.senador => l.secaoCargoSenador,
  Cargo.deputadoFederal => l.secaoCargoDeputadoFederal,
  Cargo.deputadoEstadual => l.secaoCargoDeputadoEstadual,
  Cargo.deputadoDistrital => l.secaoCargoDeputadoDistrital,
  Cargo.prefeito => l.cargoPrefeito,
  Cargo.vereador => l.cargoVereador,
  _ => '$code',
};

String _scopeLabel(AppLocalizations l, String code) => switch (code) {
  'br' => l.ufBrasil,
  'zz' => l.ufExterior,
  _ => code.toUpperCase(),
};

class _Controls extends StatelessWidget {
  const _Controls({required this.c});

  final ResultadosController c;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    final e = c.election;
    final rounds = c.rounds;
    final current = e == null
        ? null
        : rounds.where((r) => r.day == e.day).firstOrNull;
    final places = c.municipal ? ResultadosController.ufs : c.scopes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: Space.x3,
          runSpacing: Space.x3,
          children: [
            DropdownMenu<ElectionSummary>(
              key: ValueKey('round ${current?.day}'),
              label: Text(l.resultadosElection),
              initialSelection: current,
              enabled: rounds.isNotEmpty,
              dropdownMenuEntries: [
                for (final r in rounds)
                  DropdownMenuEntry(
                    value: r,
                    label: l.resultadosRound('${r.day.year}', r.round),
                  ),
              ],
              onSelected: (r) {
                if (r != null) c.selectRound(r);
              },
            ),
            if (places.isNotEmpty)
              DropdownMenu<String>(
                key: ValueKey('uf ${c.uf} ${c.office}'),
                label: Text(l.resultadosPlace),
                width: 210,
                initialSelection: c.uf,
                dropdownMenuEntries: [
                  for (final s in places)
                    DropdownMenuEntry(
                      value: s,
                      label: s == 'br' && c.office == Cargo.deputadoFederal
                          ? l.resultadosBrasilCamara
                          : _scopeLabel(l, s),
                    ),
                ],
                onSelected: (s) {
                  if (s != null) c.selectUf(s);
                },
              ),
            if (c.municipal && c.municipios.isNotEmpty)
              DropdownMenu<MunicipioRef>(
                key: ValueKey('mun ${c.uf} ${c.election?.code}'),
                label: Text(l.resultadosMunicipio),
                hintText: l.resultadosMunicipioHint,
                width: 280,
                menuHeight: 360,
                enableFilter: true,
                requestFocusOnTap: true,
                initialSelection: c.municipio,
                dropdownMenuEntries: [
                  for (final m in c.municipios)
                    DropdownMenuEntry(value: m, label: m.nome),
                ],
                onSelected: (m) {
                  if (m != null) c.selectMunicipio(m);
                },
              ),
          ],
        ),
        const SizedBox(height: Space.x3),
        Text(
          l.resultadosOffice,
          style: t.labelMedium?.copyWith(color: p.inkMuted),
        ),
        const SizedBox(height: Space.x2),
        Wrap(
          spacing: Space.x2,
          runSpacing: Space.x2,
          children: [
            for (final o in c.offices)
              ChoiceChip(
                label: Text(officeName(l, o)),
                selected: o == c.office,
                onSelected: (_) {
                  selectionHaptic();
                  c.selectOffice(o);
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.c});

  final ResultadosController c;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    Widget message(String s) => Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.x5),
      child: Text(s, style: t.bodyLarge?.copyWith(color: p.inkSecondary)),
    );

    if (c.loading != null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: Space.x6),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (c.notHeldYet) return message(l.resultadosNotHeld);
    final error = c.error;
    if (error != null) {
      return message(switch (error) {
        ResultUnavailable(reason: 'notPublished') => l.resultadosNotPublished,
        ResultUnavailable(reason: 'invalidRequest') =>
          l.resultadosInvalidRequest,
        ResultUnavailable(reason: 'tseUnavailable') =>
          l.resultadosTseUnavailable,
        _ => l.resultadosError,
      });
    }
    final chamber = c.chamber;
    if (chamber != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${officeName(l, Cargo.deputadoFederal)} · ${l.resultadosChamber}',
            style: AtlasType.headlineSerif.copyWith(color: p.ink),
          ),
          const SizedBox(height: Space.x4),
          _ChamberPlate(chamber: chamber),
        ],
      );
    }
    final r = c.report;
    if (r == null) {
      return c.municipal && c.municipio == null
          ? message(l.resultadosChooseMunicipio)
          : const SizedBox.shrink();
    }
    final place = c.municipal ? c.municipio!.nome : _scopeLabel(l, r.scopeCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${officeName(l, r.officeCode)} · $place',
          style: AtlasType.headlineSerif.copyWith(color: p.ink),
        ),
        const SizedBox(height: Space.x4),
        _Summary(r: r, live: c.live),
        if (r.proportional && r.seatCheck != null) ...[
          const SizedBox(height: Space.x5),
          _SeatsPlate(r: r),
        ],
        const SizedBox(height: Space.x5),
        _CandidatesPlate(c: c, r: r),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.r, required this.live});

  final OfficeReport r;

  /// Still being counted: reloads every 30 s.
  final bool live;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final check = r.seatCheck;
    return Plate(
      title: l.resultadosSummaryPlate,
      trailing: Wrap(
        spacing: Space.x2,
        runSpacing: Space.x2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (live) ...[
            const LiveStamp(),
            Text(
              l.apuracaoUpdatedAt(context.hm(r.fetchedAt)),
              style: AtlasType.legend.copyWith(color: context.atlas.inkMuted),
            ),
          ],
          StatusBadge(switch (r.signature) {
            SignatureStatus.valid => VerificationStatus.valid,
            SignatureStatus.invalid => VerificationStatus.invalid,
            SignatureStatus.unknownKey => VerificationStatus.pending,
          }),
        ],
      ),
      fonte: FonteLine(
        plateNumber: 11,
        source: l.resultadosSource(context.dateHm(r.tseGeneratedAt)),
        codes: [FileCode(r.fileName)],
      ),
      child: Wrap(
        spacing: Space.x6,
        runSpacing: Space.x4,
        children: [
          _Figure(l.resultadosValidVotes, context.integer(r.validVotes)),
          _Figure(l.resultadosSeats, context.integer(r.seats)),
          if (check != null)
            _Figure(l.resultadosQuotient, context.integer(check.quotient)),
          _Figure(
            l.resultadosTotalized,
            context.percent(
              r.sectionsTotal == 0
                  ? 0
                  : 100 * r.sectionsTotalized / r.sectionsTotal,
            ),
          ),
          _Figure(
            l.resultadosBlankNull,
            context.integer(r.blankVotes + r.nullVotes),
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AtlasType.figureM.copyWith(color: p.ink)),
        const SizedBox(height: Space.x1),
        Text(label, style: AtlasType.legend.copyWith(color: p.inkMuted)),
      ],
    );
  }
}

class _SeatsPlate extends StatelessWidget {
  const _SeatsPlate({required this.r});

  final OfficeReport r;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    final check = r.seatCheck!;
    final differences = check.listDifferences + check.candidateDifferences;
    final withSeats = [
      for (final x in r.lists)
        if ((x.tseSeats ?? 0) > 0 || (x.ourSeats ?? 0) > 0) x,
    ]..sort((a, b) => (b.tseSeats ?? 0).compareTo(a.tseSeats ?? 0));
    final head = AtlasType.legend.copyWith(color: p.inkMuted);

    return Plate(
      title: l.resultadosSeatsPlate,
      trailing: StatusBadge(
        check.matches ? VerificationStatus.valid : VerificationStatus.invalid,
        label: check.matches
            ? l.resultadosCheckMatches
            : l.resultadosCheckDiffers(differences),
      ),
      fonte: FonteLine(
        plateNumber: 12,
        source: l.resultadosSeatsSource,
        codes: [FileCode(r.fileName)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.resultadosCheckNote,
            style: t.bodySmall?.copyWith(color: p.inkSecondary),
          ),
          const SizedBox(height: Space.x4),
          Row(
            children: [
              Expanded(child: Text(l.resultadosColList, style: head)),
              SizedBox(
                width: 92,
                child: Text(
                  l.resultadosColVotes,
                  style: head,
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  l.resultadosColQp,
                  style: head,
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: 48,
                child: Text(
                  l.resultadosColSeats,
                  style: head,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          for (final x in withSeats) _ListRow(x: x),
        ],
      ),
    );
  }
}

class _ListRow extends StatelessWidget {
  const _ListRow({required this.x, this.showQp = true});

  final ListReport x;

  /// The QP is per race; a sum of races has none.
  final bool showQp;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    final seats = x.tseSeats ?? 0;
    final differs = x.ourSeats != x.tseSeats;
    final kind = switch (x.kind) {
      'federation' => '${l.resultadosKindFederation} · ',
      'coalition' => '${l.resultadosKindCoalition} · ',
      _ => '',
    };
    final figure = AtlasType.tableFigure.copyWith(color: p.ink);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Space.x3),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.rule)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(x.name, style: t.titleSmall?.copyWith(color: p.ink)),
                Text(
                  '$kind${x.parties.join(' · ')}',
                  style: AtlasType.legend.copyWith(color: p.inkMuted),
                ),
                const SizedBox(height: Space.x2),
                _SeatSquares(seats),
                // CE art. 108: a QP seat needs a candidate with 10% of QE.
                if ((x.partyQuotient ?? 0) > seats)
                  Padding(
                    padding: const EdgeInsets.only(top: Space.x1),
                    child: Text(
                      l.resultadosQpUnfilled(x.partyQuotient! - seats),
                      style: AtlasType.legend.copyWith(color: p.inkSecondary),
                    ),
                  ),
                if (differs)
                  Padding(
                    padding: const EdgeInsets.only(top: Space.x1),
                    child: Text(
                      l.resultadosOurSeats(x.ourSeats ?? 0),
                      style: AtlasType.legend.copyWith(
                        color: p.status(VerificationStatus.invalid),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 92,
            child: Text(
              context.integer(x.votes),
              style: figure,
              textAlign: TextAlign.end,
            ),
          ),
          if (showQp)
            SizedBox(
              width: 40,
              child: Text(
                '${x.partyQuotient ?? ''}',
                style: figure,
                textAlign: TextAlign.end,
              ),
            ),
          SizedBox(
            width: 48,
            child: Text(
              '$seats',
              style: figure.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChamberPlate extends StatelessWidget {
  const _ChamberPlate({required this.chamber});

  final ChamberReport chamber;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    final matches = chamber.differingStates.isEmpty;
    final head = AtlasType.legend.copyWith(color: p.inkMuted);
    return Plate(
      title: l.resultadosChamberPlate,
      trailing: StatusBadge(
        matches ? VerificationStatus.valid : VerificationStatus.invalid,
        label: matches
            ? l.resultadosChamberMatches(chamber.states)
            : l.resultadosChamberDiffers(
                chamber.differingStates.map((u) => u.toUpperCase()).join(', '),
              ),
      ),
      fonte: FonteLine(
        plateNumber: 14,
        source: l.resultadosChamberSource,
        codes: [
          FileCode(
            '<uf>-c0006-e${chamber.electionCode.toString().padLeft(6, '0')}'
            '-u.jws',
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: Space.x6,
            runSpacing: Space.x4,
            children: [
              _Figure(l.resultadosSeats, context.integer(chamber.seats)),
              _Figure(
                l.resultadosValidVotes,
                context.integer(
                  chamber.lists.fold(0, (s, x) => s + x.votes),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.x4),
          Text(
            l.resultadosChamberNote,
            style: t.bodySmall?.copyWith(color: p.inkSecondary),
          ),
          const SizedBox(height: Space.x4),
          Row(
            children: [
              Expanded(child: Text(l.resultadosColList, style: head)),
              SizedBox(
                width: 92,
                child: Text(
                  l.resultadosColVotes,
                  style: head,
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: 48,
                child: Text(
                  l.resultadosColSeats,
                  style: head,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          for (final x in chamber.lists)
            if ((x.tseSeats ?? 0) > 0 || (x.ourSeats ?? 0) > 0)
              _ListRow(x: x, showQp: false),
        ],
      ),
    );
  }
}

/// One square per seat, in ink: seats are counted, never colored by party.
class _SeatSquares extends StatelessWidget {
  const _SeatSquares(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return ExcludeSemantics(
      child: Wrap(
        spacing: 3,
        runSpacing: 3,
        children: [
          for (var i = 0; i < count; i++)
            SizedBox.square(dimension: 9, child: ColoredBox(color: p.ink)),
        ],
      ),
    );
  }
}

class _CandidatesPlate extends StatefulWidget {
  const _CandidatesPlate({required this.c, required this.r});

  final ResultadosController c;
  final OfficeReport r;

  @override
  State<_CandidatesPlate> createState() => _CandidatesPlateState();
}

class _CandidatesPlateState extends State<_CandidatesPlate> {
  static const _page = 40;
  int _shown = _page;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = context.atlas;
    final c = widget.c, r = widget.r;
    final all = c.candidates;
    final top = r.candidates.isEmpty ? 1 : r.candidates.first.votes;
    final shown = all.take(_shown).toList();

    return Plate(
      title: l.resultadosCandidatesPlate,
      fonte: FonteLine(
        plateNumber: 13,
        source: l.resultadosCandidatesSource,
        codes: [FileCode(r.fileName)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (r.candidates.length > 1) ...[
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(AtlasIcons.search(context)),
                hintText: l.resultadosSearch,
              ),
              onChanged: (q) {
                setState(() => _shown = _page);
                c.search(q);
              },
            ),
            const SizedBox(height: Space.x3),
          ],
          if (all.isEmpty)
            Text(
              l.resultadosNoMatch,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: p.inkSecondary),
            ),
          for (final x in shown)
            _CandidateRow(x: x, r: r, share: x.votes / top),
          if (all.length > shown.length)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() => _shown += 100),
                child: Text(
                  l.resultadosShowMore(
                    (all.length - shown.length).clamp(0, 100),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CandidateRow extends StatelessWidget {
  const _CandidateRow({required this.x, required this.r, required this.share});

  final CandidateReport x;
  final OfficeReport r;

  /// Votes relative to the most voted candidate, for the bar.
  final double share;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = Theme.of(context).textTheme;
    final p = context.atlas;
    final elected = x.elected;
    final ours = x.ourSeat;
    final tseHow = !elected
        ? null
        : x.tseStatus == 'Eleito por QP'
        ? 'QP'
        : 'média';
    final differs = r.proportional && ours != tseHow;
    final statusColor = elected
        ? p.status(VerificationStatus.valid)
        : p.inkSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Space.x3),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.rule)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              '${x.number}',
              style: AtlasType.tableFigure.copyWith(color: p.inkMuted),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  x.ballotName,
                  style: t.titleSmall?.copyWith(
                    color: p.ink,
                    fontWeight: elected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                Wrap(
                  spacing: Space.x2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      x.party,
                      style: AtlasType.legend.copyWith(color: p.inkMuted),
                    ),
                    if (elected)
                      Icon(
                        AtlasIcons.valid(context),
                        size: 14,
                        color: statusColor,
                      ),
                    if (x.tseStatus.isNotEmpty)
                      Text(
                        x.tseStatus,
                        style: AtlasType.legend.copyWith(color: statusColor),
                      ),
                  ],
                ),
                if (!r.proportional) ...[
                  const SizedBox(height: Space.x2),
                  FractionallySizedBox(
                    widthFactor: share.clamp(0.0, 1.0),
                    alignment: Alignment.centerLeft,
                    child: Container(height: 6, color: p.ink),
                  ),
                ],
                if (differs)
                  Text(
                    l.resultadosOurSeatDiffers(
                      ours ?? l.resultadosNotElectedByUs,
                    ),
                    style: AtlasType.legend.copyWith(
                      color: p.status(VerificationStatus.invalid),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                context.integer(x.votes),
                style: AtlasType.tableFigure.copyWith(color: p.ink),
              ),
              if (!r.proportional && r.validVotes > 0)
                Text(
                  context.percent(100 * x.votes / r.validVotes),
                  style: AtlasType.legend.copyWith(color: p.inkMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

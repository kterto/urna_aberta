import 'package:flutter/material.dart';
import 'package:urna_aberta_client/urna_aberta_client.dart';

import '../app/shell.dart';
import '../design/platform.dart';
import '../design/tokens.dart';
import '../design/widgets/atlas_components.dart';
import '../design/widgets/atlas_page.dart';
import '../design/widgets/charts.dart';
import '../design/widgets/map_plate.dart';
import '../design/widgets/replay_bar.dart';
import '../replay/replay_controller.dart';
import '../showcase/design_system_screen.dart';

/// Live tally: TSE national file vs independent sum of states.
class ApuracaoScreen extends StatefulWidget {
  const ApuracaoScreen({super.key});

  @override
  State<ApuracaoScreen> createState() => _ApuracaoScreenState();
}

class _ApuracaoScreenState extends State<ApuracaoScreen> {
  ReplayController? _replay;

  /// Same threshold the server uses to flag a divergence event.
  static const _divergenceGap = 0.5;

  static final _brFile = FileCode(
    'br-c0001-e006257-u.json',
    url: Uri.parse(
      'https://resultados.tse.jus.br/oficial/ele2026/6257/dados/br/br-c0001-e006257-u.json',
    ),
  );
  static const _ufFiles = FileCode('<uf>-c0001-e006257-u.json');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _replay ??= ReplayController(TallyScope.of(context))..load();
  }

  @override
  void dispose() {
    _replay?.dispose();
    super.dispose();
  }

  String _clock(DateTime t) {
    final b = brasilia(t);
    return '${b.hour.toString().padLeft(2, '0')}:${b.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= Breakpoint.expanded;
    return ListenableBuilder(
      listenable: _replay!,
      builder: (context, _) => AtlasPage(
        title: wide ? 'A contagem não parou.' : 'Apuração',
        lede:
            'Presidente, 1º turno. O arquivo nacional do TSE e a soma dos arquivos de cada estado, lado a lado. Cada número leva ao arquivo de onde veio.',
        actions: [
          if (!isWideLayout(context) || shellKindOf(context) != ShellKind.web)
            IconButton(
              tooltip: 'Sistema de design',
              icon: Icon(AtlasIcons.sistema(context)),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const DesignSystemScreen(),
                ),
              ),
            ),
        ],
        children: _body(context, wide),
      ),
    );
  }

  List<Widget> _body(BuildContext context, bool wide) {
    final r = _replay!;
    final night = r.night, frame = r.frame, now = r.now;
    if (night == null || frame == null || now == null) {
      return [
        if (r.error != null)
          _LoadError(error: r.error!, onRetry: r.load)
        else
          const Padding(
            padding: EdgeInsets.all(Space.x6),
            child: Center(child: CircularProgressIndicator()),
          ),
      ];
    }

    final simulation = frame.origin != DataOrigin.live;
    final frozen =
        !now.isBefore(night.freezeStart) && now.isBefore(night.freezeEnd);
    final diverging = frame.statesPct - frame.nationalPct > _divergenceGap;

    final replay = ReplayBar(
      clock: _clock(now),
      playing: r.playing,
      speed: r.speed,
      onPlayPause: r.togglePlay,
      onSpeed: r.setSpeed,
      onJumpToFreeze: r.jumpToFreeze,
    );

    final duo = Plate(
      title: 'Comparação das duas fontes · Presidente',
      trailing: simulation ? const SimulationStamp() : null,
      fonte: FonteLine(
        plateNumber: 5,
        source:
            '% de seções totalizadas. Fonte: TSE. Soma calculada pela Urna Aberta.',
        codes: [_brFile, _ufFiles],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSwitcher(
            duration: Motion.of(context, Motion.standard),
            child: diverging
                ? Padding(
                    padding: const EdgeInsets.only(bottom: Space.x4),
                    child: DivergenceBanner(
                      onLearnMore: () => ShellScope.of(context)?.go(3),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          SourceDuo(
            national: frame.nationalPct,
            states: frame.statesPct,
            nationalNote: frozen
                ? 'parado desde ${_clock(night.freezeStart)}'
                : 'atualizado ${_clock(frame.at)}',
            statesNote: 'atualizado ${_clock(frame.at)}',
          ),
        ],
      ),
    );

    final map = MapPlate(
      pct: {
        for (final u in frame.ufs)
          if (u.scopeCode != 'zz')
            u.scopeCode.toUpperCase(): u.sectionsTotal == 0
                ? 0
                : u.sectionsTotalized * 100 / u.sectionsTotal,
      },
      momentLabel: _clock(frame.at),
      simulation: simulation,
    );

    final votes = Plate(
      title: 'Votos por candidatura, nas duas fontes',
      fonte: FonteLine(
        plateNumber: 6,
        source: frame.origin == DataOrigin.synthetic
            ? 'Mesma tinta para todas as candidaturas. Votos intermediários proporcionais aos arquivos finais do TSE.'
            : 'Mesma tinta para todas as candidaturas. Fonte: TSE.',
        codes: [_brFile],
        simulation: simulation,
      ),
      child: MirroredBars(
        rows: [
          for (final c in frame.candidates)
            MirroredRow(_candidateLabel(c), c.national, c.states),
        ],
      ),
    );

    final freezeIndex = night.freezeStart.difference(night.start).inMinutes;
    final timeline = Plate(
      title: 'A noite de 4 de outubro',
      fonte: FonteLine(
        plateNumber: 7,
        source:
            'Curva sintética que termina nos arquivos finais reais do TSE, com a pausa nacional de 64,81% simulada.',
        simulation: night.origin != DataOrigin.live,
      ),
      child: TimelineChart(
        samples: [
          for (final p in r.timeline)
            TimelineSample(brasilia(p.at), p.nationalPct, p.statesPct),
        ],
        now: r.nowIndex,
        freezeStart: brasilia(night.freezeStart),
        freezeEnd: brasilia(night.freezeEnd),
        freezeValue: freezeIndex < r.timeline.length
            ? r.timeline[freezeIndex].nationalPct
            : null,
      ),
    );

    const gap = SizedBox(height: Space.x5, width: Space.x5);
    return [
      replay,
      gap,
      if (wide)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: map),
            gap,
            Expanded(flex: 5, child: Column(children: [duo, gap, votes])),
          ],
        )
      else ...[
        duo,
        gap,
        map,
        gap,
        votes,
      ],
      gap,
      timeline,
    ];
  }

  static String _candidateLabel(CandidateVotes c) {
    final name = c.ballotName;
    if (name == null) return 'Número ${c.candidateNumber}';
    return '${c.candidateNumber} · $name (${c.party})';
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final message = error is ReplayUnavailableException
        ? 'Os arquivos do 1º turno ainda não foram carregados no servidor.'
        : 'Não foi possível falar com o servidor da Urna Aberta.';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.x6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: t.bodyLarge),
          const SizedBox(height: Space.x4),
          FilledButton(onPressed: onRetry, child: const Text('Tentar de novo')),
        ],
      ),
    );
  }
}

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
import '../l10n/format.dart';
import '../l10n/l10n.dart';
import '../live/live_controller.dart';
import '../replay/replay_controller.dart';

/// The count: TSE's national file vs the independent sum of states. Live
/// while TSE publishes (or once live files exist), otherwise the 1st-round
/// replay.
class ApuracaoScreen extends StatefulWidget {
  const ApuracaoScreen({super.key});

  @override
  State<ApuracaoScreen> createState() => _ApuracaoScreenState();
}

class _ApuracaoScreenState extends State<ApuracaoScreen> {
  ReplayController? _replay;
  LiveController? _live;

  /// The viewer switched from the live count to the replay.
  bool _replayChosen = false;

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
    _live ??= LiveController(TallyScope.of(context))..load();
  }

  @override
  void dispose() {
    _replay?.dispose();
    _live?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= Breakpoint.expanded;
    final l = context.l10n;
    return ListenableBuilder(
      listenable: Listenable.merge([_replay!, _live!]),
      builder: (context, _) {
        final status = _live!.status;
        final liveFrame = status?.frame;
        final showLive = status != null && liveFrame != null && !_replayChosen;
        return AtlasPage(
          title: wide ? l.apuracaoHeadline : l.navApuracao,
          lede: !showLive
              ? l.apuracaoLede
              : status.open
              ? l.apuracaoLiveLede(status.round ?? 1)
              : l.apuracaoLiveEndedLede(status.round ?? 1),
          children: [
            if (liveFrame != null) ...[
              Wrap(
                spacing: Space.x4,
                runSpacing: Space.x2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AtlasSegmented<bool>(
                    segments: {
                      false: l.apuracaoModeLive,
                      true: l.apuracaoModeReplay,
                    },
                    selected: _replayChosen,
                    onChanged: (v) => setState(() => _replayChosen = v),
                  ),
                  TextButton(
                    onPressed: () =>
                        ShellScope.of(context)?.go(Section.resultados),
                    child: Text(l.apuracaoAllOffices),
                  ),
                ],
              ),
              const SizedBox(height: Space.x5),
            ] else if (_liveNotice(context, status) case final notice?) ...[
              _Notice(text: notice),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () =>
                      ShellScope.of(context)?.go(Section.resultados),
                  child: Text(l.apuracaoSeeResults),
                ),
              ),
              const SizedBox(height: Space.x3),
            ],
            if (showLive)
              ..._liveBody(context, wide, status, liveFrame)
            else
              ..._body(context, wide),
          ],
        );
      },
    );
  }

  /// Before any live file: when the live count starts, or that it has.
  String? _liveNotice(BuildContext context, LiveStatus? s) {
    final round = s?.round, opens = s?.opensAt;
    if (s == null || round == null || opens == null) return null;
    final l = context.l10n;
    if (s.open) return l.apuracaoLiveWaiting(round);
    if (opens.isAfter(DateTime.now())) {
      return l.apuracaoLiveSoon(round, context.day(opens));
    }
    return null;
  }

  static FileCode _resultFile(int election, String scope) {
    final e6 = election.toString().padLeft(6, '0');
    final name = '$scope-c0001-e$e6-u.json';
    return FileCode(
      name,
      url: scope.startsWith('<')
          ? null
          : Uri.parse(
              'https://resultados.tse.jus.br/oficial/ele2026/$election/dados/$scope/$name',
            ),
    );
  }

  /// Panels from the latest live files the server stored.
  List<Widget> _liveBody(
    BuildContext context,
    bool wide,
    LiveStatus status,
    TallyFrame frame,
  ) {
    final l = context.l10n;
    final code = status.electionCode!;
    final round = status.round ?? 1;
    final brFile = _resultFile(code, 'br');
    final ufFiles = _resultFile(code, '<uf>');
    final updated = l.apuracaoUpdatedAt(context.hm(frame.at));
    final diverging = frame.statesPct - frame.nationalPct > _divergenceGap;

    final duo = Plate(
      title: l.apuracaoDuoTitle,
      trailing: status.open ? const LiveStamp() : null,
      fonte: FonteLine(
        plateNumber: 5,
        source: l.apuracaoDuoSource,
        codes: [brFile, ufFiles],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_live!.stale)
            Padding(
              padding: const EdgeInsets.only(bottom: Space.x4),
              child: _Notice(text: l.apuracaoLiveStale(context.hm(frame.at))),
            ),
          AnimatedSwitcher(
            duration: Motion.of(context, Motion.standard),
            child: diverging
                ? Padding(
                    padding: const EdgeInsets.only(bottom: Space.x4),
                    child: DivergenceBanner(
                      onLearnMore: () =>
                          ShellScope.of(context)?.go(Section.entenda),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          SourceDuo(
            national: frame.nationalPct,
            states: frame.statesPct,
            nationalNote: frame.missingScopes.contains('br')
                ? l.apuracaoLiveNoNational
                : updated,
            statesNote: updated,
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
      momentLabel: context.hm(frame.at),
    );

    final votes = Plate(
      title: l.apuracaoVotesTitle,
      fonte: FonteLine(
        plateNumber: 6,
        source: l.apuracaoVotesSource,
        codes: [brFile],
      ),
      child: MirroredBars(
        rows: [
          for (final c in frame.candidates)
            MirroredRow(_candidateLabel(l, c), c.national, c.states),
        ],
      ),
    );

    final timeline = status.timeline.length < 2
        ? null
        : Plate(
            title: l.apuracaoLiveTimelineTitle(round),
            fonte: FonteLine(
              plateNumber: 7,
              source: l.apuracaoLiveTimelineSource,
            ),
            child: TimelineChart(
              samples: [
                for (final p in status.timeline)
                  TimelineSample(brasilia(p.at), p.nationalPct, p.statesPct),
              ],
              now: status.timeline.length - 1,
            ),
          );

    return _layout(wide, duo: duo, map: map, votes: votes, timeline: timeline);
  }

  static List<Widget> _layout(
    bool wide, {
    required Widget duo,
    required Widget map,
    required Widget votes,
    Widget? timeline,
  }) {
    const gap = SizedBox(height: Space.x5, width: Space.x5);
    return [
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
      if (timeline != null) ...[gap, timeline],
    ];
  }

  List<Widget> _body(BuildContext context, bool wide) {
    final r = _replay!;
    final l = context.l10n;
    String clock(DateTime t) => context.hm(t);
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
      clock: clock(now),
      playing: r.playing,
      speed: r.speed,
      onPlayPause: r.togglePlay,
      onSpeed: r.setSpeed,
      onJumpToFreeze: r.jumpToFreeze,
    );

    final duo = Plate(
      title: l.apuracaoDuoTitle,
      trailing: simulation ? const SimulationStamp() : null,
      fonte: FonteLine(
        plateNumber: 5,
        source: l.apuracaoDuoSource,
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
                      onLearnMore: () =>
                          ShellScope.of(context)?.go(Section.entenda),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          SourceDuo(
            national: frame.nationalPct,
            states: frame.statesPct,
            nationalNote: frozen
                ? l.apuracaoFrozenSince(clock(night.freezeStart))
                : l.apuracaoUpdatedAt(clock(frame.at)),
            statesNote: l.apuracaoUpdatedAt(clock(frame.at)),
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
      momentLabel: clock(frame.at),
      simulation: simulation,
    );

    final votes = Plate(
      title: l.apuracaoVotesTitle,
      fonte: FonteLine(
        plateNumber: 6,
        source: frame.origin == DataOrigin.synthetic
            ? l.apuracaoVotesSourceSynthetic
            : l.apuracaoVotesSource,
        codes: [_brFile],
        simulation: simulation,
      ),
      child: MirroredBars(
        rows: [
          for (final c in frame.candidates)
            MirroredRow(_candidateLabel(l, c), c.national, c.states),
        ],
      ),
    );

    final freezeIndex = night.freezeStart.difference(night.start).inMinutes;
    final timeline = Plate(
      title: l.apuracaoTimelineTitle,
      fonte: FonteLine(
        plateNumber: 7,
        source: l.apuracaoTimelineSource(context.percent(64.81)),
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

    return [
      replay,
      const SizedBox(height: Space.x5),
      ..._layout(wide, duo: duo, map: map, votes: votes, timeline: timeline),
    ];
  }

  static String _candidateLabel(AppLocalizations l, CandidateVotes c) {
    final name = c.ballotName;
    if (name == null) return l.apuracaoCandidateNumber(c.candidateNumber);
    return '${c.candidateNumber} · $name (${c.party})';
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: p.plate,
          border: Border.all(color: p.rule),
          borderRadius: BorderRadius.circular(Corner.plate),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Space.x4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(AtlasIcons.pending(context), size: 18, color: p.inkMuted),
              const SizedBox(width: Space.x3),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final l = context.l10n;
    final message = error is ReplayUnavailableException
        ? l.apuracaoReplayUnavailable
        : l.apuracaoServerUnreachable;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.x6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: t.bodyLarge),
          const SizedBox(height: Space.x4),
          FilledButton(onPressed: onRetry, child: Text(l.apuracaoRetry)),
        ],
      ),
    );
  }
}

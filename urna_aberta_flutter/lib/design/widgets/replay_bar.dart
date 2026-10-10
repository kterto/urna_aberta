import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../platform.dart';
import '../tokens.dart';
import '../typography.dart';
import 'atlas_components.dart';

/// Virtual-clock controls for the 1st-round replay.
class ReplayBar extends StatelessWidget {
  const ReplayBar({
    super.key,
    required this.clock,
    required this.playing,
    required this.speed,
    required this.onPlayPause,
    required this.onSpeed,
    required this.onJumpToFreeze,
  });

  final String clock;
  final bool playing;
  final int speed;
  final VoidCallback onPlayPause;
  final ValueChanged<int> onSpeed;
  final VoidCallback onJumpToFreeze;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final l = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.plate,
        border: Border.all(color: p.rule),
        borderRadius: BorderRadius.circular(Corner.plate),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.x2,
          vertical: Space.x1,
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Space.x3,
          runSpacing: Space.x1,
          children: [
            IconButton.filled(
              tooltip: playing ? l.replayPause : l.replayPlay,
              onPressed: onPlayPause,
              icon: Icon(
                playing ? AtlasIcons.pause(context) : AtlasIcons.play(context),
              ),
              style: IconButton.styleFrom(
                backgroundColor: p.shell,
                foregroundColor: p.onShell,
              ),
            ),
            Semantics(
              label: l.replayClock(clock),
              excludeSemantics: true,
              child: Text(
                clock,
                style: AtlasType.figureM.copyWith(color: p.ink),
              ),
            ),
            AtlasSegmented<int>(
              segments: const {1: '1×', 10: '10×', 60: '60×'},
              selected: speed,
              onChanged: onSpeed,
            ),
            TextButton(
              onPressed: onJumpToFreeze,
              child: Text(l.replayJumpToFreeze),
            ),
            SimulationStamp(label: l.replaySimulated),
          ],
        ),
      ),
    );
  }
}

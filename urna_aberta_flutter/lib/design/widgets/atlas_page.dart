import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform.dart';
import '../tokens.dart';

/// Top-level screen frame. iOS: collapsing large title. Android: Material
/// large top app bar. Wide web: the masthead already names the section, so
/// the page opens with an editorial headline instead.
class AtlasPage extends StatelessWidget {
  const AtlasPage({
    super.key,
    required this.title,
    required this.children,
    this.lede,
    this.actions = const [],
    this.maxWidth = 1240,
    this.showBack = false,
  });

  final String title;
  final String? lede;
  final List<Widget> children;
  final List<Widget> actions;
  final double maxWidth;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final kind = shellKindOf(context);
    final wide = isWideLayout(context);
    final gutter = wide ? Space.x6 : Space.x4;

    Widget content(List<Widget> extra) => SliverPadding(
      padding: EdgeInsets.fromLTRB(gutter, 0, gutter, Space.x8),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [...extra, ...children],
            ),
          ),
        ),
      ),
    );

    final ledeText = lede == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(bottom: Space.x5),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Text(
                lede!,
                style: (wide ? t.bodyLarge : t.bodyMedium)?.copyWith(
                  color: p.inkSecondary,
                ),
              ),
            ),
          );

    if (wide && kind == ShellKind.web) {
      return CustomScrollView(
        slivers: [
          content([
            const SizedBox(height: Space.x7),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (showBack) const BackButton(),
                Expanded(child: Text(title, style: t.displayMedium)),
                ...actions,
              ],
            ),
            const SizedBox(height: Space.x3),
            ?ledeText,
          ]),
        ],
      );
    }

    final bar = kind == ShellKind.ios
        ? CupertinoSliverNavigationBar(
            largeTitle: Text(title),
            backgroundColor: p.paper.withValues(alpha: 0.92),
            border: Border(bottom: BorderSide(color: p.rule, width: 0.5)),
            trailing: actions.isEmpty
                ? null
                : Row(mainAxisSize: MainAxisSize.min, children: actions),
          )
        : SliverAppBar.large(
            title: Text(title),
            actions: actions,
            backgroundColor: p.paper,
          );

    return CustomScrollView(
      slivers: [
        bar,
        content([const SizedBox(height: Space.x3), ?ledeText]),
      ],
    );
  }
}

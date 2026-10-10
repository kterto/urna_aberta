import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../design/platform.dart';
import '../design/tokens.dart';
import '../l10n/l10n.dart';
import '../screens/apuracao_screen.dart';
import '../screens/entenda_screen.dart';
import '../screens/secao_screen.dart';
import '../screens/verificar_screen.dart';
import 'app.dart';

class Destination {
  const Destination(this._label, this.icon);

  final String Function(AppLocalizations) _label;
  final IconData Function(BuildContext) icon;

  String label(BuildContext context) => _label(context.l10n);
}

final destinations = <Destination>[
  Destination((l) => l.navApuracao, AtlasIcons.apuracao),
  Destination((l) => l.navSecao, AtlasIcons.secao),
  Destination((l) => l.navVerificar, AtlasIcons.verificar),
  Destination((l) => l.navEntenda, AtlasIcons.entenda),
];

/// Lets any screen switch the top-level section (e.g. banner → Entenda).
class ShellScope extends InheritedWidget {
  const ShellScope({super.key, required this.go, required super.child});

  final ValueChanged<int> go;

  static ShellScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellScope>();

  @override
  bool updateShouldNotify(ShellScope old) => false;
}

/// One shell, three idioms: masthead on wide web, navigation rail on wide
/// native, iOS tab bar or Material navigation bar on phones.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = <Widget>[
    ApuracaoScreen(),
    SecaoScreen(),
    VerificarScreen(),
    EntendaScreen(),
  ];

  void _go(int i) {
    if (i == _index) return;
    selectionHaptic();
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final kind = shellKindOf(context);
    final wide = isWideLayout(context);
    final body = ShellScope(
      go: _go,
      child: IndexedStack(index: _index, children: _pages),
    );

    if (wide && kind == ShellKind.web) {
      return Scaffold(
        body: Column(
          children: [
            _Masthead(index: _index, onSelect: _go),
            Expanded(child: body),
          ],
        ),
      );
    }

    if (wide) {
      final p = context.atlas;
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: _go,
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: Space.x4),
                child: _Wordmark(color: p.onShell, compact: true),
              ),
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon(context)),
                    label: Text(d.label(context)),
                  ),
              ],
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    if (kind == ShellKind.ios) {
      return Scaffold(
        body: body,
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: _index,
          onTap: _go,
          items: [
            for (final d in destinations)
              BottomNavigationBarItem(
                icon: Icon(d.icon(context)),
                label: d.label(context),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: [
          for (final d in destinations)
            NavigationDestination(
              icon: Icon(d.icon(context)),
              label: d.label(context),
            ),
        ],
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.color, this.compact = false});

  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final mark = CustomPaint(
      size: const Size(26, 26),
      painter: _BallotMark(color, [
        for (final r in Regiao.values) context.atlas.region(r),
      ]),
    );
    if (compact) return Semantics(label: 'Urna Aberta', child: mark);
    return Semantics(
      label: 'Urna Aberta',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          mark,
          const SizedBox(width: 10),
          Text(
            'Urna Aberta',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// The wordmark glyph, same as the launcher icon (assets/brand/): a ballot
/// with a check rising from a ballot box whose front carries the five region
/// legend keys.
class _BallotMark extends CustomPainter {
  _BallotMark(this.color, this.regions);

  final Color color;
  final List<Color> regions;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 26);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(8, 11)
        ..lineTo(8, 3.2)
        ..quadraticBezierTo(8, 2, 9.2, 2)
        ..lineTo(16.8, 2)
        ..quadraticBezierTo(18, 2, 18, 3.2)
        ..lineTo(18, 11),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(10.9, 6.7)
        ..lineTo(12.5, 8.3)
        ..lineTo(15.2, 5.6),
      p,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(1, 11, 24, 13),
        const Radius.circular(1.4),
      ),
      p,
    );
    for (var i = 0; i < regions.length; i++) {
      canvas.drawRect(
        Rect.fromLTWH(4 + i * 3.8, 17, 2.8, 4),
        Paint()..color = regions[i],
      );
    }
  }

  @override
  bool shouldRepaint(_BallotMark old) =>
      old.color != color || old.regions != regions;
}

class _Masthead extends StatelessWidget {
  const _Masthead({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return Material(
      color: p.shell,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Space.x6,
                vertical: Space.x2,
              ),
              child: Row(
                children: [
                  _Wordmark(color: p.onShell),
                  const Spacer(),
                  for (var i = 0; i < destinations.length; i++)
                    _MastLink(
                      label: destinations[i].label(context),
                      selected: i == index,
                      onTap: () => onSelect(i),
                    ),
                  const SizedBox(width: Space.x4),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeModeNotifier,
                    builder: (context, mode, _) => _MastSegmented<ThemeMode>(
                      segments: [
                        (ThemeMode.light, context.l10n.themeLight),
                        (ThemeMode.system, context.l10n.themeSystem),
                        (ThemeMode.dark, context.l10n.themeDark),
                      ],
                      selected: mode,
                      onSelected: (m) => themeModeNotifier.value = m,
                    ),
                  ),
                  const SizedBox(width: Space.x2),
                  // Device language until the viewer picks one.
                  _MastSegmented<String>(
                    segments: const [('pt', 'PT'), ('en', 'EN')],
                    selected: Localizations.localeOf(context).languageCode,
                    onSelected: (code) => localeNotifier.value = Locale(code),
                    semanticsLabel: context.l10n.language,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MastSegmented<T extends Object> extends StatelessWidget {
  const _MastSegmented({
    required this.segments,
    required this.selected,
    required this.onSelected,
    this.semanticsLabel,
  });

  final List<(T, String)> segments;
  final T selected;
  final ValueChanged<T> onSelected;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
    final control = SegmentedButton<T>(
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        side: WidgetStatePropertyAll(
          BorderSide(color: p.onShell.withValues(alpha: 0.3)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) =>
              s.contains(WidgetState.selected) ? p.onShell : Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.shell : p.onShellMuted,
        ),
        textStyle: WidgetStatePropertyAll(t.labelSmall),
      ),
      segments: [
        for (final (value, label) in segments)
          ButtonSegment(value: value, label: Text(label)),
      ],
      selected: {selected},
      onSelectionChanged: (s) => onSelected(s.first),
    );
    return semanticsLabel == null
        ? control
        : Semantics(label: semanticsLabel, child: control);
  }
}

class _MastLink extends StatelessWidget {
  const _MastLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    return Semantics(
      selected: selected,
      child: TextButton(
        onPressed: onTap,
        style:
            TextButton.styleFrom(
              foregroundColor: selected ? p.onShell : p.onShellMuted,
              textStyle: Theme.of(context).textTheme.labelLarge,
              shape: const RoundedRectangleBorder(),
            ).copyWith(
              overlayColor: WidgetStatePropertyAll(
                p.onShell.withValues(alpha: 0.08),
              ),
            ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? p.onShell : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(decoration: TextDecoration.none),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../design/platform.dart';
import '../design/tokens.dart';
import '../screens/apuracao_screen.dart';
import '../screens/entenda_screen.dart';
import '../screens/secao_screen.dart';
import '../screens/verificar_screen.dart';
import '../showcase/design_system_screen.dart';
import 'app.dart';

class Destination {
  const Destination(this.label, this.icon);

  final String label;
  final IconData Function(BuildContext) icon;
}

final destinations = <Destination>[
  const Destination('Apuração', AtlasIcons.apuracao),
  const Destination('Minha seção', AtlasIcons.secao),
  const Destination('Verificar', AtlasIcons.verificar),
  const Destination('Entenda', AtlasIcons.entenda),
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
                    label: Text(d.label),
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
                label: d.label,
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
            NavigationDestination(icon: Icon(d.icon(context)), label: d.label),
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
      painter: _BallotMark(color),
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

/// The wordmark glyph: an open ballot box with a check.
class _BallotMark extends CustomPainter {
  _BallotMark(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 26;
    canvas.scale(s);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(1, 9, 24, 16),
        const Radius.circular(1.5),
      ),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(7, 9)
        ..lineTo(7, 4.5)
        ..quadraticBezierTo(7, 3, 8.5, 3)
        ..lineTo(17.5, 3)
        ..quadraticBezierTo(19, 3, 19, 4.5)
        ..lineTo(19, 9),
      p,
    );
    canvas.drawPath(
      Path()
        ..moveTo(9, 15.5)
        ..lineTo(11.6, 18.1)
        ..lineTo(17, 12.7),
      p..strokeWidth = 2.2,
    );
  }

  @override
  bool shouldRepaint(_BallotMark old) => old.color != color;
}

class _Masthead extends StatelessWidget {
  const _Masthead({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final p = context.atlas;
    final t = Theme.of(context).textTheme;
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
                      label: destinations[i].label,
                      selected: i == index,
                      onTap: () => onSelect(i),
                    ),
                  _MastLink(
                    label: 'Sistema',
                    selected: false,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const DesignSystemScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.x4),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeModeNotifier,
                    builder: (context, mode, _) => SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        side: WidgetStatePropertyAll(
                          BorderSide(color: p.onShell.withValues(alpha: 0.3)),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (s) => s.contains(WidgetState.selected)
                              ? p.onShell
                              : Colors.transparent,
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith(
                          (s) => s.contains(WidgetState.selected)
                              ? p.shell
                              : p.onShellMuted,
                        ),
                        textStyle: WidgetStatePropertyAll(t.labelSmall),
                      ),
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Claro'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('Sistema'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Escuro'),
                        ),
                      ],
                      selected: {mode},
                      onSelectionChanged: (s) =>
                          themeModeNotifier.value = s.first,
                    ),
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

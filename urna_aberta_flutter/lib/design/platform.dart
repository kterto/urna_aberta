import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

/// How the shell should behave. One brand everywhere; idioms per platform.
enum ShellKind { ios, android, web }

ShellKind shellKindOf(BuildContext context) {
  if (kIsWeb) return ShellKind.web;
  return switch (Theme.of(context).platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => ShellKind.ios,
    _ => ShellKind.android,
  };
}

bool isWideLayout(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= Breakpoint.medium;

/// Icons resolve to SF-style Cupertino glyphs on iOS, Material elsewhere.
abstract final class AtlasIcons {
  static IconData _pick(BuildContext c, IconData ios, IconData md) =>
      shellKindOf(c) == ShellKind.ios ? ios : md;

  static IconData apuracao(BuildContext c) =>
      _pick(c, CupertinoIcons.chart_bar_alt_fill, Icons.bar_chart_rounded);
  static IconData secao(BuildContext c) =>
      _pick(c, CupertinoIcons.location, Icons.place_outlined);
  static IconData verificar(BuildContext c) =>
      _pick(c, CupertinoIcons.checkmark_shield, Icons.verified_user_outlined);
  static IconData entenda(BuildContext c) =>
      _pick(c, CupertinoIcons.book, Icons.menu_book_outlined);
  static IconData sistema(BuildContext c) =>
      _pick(c, CupertinoIcons.square_grid_2x2, Icons.grid_view_outlined);
  static IconData external(BuildContext c) =>
      _pick(c, CupertinoIcons.arrow_up_right_square, Icons.open_in_new);
  static IconData copy(BuildContext c) =>
      _pick(c, CupertinoIcons.doc_on_doc, Icons.copy_outlined);
  static IconData valid(BuildContext c) =>
      _pick(c, CupertinoIcons.checkmark_seal_fill, Icons.check_circle);
  static IconData invalid(BuildContext c) =>
      _pick(c, CupertinoIcons.xmark_octagon_fill, Icons.cancel);
  static IconData pending(BuildContext c) =>
      _pick(c, CupertinoIcons.clock, Icons.schedule);
  static IconData warning(BuildContext c) =>
      _pick(c, CupertinoIcons.exclamationmark_triangle, Icons.warning_amber);
  static IconData play(BuildContext c) =>
      _pick(c, CupertinoIcons.play_fill, Icons.play_arrow_rounded);
  static IconData pause(BuildContext c) =>
      _pick(c, CupertinoIcons.pause_fill, Icons.pause_rounded);
  static IconData table(BuildContext c) =>
      _pick(c, CupertinoIcons.table, Icons.table_rows_outlined);
  static IconData theme(BuildContext c) =>
      _pick(c, CupertinoIcons.circle_lefthalf_fill, Icons.contrast);
}

/// Light-touch haptic on selection; a no-op on web.
void selectionHaptic() {
  if (!kIsWeb) HapticFeedback.selectionClick();
}

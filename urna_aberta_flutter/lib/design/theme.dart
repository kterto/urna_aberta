import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

/// Builds the Urna Aberta theme. Material 3 drives Android and web; the same
/// palette feeds [CupertinoThemeData] so native iOS controls match.
ThemeData atlasTheme(Brightness brightness) {
  final p = brightness == Brightness.light
      ? AtlasPalette.light
      : AtlasPalette.dark;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: p.shell,
    onPrimary: p.onShell,
    primaryContainer: p.regionTint(Regiao.sudeste),
    onPrimaryContainer: p.ink,
    secondary: p.sourceStates,
    onSecondary: brightness == Brightness.light ? p.plate : p.paper,
    secondaryContainer: p.plateSunk,
    onSecondaryContainer: p.ink,
    tertiary: p.region(Regiao.nordeste),
    onTertiary: p.plate,
    error: p.statusInvalid,
    onError: brightness == Brightness.light ? p.plate : p.paper,
    surface: p.plate,
    onSurface: p.ink,
    onSurfaceVariant: p.inkSecondary,
    surfaceContainerLowest: p.plate,
    surfaceContainerLow: p.plate,
    surfaceContainer: p.paper,
    surfaceContainerHigh: p.plateSunk,
    surfaceContainerHighest: p.plateSunk,
    outline: p.ruleStrong,
    outlineVariant: p.rule,
    inverseSurface: p.ink,
    onInverseSurface: p.paper,
    inversePrimary: p.onShellMuted,
    shadow: const Color(0xFF000000),
    scrim: const Color(0xFF000000),
    surfaceTint: Colors.transparent,
  );

  final text = AtlasType.textTheme().apply(
    bodyColor: p.ink,
    displayColor: p.ink,
  );

  final controlShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Corner.control),
  );
  const minTarget = Size(48, 48);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: p.paper,
    canvasColor: p.paper,
    fontFamily: AtlasFonts.sans,
    textTheme: text,
    extensions: [p],
    splashFactory: InkSparkle.splashFactory,
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    dividerTheme: DividerThemeData(
      color: p.rule,
      thickness: Stroke.rule,
      space: 1,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: p.focus,
      selectionColor: p.sourceStates.withValues(alpha: 0.28),
      selectionHandleColor: p.focus,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(p.ruleStrong),
      thickness: const WidgetStatePropertyAll(6),
      radius: const Radius.circular(3),
    ),
    focusColor: p.focus.withValues(alpha: 0.16),
    appBarTheme: AppBarTheme(
      backgroundColor: p.paper,
      foregroundColor: p.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.titleLarge,
      shape: Border(bottom: BorderSide(color: p.rule)),
    ),
    cardTheme: CardThemeData(
      color: p.plate,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corner.plate),
        side: BorderSide(color: p.rule),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: p.shell,
        foregroundColor: p.onShell,
        disabledBackgroundColor: p.plateSunk,
        disabledForegroundColor: p.inkMuted,
        minimumSize: minTarget,
        padding: const EdgeInsets.symmetric(horizontal: Space.x5),
        shape: controlShape,
        textStyle: text.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.ink,
        minimumSize: minTarget,
        padding: const EdgeInsets.symmetric(horizontal: Space.x5),
        shape: controlShape,
        side: BorderSide(color: p.ruleStrong),
        textStyle: text.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: p.ink,
        minimumSize: minTarget,
        shape: controlShape,
        textStyle: text.labelLarge?.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: p.ruleStrong,
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: p.ink,
        minimumSize: minTarget,
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(48, 44)),
        shape: WidgetStatePropertyAll(controlShape),
        side: WidgetStatePropertyAll(BorderSide(color: p.ruleStrong)),
        textStyle: WidgetStatePropertyAll(text.labelMedium),
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.shell : p.plate,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.onShell : p.ink,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: p.plate,
      selectedColor: p.ink,
      checkmarkColor: p.paper,
      side: BorderSide(color: p.ruleStrong),
      shape: controlShape,
      labelStyle: text.labelMedium?.copyWith(
        color: WidgetStateColor.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.paper : p.ink,
        ),
      ),
      secondaryLabelStyle: text.labelMedium?.copyWith(color: p.paper),
      padding: const EdgeInsets.symmetric(horizontal: Space.x2),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.plate,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Space.x4,
        vertical: Space.x3,
      ),
      labelStyle: text.bodyMedium?.copyWith(color: p.inkSecondary),
      floatingLabelStyle: text.labelMedium?.copyWith(color: p.ink),
      hintStyle: text.bodyMedium?.copyWith(color: p.inkMuted),
      helperStyle: text.bodySmall?.copyWith(color: p.inkSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corner.control),
        borderSide: BorderSide(color: p.ruleStrong),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corner.control),
        borderSide: BorderSide(color: p.ruleStrong),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corner.control),
        borderSide: BorderSide(color: p.focus, width: Stroke.focus),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Corner.control),
        borderSide: BorderSide(color: p.statusInvalid),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.plate,
      surfaceTintColor: Colors.transparent,
      indicatorColor: p.plateSunk,
      indicatorShape: controlShape,
      elevation: 0,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => text.labelSmall?.copyWith(
          color: s.contains(WidgetState.selected) ? p.ink : p.inkSecondary,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          color: s.contains(WidgetState.selected) ? p.ink : p.inkSecondary,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: p.shell,
      indicatorColor: p.onShell.withValues(alpha: 0.14),
      indicatorShape: controlShape,
      selectedIconTheme: IconThemeData(color: p.onShell),
      unselectedIconTheme: IconThemeData(color: p.onShellMuted),
      selectedLabelTextStyle: text.labelMedium?.copyWith(color: p.onShell),
      unselectedLabelTextStyle: text.labelMedium?.copyWith(
        color: p.onShellMuted,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.plate,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: p.ruleStrong,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Corner.sheet),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.ink,
      contentTextStyle: text.bodyMedium?.copyWith(color: p.paper),
      actionTextColor: p.paper,
      behavior: SnackBarBehavior.floating,
      shape: controlShape,
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: p.ink,
        borderRadius: BorderRadius.circular(Corner.control),
      ),
      textStyle: text.bodySmall?.copyWith(color: p.paper),
      waitDuration: const Duration(milliseconds: 300),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: p.inkSecondary,
      textColor: p.ink,
      minVerticalPadding: Space.x3,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? p.onShell : p.inkSecondary,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? p.shell : p.plateSunk,
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: p.ink,
      inactiveTrackColor: p.rule,
      thumbColor: p.ink,
      overlayColor: p.focus.withValues(alpha: 0.12),
      trackHeight: 2,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: p.sourceStates,
      linearTrackColor: p.plateSunk,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: brightness,
      primaryColor: p.brightnessAwareTint(brightness),
      scaffoldBackgroundColor: p.paper,
      barBackgroundColor: p.plate.withValues(alpha: 0.92),
    ),
  );
}

extension on AtlasPalette {
  /// iOS tint: one color drives interactive elements.
  Color brightnessAwareTint(Brightness b) =>
      b == Brightness.light ? shell : focus;
}

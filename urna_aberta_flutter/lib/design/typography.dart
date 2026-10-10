import 'package:flutter/material.dart';

/// Atlas lettering. Archivo (variable weight + width) carries UI, data and
/// map labels; Source Serif 4 (variable optical size) carries reading text.
/// Both are bundled so the app renders offline and on weak connections.
abstract final class AtlasFonts {
  static const sans = 'Archivo';
  static const serif = 'SourceSerif4';
}

const _tabular = [FontFeature.tabularFigures(), FontFeature.liningFigures()];

TextStyle _sans(
  double size,
  double weight, {
  double width = 100,
  double height = 1.3,
  double tracking = 0,
  bool tabular = false,
}) {
  return TextStyle(
    fontFamily: AtlasFonts.sans,
    fontSize: size,
    height: height,
    letterSpacing: tracking,
    fontWeight: _nearest(weight),
    fontVariations: [
      FontVariation('wght', weight),
      FontVariation('wdth', width),
    ],
    fontFeatures: tabular ? _tabular : null,
  );
}

TextStyle _serif(double size, double weight, {double height = 1.5}) {
  return TextStyle(
    fontFamily: AtlasFonts.serif,
    fontSize: size,
    height: height,
    fontWeight: _nearest(weight),
    fontVariations: [
      FontVariation('wght', weight),
      FontVariation('opsz', size.clamp(8, 60)),
    ],
  );
}

FontWeight _nearest(double w) =>
    FontWeight.values[((w / 100).round() - 1).clamp(0, 8)];

/// Semantic styles beyond the Material roles. Colors are applied by widgets
/// from [AtlasPalette]; these styles carry shape only.
abstract final class AtlasType {
  /// The comparison figures: TSE national file vs sum of states.
  static final figureXL = _sans(
    60,
    760,
    width: 86,
    height: 1,
    tracking: -1.8,
    tabular: true,
  );
  static final figureL = _sans(
    36,
    720,
    width: 88,
    height: 1.05,
    tracking: -0.9,
    tabular: true,
  );
  static final figureM = _sans(22, 680, width: 90, height: 1.1, tabular: true);

  /// Editorial headline for Learn chapters and web section openers.
  static final display = _serif(44, 620, height: 1.08);
  static final headlineSerif = _serif(30, 600, height: 1.15);

  /// Plate (figure) titles.
  static final plateTitle = _sans(16, 660, height: 1.25);

  /// UF siglas and region names on the map.
  static final mapLabel = _sans(
    11,
    720,
    width: 75,
    height: 1,
    tracking: 0.6,
  );
  static final mapRegionLabel = _sans(
    12,
    600,
    width: 125,
    height: 1,
    tracking: 2.4,
  );

  /// "Fonte:" source lines under every plate.
  static final source = _sans(12, 430, width: 92, height: 1.35, tabular: true);

  /// TSE file codes used as catalog numbers (EA20 · c0001 · ba).
  static final fileCode = _sans(
    12,
    640,
    width: 82,
    height: 1.2,
    tracking: 0.4,
    tabular: true,
  );

  /// Long-form reading (Learn).
  static final reading = _serif(18, 400, height: 1.6);

  /// Table and legend figures.
  static final tableFigure = _sans(14, 520, width: 92, tabular: true);
  static final legend = _sans(12.5, 520, width: 92, height: 1.25);

  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: _serif(56, 620, height: 1.04),
      displayMedium: display,
      displaySmall: _serif(36, 600, height: 1.1),
      headlineLarge: _sans(32, 720, width: 92, height: 1.12, tracking: -0.6),
      headlineMedium: _sans(26, 700, width: 94, height: 1.15, tracking: -0.4),
      headlineSmall: _sans(22, 680, width: 96, height: 1.2, tracking: -0.2),
      titleLarge: _sans(20, 660, height: 1.25),
      titleMedium: _sans(16, 640, height: 1.3),
      titleSmall: _sans(14, 640, height: 1.3),
      bodyLarge: _sans(17, 420, height: 1.45),
      bodyMedium: _sans(15, 420, height: 1.45),
      bodySmall: _sans(13, 420, height: 1.4),
      labelLarge: _sans(15, 620, height: 1.2),
      labelMedium: _sans(13, 600, width: 94, height: 1.2),
      labelSmall: _sans(11.5, 620, width: 92, height: 1.2, tracking: 0.3),
    );
  }
}

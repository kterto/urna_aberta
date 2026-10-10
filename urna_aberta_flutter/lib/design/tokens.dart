import 'package:flutter/material.dart';

/// The five official IBGE macro-regions, in the atlas reading order.
enum Regiao {
  norte('N', 'Norte', 'North'),
  nordeste('NE', 'Nordeste', 'Northeast'),
  centroOeste('CO', 'Centro-Oeste', 'Center-West'),
  sudeste('SE', 'Sudeste', 'Southeast'),
  sul('S', 'Sul', 'South');

  const Regiao(this.sigla, this.nomePt, this.nomeEn);

  final String sigla;
  final String nomePt;
  final String nomeEn;

  static Regiao fromSigla(String sigla) =>
      values.firstWhere((r) => r.sigla == sigla);
}

/// File and signature verification state. Always rendered with icon + label.
enum VerificationStatus { valid, invalid, pending }

/// Atlas palette. Light is the printed plate; dark is the night plate.
///
/// Region hues and the two source series were run through the dataviz
/// validator (all-pairs CVD and normal-vision floors) on their plate surface.
@immutable
class AtlasPalette extends ThemeExtension<AtlasPalette> {
  const AtlasPalette({
    required this.paper,
    required this.plate,
    required this.plateSunk,
    required this.ink,
    required this.inkSecondary,
    required this.inkMuted,
    required this.rule,
    required this.ruleStrong,
    required this.graticule,
    required this.shell,
    required this.onShell,
    required this.onShellMuted,
    required this.regions,
    required this.regionTints,
    required this.totalizacaoRamp,
    required this.sourceNational,
    required this.sourceStates,
    required this.statusValid,
    required this.statusInvalid,
    required this.statusPending,
    required this.alertGround,
    required this.alertInk,
    required this.alertRule,
    required this.focus,
    required this.halftone,
  });

  /// Page ground.
  final Color paper;

  /// Figure and card surface (the atlas plate).
  final Color plate;

  /// Inset wells: inputs, table stripes, map sea.
  final Color plateSunk;
  final Color ink;
  final Color inkSecondary;
  final Color inkMuted;
  final Color rule;
  final Color ruleStrong;
  final Color graticule;

  /// Committed shell color: masthead, rails, app bar on web.
  final Color shell;
  final Color onShell;
  final Color onShellMuted;

  /// Categorical region fills, fixed order of [Regiao.values].
  final Map<Regiao, Color> regions;

  /// Quiet region tints for grounds, never for data marks.
  final Map<Regiao, Color> regionTints;

  /// Five-class sequential ramp for % sections totalized, low to high.
  final List<Color> totalizacaoRamp;

  /// Series: TSE national file (ink) and independent sum of states (teal).
  final Color sourceNational;
  final Color sourceStates;

  final Color statusValid;
  final Color statusInvalid;
  final Color statusPending;

  /// Divergence banner.
  final Color alertGround;
  final Color alertInk;
  final Color alertRule;

  final Color focus;

  /// Opacity applied to unfocused map features (the signature half-tone).
  final double halftone;

  Color region(Regiao r) => regions[r]!;
  Color regionTint(Regiao r) => regionTints[r]!;

  Color status(VerificationStatus s) => switch (s) {
    VerificationStatus.valid => statusValid,
    VerificationStatus.invalid => statusInvalid,
    VerificationStatus.pending => statusPending,
  };

  /// Ramp class for a 0–100 percentage, class breaks every 20 points.
  Color totalizacao(double pct) {
    final i = (pct.clamp(0, 99.999) / 20).floor();
    return totalizacaoRamp[i];
  }

  static const light = AtlasPalette(
    paper: Color(0xFFF3F5F1),
    plate: Color(0xFFFBFCFA),
    plateSunk: Color(0xFFE9EEEB),
    ink: Color(0xFF16252B),
    inkSecondary: Color(0xFF44565C),
    inkMuted: Color(0xFF5E6F74),
    rule: Color(0xFFD3DBD8),
    ruleStrong: Color(0xFF9AA8A6),
    graticule: Color(0xFFDDE5E2),
    shell: Color(0xFF123A4C),
    onShell: Color(0xFFEEF3F1),
    onShellMuted: Color(0xFFA9C1C8),
    regions: {
      Regiao.norte: Color(0xFF6CC394),
      Regiao.nordeste: Color(0xFFB08137),
      Regiao.centroOeste: Color(0xFFA23E16),
      Regiao.sudeste: Color(0xFF184ED4),
      Regiao.sul: Color(0xFFB43782),
    },
    regionTints: {
      Regiao.norte: Color(0xFFE2F2E8),
      Regiao.nordeste: Color(0xFFF2EADC),
      Regiao.centroOeste: Color(0xFFF3E1DA),
      Regiao.sudeste: Color(0xFFDFE6F8),
      Regiao.sul: Color(0xFFF4E0EB),
    },
    totalizacaoRamp: [
      Color(0xFFDCEFEC),
      Color(0xFFA6D8D1),
      Color(0xFF63B5AE),
      Color(0xFF2E8A8A),
      Color(0xFF135E66),
    ],
    sourceNational: Color(0xFF16252B),
    sourceStates: Color(0xFF1F8A8F),
    statusValid: Color(0xFF2E7D4F),
    statusInvalid: Color(0xFFB3261E),
    statusPending: Color(0xFF8A5A00),
    alertGround: Color(0xFFFFF1D6),
    alertInk: Color(0xFF5C3B00),
    alertRule: Color(0xFFD9A441),
    focus: Color(0xFF184ED4),
    halftone: 0.28,
  );

  static const dark = AtlasPalette(
    paper: Color(0xFF0E1719),
    plate: Color(0xFF132024),
    plateSunk: Color(0xFF0B1315),
    ink: Color(0xFFE4ECEA),
    inkSecondary: Color(0xFFA9BAB8),
    inkMuted: Color(0xFF8A9C9B),
    rule: Color(0xFF24363A),
    ruleStrong: Color(0xFF3A5257),
    graticule: Color(0xFF1B2B2F),
    shell: Color(0xFF0B2C3B),
    onShell: Color(0xFFE4ECEA),
    onShellMuted: Color(0xFF9DB7BF),
    regions: {
      Regiao.norte: Color(0xFF20AB73),
      Regiao.nordeste: Color(0xFF8E6605),
      Regiao.centroOeste: Color(0xFFE16E37),
      Regiao.sudeste: Color(0xFF137CBC),
      Regiao.sul: Color(0xFFBA498E),
    },
    regionTints: {
      Regiao.norte: Color(0xFF12302A),
      Regiao.nordeste: Color(0xFF2A2414),
      Regiao.centroOeste: Color(0xFF33201A),
      Regiao.sudeste: Color(0xFF122838),
      Regiao.sul: Color(0xFF2E1A28),
    },
    totalizacaoRamp: [
      Color(0xFF1A3236),
      Color(0xFF1E5458),
      Color(0xFF2A7F80),
      Color(0xFF4FB0AA),
      Color(0xFF9FE0D6),
    ],
    sourceNational: Color(0xFFE4ECEA),
    sourceStates: Color(0xFF3FB8B5),
    statusValid: Color(0xFF6FCF97),
    statusInvalid: Color(0xFFFF8A80),
    statusPending: Color(0xFFF2B84B),
    alertGround: Color(0xFF2A2414),
    alertInk: Color(0xFFF2D49B),
    alertRule: Color(0xFF8E6605),
    focus: Color(0xFF7FB2FF),
    halftone: 0.3,
  );

  @override
  AtlasPalette copyWith() => this;

  @override
  AtlasPalette lerp(AtlasPalette? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AtlasPalette(
      paper: c(paper, other.paper),
      plate: c(plate, other.plate),
      plateSunk: c(plateSunk, other.plateSunk),
      ink: c(ink, other.ink),
      inkSecondary: c(inkSecondary, other.inkSecondary),
      inkMuted: c(inkMuted, other.inkMuted),
      rule: c(rule, other.rule),
      ruleStrong: c(ruleStrong, other.ruleStrong),
      graticule: c(graticule, other.graticule),
      shell: c(shell, other.shell),
      onShell: c(onShell, other.onShell),
      onShellMuted: c(onShellMuted, other.onShellMuted),
      regions: {
        for (final r in Regiao.values) r: c(region(r), other.region(r)),
      },
      regionTints: {
        for (final r in Regiao.values) r: c(regionTint(r), other.regionTint(r)),
      },
      totalizacaoRamp: [
        for (var i = 0; i < totalizacaoRamp.length; i++)
          c(totalizacaoRamp[i], other.totalizacaoRamp[i]),
      ],
      sourceNational: c(sourceNational, other.sourceNational),
      sourceStates: c(sourceStates, other.sourceStates),
      statusValid: c(statusValid, other.statusValid),
      statusInvalid: c(statusInvalid, other.statusInvalid),
      statusPending: c(statusPending, other.statusPending),
      alertGround: c(alertGround, other.alertGround),
      alertInk: c(alertInk, other.alertInk),
      alertRule: c(alertRule, other.alertRule),
      focus: c(focus, other.focus),
      halftone: halftone + (other.halftone - halftone) * t,
    );
  }
}

/// 4pt spacing scale.
abstract final class Space {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 24;
  static const double x6 = 32;
  static const double x7 = 48;
  static const double x8 = 64;
  static const double x9 = 96;
}

/// Atlas corners are nearly square: plates are cut paper, keys are squares.
abstract final class Corner {
  static const double key = 1;
  static const double control = 4;
  static const double plate = 2;
  static const double sheet = 12;
}

abstract final class Stroke {
  static const double hairline = 0.75;
  static const double rule = 1;
  static const double data = 2;
  static const double regionBorder = 1.6;
  static const double focus = 2;
}

abstract final class Motion {
  static const Duration quick = Duration(milliseconds: 140);
  static const Duration standard = Duration(milliseconds: 240);
  static const Duration emphasis = Duration(milliseconds: 420);
  static const Curve ease = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutExpo;

  static Duration of(BuildContext context, Duration d) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : d;
}

/// Layout breakpoints in logical pixels.
abstract final class Breakpoint {
  static const double compact = 600;
  static const double medium = 905;
  static const double expanded = 1240;
}

extension AtlasContext on BuildContext {
  AtlasPalette get atlas => Theme.of(this).extension<AtlasPalette>()!;
}

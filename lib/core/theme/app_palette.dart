import 'package:flutter/material.dart';

/// Design tokens that Material's [ColorScheme] has no slot for.
///
/// Read them with `context.palette` (see `theme_context.dart`).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentSoft,
    required this.success,
  });

  static const light = AppPalette(
    background: Color(0xFFF7F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceRaised: Color(0xFFEEF1F5),
    border: Color(0xFFDDE2E9),
    textPrimary: Color(0xFF0E1420),
    textSecondary: Color(0xFF3D4757),
    textMuted: Color(0xFF6B7584),
    accent: Color(0xFF0A6FD6),
    accentSoft: Color(0xFFE2EEFB),
    success: Color(0xFF167A4A),
  );

  static const dark = AppPalette(
    background: Color(0xFF0B0F17),
    surface: Color(0xFF121826),
    surfaceRaised: Color(0xFF1A2232),
    border: Color(0xFF263044),
    textPrimary: Color(0xFFEDF1F7),
    textSecondary: Color(0xFFB4BDCB),
    textMuted: Color(0xFF8590A2),
    accent: Color(0xFF54B4FF),
    accentSoft: Color(0xFF14273F),
    success: Color(0xFF4CD39A),
  );

  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentSoft;
  final Color success;

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentSoft,
    Color? success,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      success: success ?? this.success,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
    );
  }
}

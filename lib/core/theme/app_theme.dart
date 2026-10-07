import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_palette.dart';

abstract final class AppTheme {
  static const String bodyFont = 'Inter';
  static const String displayFont = 'SpaceGrotesk';
  static const String monoFont = 'JetBrainsMono';

  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: palette.accent,
          brightness: brightness,
        ).copyWith(
          primary: palette.accent,
          surface: palette.surface,
          onSurface: palette.textPrimary,
          outline: palette.border,
        );

    const display = TextStyle(fontFamily: displayFont);
    const body = TextStyle(fontFamily: bodyFont);

    final textTheme = TextTheme(
      displayLarge: display.copyWith(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        height: 1.05,
        letterSpacing: -1.5,
      ),
      displayMedium: display.copyWith(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: -1,
      ),
      headlineMedium: display.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      titleLarge: display.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: body.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLarge: body.copyWith(fontSize: 18, height: 1.6),
      bodyMedium: body.copyWith(fontSize: 16, height: 1.6),
      bodySmall: body.copyWith(fontSize: 14, height: 1.5),
      labelLarge: body.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      labelMedium: body.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
      labelSmall: const TextStyle(
        fontFamily: monoFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
      ),
    ).apply(bodyColor: palette.textPrimary, displayColor: palette.textPrimary);

    return ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: bodyFont,
      scaffoldBackgroundColor: palette.background,
      textTheme: textTheme,
      dividerColor: palette.border,
      extensions: [palette],
      splashFactory: NoSplash.splashFactory,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: palette.accent.withValues(alpha: 0.25),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: palette.textPrimary,
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: TextStyle(color: palette.background, fontSize: 13),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

/// Paleta "oficina de latão" — verdigris (pátina de cobre/latão) como acento
/// primário sobre um fundo grafite quente, não mais o azul-sobre-navy
/// genérico de dev tool. Ver plano de design (sessão de redesign).
abstract final class AppTheme {
  static const _bgDark = Color(0xFF14120F);
  static const _surfaceDark = Color(0xFF1E1B16);
  static const _borderDark = Color(0xFF342E23);
  static const _accentDark = Color(0xFF4FB39E);
  static const _accentInkDark = Color(0xFF0D1512);
  static const _textDark = Color(0xFFEDE7DD);

  static const _bgLight = Color(0xFFF6F2EA);
  static const _surfaceLight = Color(0xFFFFFFFF);
  static const _borderLight = Color(0xFFDDD4C0);
  static const _accentLight = Color(0xFF2F7D6E);
  static const _textLight = Color(0xFF2A241C);

  static ThemeData dark() {
    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: _accentDark,
      onPrimary: _accentInkDark,
      secondary: DartisanColors.dark.brass,
      onSecondary: DartisanColors.dark.codeBackground,
      surface: _surfaceDark,
      onSurface: _textDark,
      error: DartisanColors.dark.danger,
    );
    return _themeFrom(colorScheme, scaffoldBackground: _bgDark, extra: DartisanColors.dark, border: _borderDark);
  }

  static ThemeData light() {
    final colorScheme = ColorScheme.light(
      primary: _accentLight,
      onPrimary: Colors.white,
      secondary: DartisanColors.light.brass,
      onSecondary: Colors.white,
      surface: _surfaceLight,
      onSurface: _textLight,
      error: DartisanColors.light.danger,
    );
    return _themeFrom(colorScheme, scaffoldBackground: _bgLight, extra: DartisanColors.light, border: _borderLight);
  }

  static ThemeData _themeFrom(
    ColorScheme colorScheme, {
    required Color scaffoldBackground,
    required DartisanColors extra,
    required Color border,
  }) {
    final textTheme = _textTheme(colorScheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      extensions: [extra],
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DartisanRadii.m),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: extra.surface2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DartisanRadii.s),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DartisanRadii.s),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DartisanRadii.s),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        hintStyle: TextStyle(color: extra.textFaint),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DartisanRadii.s)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DartisanRadii.s)),
          side: BorderSide(color: extra.borderStrong),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: extra.surface2,
        side: BorderSide(color: border),
        labelStyle: const TextStyle(fontSize: 12),
        shape: const StadiumBorder(),
      ),
      dividerTheme: DividerThemeData(color: border),
      listTileTheme: ListTileThemeData(iconColor: extra.textFaint),
      tabBarTheme: TabBarThemeData(
        indicatorColor: colorScheme.primary,
        labelColor: colorScheme.onSurface,
        unselectedLabelColor: extra.textFaint,
      ),
    );
  }

  static TextTheme _textTheme(Color bodyColor) {
    final body = GoogleFonts.publicSansTextTheme().apply(bodyColor: bodyColor, displayColor: bodyColor);
    final display = GoogleFonts.frauncesTextTheme().apply(bodyColor: bodyColor, displayColor: bodyColor);

    TextStyle? displayStyle(TextStyle? style) => style?.copyWith(fontWeight: FontWeight.w600);

    return body.copyWith(
      displayLarge: displayStyle(display.displayLarge),
      displayMedium: displayStyle(display.displayMedium),
      displaySmall: displayStyle(display.displaySmall),
      headlineLarge: displayStyle(display.headlineLarge),
      headlineMedium: displayStyle(display.headlineMedium),
      headlineSmall: displayStyle(display.headlineSmall),
      titleLarge: displayStyle(display.titleLarge),
    );
  }
}

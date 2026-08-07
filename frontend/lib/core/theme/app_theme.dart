import 'package:flutter/material.dart';

/// Paleta escura navy/azul inspirada em registros de pacotes (pub.dev-like).
/// O tema claro é um fallback simples — o produto é pensado pro escuro.
abstract final class AppTheme {
  static const _background = Color(0xFF0A0F1E);
  static const _surface = Color(0xFF121A2E);
  static const _surfaceBorder = Color(0xFF1E293B);
  static const _primary = Color(0xFF3B82F6);
  static const _primaryLight = Color(0xFF60A5FA);
  static const _textMuted = Color(0xFF94A3B8);

  static ThemeData dark() {
    final colorScheme = const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _primaryLight,
      surface: _surface,
      onSurface: Color(0xFFE2E8F0),
      error: Color(0xFFF87171),
    );

    return _themeFrom(colorScheme, scaffoldBackground: _background);
  }

  static ThemeData light() {
    const colorScheme = ColorScheme.light(primary: _primary, secondary: _primaryLight);
    return _themeFrom(colorScheme, scaffoldBackground: const Color(0xFFF8FAFC));
  }

  static ThemeData _themeFrom(
    ColorScheme colorScheme, {
    required Color scaffoldBackground,
  }) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? _surfaceBorder : const Color(0xFFE2E8F0);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: const TextTheme().apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        hintStyle: const TextStyle(color: _textMuted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surface,
        side: BorderSide(color: borderColor),
        labelStyle: const TextStyle(fontSize: 12),
        shape: const StadiumBorder(),
      ),
      dividerTheme: DividerThemeData(color: borderColor),
      listTileTheme: const ListTileThemeData(iconColor: _textMuted),
    );
  }

  static const textMuted = _textMuted;
  static const surfaceBorder = _surfaceBorder;
}

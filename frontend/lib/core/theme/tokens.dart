import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta "oficina de latão": verdigris (pátina) como acento primário, latão
/// como segunda voz reservada a destaques. Cobre o que `ColorScheme` não tem
/// slot pra (superfície secundária, texto apagado, fundo de bloco de código)
/// — ver docs/roadmap não, isso é UI; plano em docs do chat de design.
@immutable
class DartisanColors extends ThemeExtension<DartisanColors> {
  final Color surface2;
  final Color borderStrong;
  final Color textFaint;
  final Color accentSoft;
  final Color brass;
  final Color brassSoft;
  final Color success;
  final Color danger;
  final Color codeBackground;

  const DartisanColors({
    required this.surface2,
    required this.borderStrong,
    required this.textFaint,
    required this.accentSoft,
    required this.brass,
    required this.brassSoft,
    required this.success,
    required this.danger,
    required this.codeBackground,
  });

  static const dark = DartisanColors(
    surface2: Color(0xFF262119),
    borderStrong: Color(0xFF493F2E),
    textFaint: Color(0xFF756B5B),
    accentSoft: Color(0xFF1C332E),
    brass: Color(0xFFD4A24E),
    brassSoft: Color(0xFF362B18),
    success: Color(0xFF5FBF83),
    danger: Color(0xFFE0645A),
    codeBackground: Color(0xFF1A1712),
  );

  static const light = DartisanColors(
    surface2: Color(0xFFEFE9DC),
    borderStrong: Color(0xFFC7BBA0),
    textFaint: Color(0xFF948A78),
    accentSoft: Color(0xFFDCEEE9),
    brass: Color(0xFFA87A2E),
    brassSoft: Color(0xFFF2E4C6),
    success: Color(0xFF2E7D4F),
    danger: Color(0xFFB0413E),
    codeBackground: Color(0xFFEFE9DC),
  );

  @override
  DartisanColors copyWith({
    Color? surface2,
    Color? borderStrong,
    Color? textFaint,
    Color? accentSoft,
    Color? brass,
    Color? brassSoft,
    Color? success,
    Color? danger,
    Color? codeBackground,
  }) {
    return DartisanColors(
      surface2: surface2 ?? this.surface2,
      borderStrong: borderStrong ?? this.borderStrong,
      textFaint: textFaint ?? this.textFaint,
      accentSoft: accentSoft ?? this.accentSoft,
      brass: brass ?? this.brass,
      brassSoft: brassSoft ?? this.brassSoft,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      codeBackground: codeBackground ?? this.codeBackground,
    );
  }

  @override
  DartisanColors lerp(ThemeExtension<DartisanColors>? other, double t) {
    if (other is! DartisanColors) return this;
    return DartisanColors(
      surface2: Color.lerp(surface2, other.surface2, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      brass: Color.lerp(brass, other.brass, t)!,
      brassSoft: Color.lerp(brassSoft, other.brassSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      codeBackground: Color.lerp(codeBackground, other.codeBackground, t)!,
    );
  }
}

extension DartisanThemeX on BuildContext {
  DartisanColors get colors => Theme.of(this).extension<DartisanColors>()!;
}

/// Escala de espaço de 4px — mesma escala que já existia implícita nos
/// `SizedBox` soltos das páginas, só que agora nomeada e consistente.
abstract final class DartisanSpacing {
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 24.0;
  static const s6 = 32.0;
  static const s7 = 48.0;
  static const s8 = 64.0;
}

abstract final class DartisanRadii {
  static const s = 6.0;
  static const m = 10.0;
  static const l = 16.0;
}

/// Fonte mono (dados: versão, sha256, pubspec.yaml) — as demais famílias
/// (display serifado, corpo humanista) entram via `textTheme` do ThemeData,
/// essa é chamada direto onde o texto não passa pelo textTheme padrão.
abstract final class DartisanFonts {
  static TextStyle mono({
    double fontSize = 13,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) => GoogleFonts.ibmPlexMono(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );
}

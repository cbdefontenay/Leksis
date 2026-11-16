import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  final baseTextTheme = Theme.of(context).textTheme;
  TextStyle? applyFont(String font, TextStyle? style) =>
      style == null ? null : GoogleFonts.getFont(font, textStyle: style);

  return baseTextTheme.copyWith(
    displayLarge: applyFont(displayFontString, baseTextTheme.displayLarge),
    displayMedium: applyFont(displayFontString, baseTextTheme.displayMedium),
    displaySmall: applyFont(displayFontString, baseTextTheme.displaySmall),
    headlineLarge: applyFont(displayFontString, baseTextTheme.headlineLarge),
    headlineMedium: applyFont(displayFontString, baseTextTheme.headlineMedium),
    headlineSmall: applyFont(displayFontString, baseTextTheme.headlineSmall),
    titleLarge: applyFont(displayFontString, baseTextTheme.titleLarge),
    titleMedium: applyFont(displayFontString, baseTextTheme.titleMedium),
    titleSmall: applyFont(displayFontString, baseTextTheme.titleSmall),
    bodyLarge: applyFont(bodyFontString, baseTextTheme.bodyLarge),
    bodyMedium: applyFont(bodyFontString, baseTextTheme.bodyMedium),
    bodySmall: applyFont(bodyFontString, baseTextTheme.bodySmall),
    labelLarge: applyFont(bodyFontString, baseTextTheme.labelLarge),
    labelMedium: applyFont(bodyFontString, baseTextTheme.labelMedium),
    labelSmall: applyFont(bodyFontString, baseTextTheme.labelSmall),
  );
}

import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff65558f),
      surfaceTint: Color(0xff65558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe9ddff),
      onPrimaryContainer: Color(0xff4d3d75),
      secondary: Color(0xff625b71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe8def8),
      onSecondaryContainer: Color(0xff4a4458),
      tertiary: Color(0xff7e5260),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd9e3),
      onTertiaryContainer: Color(0xff633b48),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff1d1b20),
      onSurfaceVariant: Color(0xff49454e),
      outline: Color(0xff7a757f),
      outlineVariant: Color(0xffcac4cf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff201047),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff4d3d75),
      secondaryFixed: Color(0xffe8def8),
      onSecondaryFixed: Color(0xff1e192b),
      secondaryFixedDim: Color(0xffccc2db),
      onSecondaryFixedVariant: Color(0xff4a4458),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff31101d),
      tertiaryFixedDim: Color(0xffefb8c8),
      onTertiaryFixedVariant: Color(0xff633b48),
      surfaceDim: Color(0xffded8e0),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2fa),
      surfaceContainer: Color(0xfff2ecf4),
      surfaceContainerHigh: Color(0xffece6ee),
      surfaceContainerHighest: Color(0xffe6e0e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3c2c63),
      surfaceTint: Color(0xff65558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff74649f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff393347),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff716a80),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff502b38),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8e606e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff121016),
      onSurfaceVariant: Color(0xff38353d),
      outline: Color(0xff55515a),
      outlineVariant: Color(0xff6f6b75),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xff74649f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff5b4b84),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff716a80),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff585267),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8e606e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff734856),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcac5cc),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2fa),
      surfaceContainer: Color(0xffece6ee),
      surfaceContainerHigh: Color(0xffe1dbe3),
      surfaceContainerHighest: Color(0xffd5d0d8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff322258),
      surfaceTint: Color(0xff65558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4f4078),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2f293c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4c465b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff45212e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff663d4b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2e2b33),
      outlineVariant: Color(0xff4b4851),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xff4f4078),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff382960),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4c465b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff353043),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff663d4b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4c2734),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbcb7bf),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5eff7),
      surfaceContainer: Color(0xffe6e0e9),
      surfaceContainerHigh: Color(0xffd8d2da),
      surfaceContainerHighest: Color(0xffcac5cc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcfbdfe),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff36265d),
      primaryContainer: Color(0xff4d3d75),
      onPrimaryContainer: Color(0xffe9ddff),
      secondary: Color(0xffccc2db),
      onSecondary: Color(0xff332d41),
      secondaryContainer: Color(0xff4a4458),
      onSecondaryContainer: Color(0xffe8def8),
      tertiary: Color(0xffefb8c8),
      onTertiary: Color(0xff4a2532),
      tertiaryContainer: Color(0xff633b48),
      onTertiaryContainer: Color(0xffffd9e3),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff141218),
      onSurface: Color(0xffe6e0e9),
      onSurfaceVariant: Color(0xffcac4cf),
      outline: Color(0xff948f99),
      outlineVariant: Color(0xff49454e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e0e9),
      inversePrimary: Color(0xff65558f),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff201047),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff4d3d75),
      secondaryFixed: Color(0xffe8def8),
      onSecondaryFixed: Color(0xff1e192b),
      secondaryFixedDim: Color(0xffccc2db),
      onSecondaryFixedVariant: Color(0xff4a4458),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff31101d),
      tertiaryFixedDim: Color(0xffefb8c8),
      onTertiaryFixedVariant: Color(0xff633b48),
      surfaceDim: Color(0xff141218),
      surfaceBright: Color(0xff3b383e),
      surfaceContainerLowest: Color(0xff0f0d13),
      surfaceContainerLow: Color(0xff1d1b20),
      surfaceContainer: Color(0xff211f24),
      surfaceContainerHigh: Color(0xff2b292f),
      surfaceContainerHighest: Color(0xff36343a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe3d6ff),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff2b1b52),
      primaryContainer: Color(0xff9887c5),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffe2d8f2),
      onSecondary: Color(0xff282335),
      secondaryContainer: Color(0xff958da4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd0dd),
      onTertiary: Color(0xff3d1a27),
      tertiaryContainer: Color(0xffb58392),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141218),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe0dae5),
      outline: Color(0xffb5b0bb),
      outlineVariant: Color(0xff938e99),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e0e9),
      inversePrimary: Color(0xff4e3f76),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff16033d),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff3c2c63),
      secondaryFixed: Color(0xffe8def8),
      onSecondaryFixed: Color(0xff130e20),
      secondaryFixedDim: Color(0xffccc2db),
      onSecondaryFixedVariant: Color(0xff393347),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff240612),
      tertiaryFixedDim: Color(0xffefb8c8),
      onTertiaryFixedVariant: Color(0xff502b38),
      surfaceDim: Color(0xff141218),
      surfaceBright: Color(0xff46434a),
      surfaceContainerLowest: Color(0xff08070b),
      surfaceContainerLow: Color(0xff1f1d22),
      surfaceContainer: Color(0xff29272d),
      surfaceContainerHigh: Color(0xff343138),
      surfaceContainerHighest: Color(0xff3f3c43),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff5edff),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffcbb9fa),
      onPrimaryContainer: Color(0xff0f0033),
      secondary: Color(0xfff5edff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc8bfd7),
      onSecondaryContainer: Color(0xff0d081a),
      tertiary: Color(0xffffebef),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffebb4c4),
      onTertiaryContainer: Color(0xff1d020c),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff141218),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff4eef9),
      outlineVariant: Color(0xffc6c0cb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e0e9),
      inversePrimary: Color(0xff4e3f76),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff16033d),
      secondaryFixed: Color(0xffe8def8),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffccc2db),
      onSecondaryFixedVariant: Color(0xff130e20),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffefb8c8),
      onTertiaryFixedVariant: Color(0xff240612),
      surfaceDim: Color(0xff141218),
      surfaceBright: Color(0xff524f55),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff211f24),
      surfaceContainer: Color(0xff322f35),
      surfaceContainerHigh: Color(0xff3d3a41),
      surfaceContainerHighest: Color(0xff48464c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

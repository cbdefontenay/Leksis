import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00696e),
      surfaceTint: Color(0xff00696e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9cf0f6),
      onPrimaryContainer: Color(0xff004f53),
      secondary: Color(0xff006971),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff9df0fa),
      onSecondaryContainer: Color(0xff004f55),
      tertiary: Color(0xff5c5891),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffe3dfff),
      onTertiaryContainer: Color(0xff444078),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff4fafa),
      onSurface: Color(0xff161d1d),
      onSurfaceVariant: Color(0xff3f4949),
      outline: Color(0xff6f7979),
      outlineVariant: Color(0xffbec8c9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3232),
      inversePrimary: Color(0xff80d4da),
      primaryFixed: Color(0xff9cf0f6),
      onPrimaryFixed: Color(0xff002022),
      primaryFixedDim: Color(0xff80d4da),
      onPrimaryFixedVariant: Color(0xff004f53),
      secondaryFixed: Color(0xff9df0fa),
      onSecondaryFixed: Color(0xff001f23),
      secondaryFixedDim: Color(0xff81d3dd),
      onSecondaryFixedVariant: Color(0xff004f55),
      tertiaryFixed: Color(0xffe3dfff),
      onTertiaryFixed: Color(0xff18124a),
      tertiaryFixedDim: Color(0xffc5c0ff),
      onTertiaryFixedVariant: Color(0xff444078),
      surfaceDim: Color(0xffd5dbdb),
      surfaceBright: Color(0xfff4fafa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f5),
      surfaceContainer: Color(0xffe9efef),
      surfaceContainerHigh: Color(0xffe3e9e9),
      surfaceContainerHighest: Color(0xffdde4e4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003d40),
      surfaceTint: Color(0xff00696e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff16797e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003d42),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff177881),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff332f66),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6b66a1),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fafa),
      onSurface: Color(0xff0c1213),
      onSurfaceVariant: Color(0xff2e3838),
      outline: Color(0xff4b5455),
      outlineVariant: Color(0xff656f6f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3232),
      inversePrimary: Color(0xff80d4da),
      primaryFixed: Color(0xff16797e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005f63),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff177881),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff005e66),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6b66a1),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff524e87),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc1c8c8),
      surfaceBright: Color(0xfff4fafa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f5),
      surfaceContainer: Color(0xffe3e9e9),
      surfaceContainerHigh: Color(0xffd8dede),
      surfaceContainerHighest: Color(0xffcdd3d3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003235),
      surfaceTint: Color(0xff00696e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005256),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003236),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff005158),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff29255b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff46427a),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fafa),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff242e2e),
      outlineVariant: Color(0xff414b4b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3232),
      inversePrimary: Color(0xff80d4da),
      primaryFixed: Color(0xff005256),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00393c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff005158),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00393e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff46427a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff302b62),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4baba),
      surfaceBright: Color(0xfff4fafa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf2f2),
      surfaceContainer: Color(0xffdde4e4),
      surfaceContainerHigh: Color(0xffcfd6d6),
      surfaceContainerHighest: Color(0xffc1c8c8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff80d4da),
      surfaceTint: Color(0xff80d4da),
      onPrimary: Color(0xff003739),
      primaryContainer: Color(0xff004f53),
      onPrimaryContainer: Color(0xff9cf0f6),
      secondary: Color(0xff81d3dd),
      onSecondary: Color(0xff00363b),
      secondaryContainer: Color(0xff004f55),
      onSecondaryContainer: Color(0xff9df0fa),
      tertiary: Color(0xffc5c0ff),
      onTertiary: Color(0xff2d2960),
      tertiaryContainer: Color(0xff444078),
      onTertiaryContainer: Color(0xffe3dfff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffdde4e4),
      onSurfaceVariant: Color(0xffbec8c9),
      outline: Color(0xff899393),
      outlineVariant: Color(0xff3f4949),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e4),
      inversePrimary: Color(0xff00696e),
      primaryFixed: Color(0xff9cf0f6),
      onPrimaryFixed: Color(0xff002022),
      primaryFixedDim: Color(0xff80d4da),
      onPrimaryFixedVariant: Color(0xff004f53),
      secondaryFixed: Color(0xff9df0fa),
      onSecondaryFixed: Color(0xff001f23),
      secondaryFixedDim: Color(0xff81d3dd),
      onSecondaryFixedVariant: Color(0xff004f55),
      tertiaryFixed: Color(0xffe3dfff),
      onTertiaryFixed: Color(0xff18124a),
      tertiaryFixedDim: Color(0xffc5c0ff),
      onTertiaryFixedVariant: Color(0xff444078),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff343a3b),
      surfaceContainerLowest: Color(0xff090f10),
      surfaceContainerLow: Color(0xff161d1d),
      surfaceContainer: Color(0xff1a2121),
      surfaceContainerHigh: Color(0xff252b2b),
      surfaceContainerHighest: Color(0xff303636),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff96eaf0),
      surfaceTint: Color(0xff80d4da),
      onPrimary: Color(0xff002b2d),
      primaryContainer: Color(0xff479da3),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff97eaf4),
      onSecondary: Color(0xff002b2f),
      secondaryContainer: Color(0xff489da6),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffddd8ff),
      onTertiary: Color(0xff221e54),
      tertiaryContainer: Color(0xff8f8ac7),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dedf),
      outline: Color(0xffaab4b4),
      outlineVariant: Color(0xff889293),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e4),
      inversePrimary: Color(0xff005054),
      primaryFixed: Color(0xff9cf0f6),
      onPrimaryFixed: Color(0xff001416),
      primaryFixedDim: Color(0xff80d4da),
      onPrimaryFixedVariant: Color(0xff003d40),
      secondaryFixed: Color(0xff9df0fa),
      onSecondaryFixed: Color(0xff001417),
      secondaryFixedDim: Color(0xff81d3dd),
      onSecondaryFixedVariant: Color(0xff003d42),
      tertiaryFixed: Color(0xffe3dfff),
      onTertiaryFixed: Color(0xff0d0540),
      tertiaryFixedDim: Color(0xffc5c0ff),
      onTertiaryFixedVariant: Color(0xff332f66),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff3f4646),
      surfaceContainerLowest: Color(0xff040809),
      surfaceContainerLow: Color(0xff181f1f),
      surfaceContainer: Color(0xff232929),
      surfaceContainerHigh: Color(0xff2d3434),
      surfaceContainerHighest: Color(0xff383f3f),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbdfbff),
      surfaceTint: Color(0xff80d4da),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff7cd0d6),
      onPrimaryContainer: Color(0xff000e0f),
      secondary: Color(0xffc7f9ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff7dcfd9),
      onSecondaryContainer: Color(0xff000e10),
      tertiary: Color(0xfff2eeff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffc1bcfc),
      onTertiaryContainer: Color(0xff070039),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0e1415),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f2f2),
      outlineVariant: Color(0xffbac4c5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e4),
      inversePrimary: Color(0xff005054),
      primaryFixed: Color(0xff9cf0f6),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff80d4da),
      onPrimaryFixedVariant: Color(0xff001416),
      secondaryFixed: Color(0xff9df0fa),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff81d3dd),
      onSecondaryFixedVariant: Color(0xff001417),
      tertiaryFixed: Color(0xffe3dfff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc5c0ff),
      onTertiaryFixedVariant: Color(0xff0d0540),
      surfaceDim: Color(0xff0e1415),
      surfaceBright: Color(0xff4b5152),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1a2121),
      surfaceContainer: Color(0xff2b3232),
      surfaceContainerHigh: Color(0xff363d3d),
      surfaceContainerHighest: Color(0xff414848),
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
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      color: colorScheme.surface,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    ),
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

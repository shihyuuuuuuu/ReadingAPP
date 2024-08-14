import "package:flutter/material.dart";

class MaterialTheme {
  const MaterialTheme();

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 249, 146, 30),
      surfaceTint: Color(0xff97480a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffa56d),
      onPrimaryContainer: Color(0xff4e2000),
      secondary: Color(0xff80543a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffcdb1),
      onSecondaryContainer: Color(0xff5e3820),
      tertiary: Color(0xff5e6300),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbcc24e),
      onTertiaryContainer: Color(0xff2e3100),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff221a15),
      onSurfaceVariant: Color(0xff554339),
      outline: Color(0xff887368),
      outlineVariant: Color(0xffdbc1b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb68b),
      primaryFixed: Color(0xffffdbc8),
      onPrimaryFixed: Color(0xff321200),
      primaryFixedDim: Color(0xffffb68b),
      onPrimaryFixedVariant: Color(0xff753400),
      secondaryFixed: Color(0xffffdbc8),
      onSecondaryFixed: Color(0xff311301),
      secondaryFixedDim: Color(0xfff3ba9a),
      onSecondaryFixedVariant: Color(0xff643d25),
      tertiaryFixed: Color(0xffe3ea71),
      onTertiaryFixed: Color(0xff1b1d00),
      tertiaryFixedDim: Color(0xffc7cd58),
      onTertiaryFixedVariant: Color(0xff474a00),
      surfaceDim: Color(0xffe8d7cf),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ea),
      surfaceContainer: Color(0xfffceae2),
      surfaceContainerHigh: Color(0xfff6e5dd),
      surfaceContainerHighest: Color(0xfff0dfd7),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6f3100),
      surfaceTint: Color(0xff97480a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb35d21),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff603921),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff996a4e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff434600),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff747a01),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff221a15),
      onSurfaceVariant: Color(0xff513f35),
      outline: Color(0xff6e5b50),
      outlineVariant: Color(0xff8c766b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffb68b),
      primaryFixed: Color(0xffb35d21),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff944607),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff996a4e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff7d5238),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff747a01),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5c6000),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d7cf),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ea),
      surfaceContainer: Color(0xfffceae2),
      surfaceContainerHigh: Color(0xfff6e5dd),
      surfaceContainerHighest: Color(0xfff0dfd7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3c1800),
      surfaceTint: Color(0xff97480a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6f3100),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff391a05),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff603921),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff222400),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff434600),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f5),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff2f2118),
      outline: Color(0xff513f35),
      outlineVariant: Color(0xff513f35),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff382e29),
      inversePrimary: Color(0xffffe7dc),
      primaryFixed: Color(0xff6f3100),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff4c2000),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff603921),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff46240d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff434600),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2d2f00),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d7cf),
      surfaceBright: Color(0xfffff8f5),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff1ea),
      surfaceContainer: Color(0xfffceae2),
      surfaceContainerHigh: Color(0xfff6e5dd),
      surfaceContainerHighest: Color(0xfff0dfd7),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffc9ab),
      surfaceTint: Color(0xffffb68b),
      onPrimary: Color(0xff522300),
      primaryContainer: Color(0xfff69252),
      onPrimaryContainer: Color(0xff3a1600),
      secondary: Color(0xfff3ba9a),
      onSecondary: Color(0xff4a2811),
      secondaryContainer: Color(0xff5c371e),
      onSecondaryContainer: Color(0xffffcaac),
      tertiary: Color(0xffd5db64),
      onTertiary: Color(0xff303300),
      tertiaryContainer: Color(0xffabb13f),
      onTertiaryContainer: Color(0xff202200),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a120d),
      onSurface: Color(0xfff0dfd7),
      onSurfaceVariant: Color(0xffdbc1b4),
      outline: Color(0xffa38c80),
      outlineVariant: Color(0xff554339),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff97480a),
      primaryFixed: Color(0xffffdbc8),
      onPrimaryFixed: Color(0xff321200),
      primaryFixedDim: Color(0xffffb68b),
      onPrimaryFixedVariant: Color(0xff753400),
      secondaryFixed: Color(0xffffdbc8),
      onSecondaryFixed: Color(0xff311301),
      secondaryFixedDim: Color(0xfff3ba9a),
      onSecondaryFixedVariant: Color(0xff643d25),
      tertiaryFixed: Color(0xffe3ea71),
      onTertiaryFixed: Color(0xff1b1d00),
      tertiaryFixedDim: Color(0xffc7cd58),
      onTertiaryFixedVariant: Color(0xff474a00),
      surfaceDim: Color(0xff1a120d),
      surfaceBright: Color(0xff413732),
      surfaceContainerLowest: Color(0xff140d08),
      surfaceContainerLow: Color(0xff221a15),
      surfaceContainer: Color(0xff271e19),
      surfaceContainerHigh: Color(0xff322823),
      surfaceContainerHighest: Color(0xff3d332d),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffc9ab),
      surfaceTint: Color(0xffffb68b),
      onPrimary: Color(0xff381600),
      primaryContainer: Color(0xfff69252),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff8bf9e),
      onSecondary: Color(0xff2a0e00),
      secondaryContainer: Color(0xffb88668),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffd5db64),
      onTertiary: Color(0xff1f2100),
      tertiaryContainer: Color(0xffabb13f),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a120d),
      onSurface: Color(0xfffffaf8),
      onSurfaceVariant: Color(0xffdfc6b9),
      outline: Color(0xffb69e92),
      outlineVariant: Color(0xff947f73),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff773500),
      primaryFixed: Color(0xffffdbc8),
      onPrimaryFixed: Color(0xff220a00),
      primaryFixedDim: Color(0xffffb68b),
      onPrimaryFixedVariant: Color(0xff5b2700),
      secondaryFixed: Color(0xffffdbc8),
      onSecondaryFixed: Color(0xff220a00),
      secondaryFixedDim: Color(0xfff3ba9a),
      onSecondaryFixedVariant: Color(0xff512d16),
      tertiaryFixed: Color(0xffe3ea71),
      onTertiaryFixed: Color(0xff111200),
      tertiaryFixedDim: Color(0xffc7cd58),
      onTertiaryFixedVariant: Color(0xff363900),
      surfaceDim: Color(0xff1a120d),
      surfaceBright: Color(0xff413732),
      surfaceContainerLowest: Color(0xff140d08),
      surfaceContainerLow: Color(0xff221a15),
      surfaceContainer: Color(0xff271e19),
      surfaceContainerHigh: Color(0xff322823),
      surfaceContainerHighest: Color(0xff3d332d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffffaf8),
      surfaceTint: Color(0xffffb68b),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffbc95),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffffaf8),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xfff8bf9e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffdffbe),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffcbd25c),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a120d),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffffaf8),
      outline: Color(0xffdfc6b9),
      outlineVariant: Color(0xffdfc6b9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff0dfd7),
      inversePrimary: Color(0xff481e00),
      primaryFixed: Color(0xffffe1d1),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffbc95),
      onPrimaryFixedVariant: Color(0xff2a0e00),
      secondaryFixed: Color(0xffffe1d1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xfff8bf9e),
      onSecondaryFixedVariant: Color(0xff2a0e00),
      tertiaryFixed: Color(0xffe8ee74),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcbd25c),
      onTertiaryFixedVariant: Color(0xff161800),
      surfaceDim: Color(0xff1a120d),
      surfaceBright: Color(0xff413732),
      surfaceContainerLowest: Color(0xff140d08),
      surfaceContainerLow: Color(0xff221a15),
      surfaceContainer: Color(0xff271e19),
      surfaceContainerHigh: Color(0xff322823),
      surfaceContainerHighest: Color(0xff3d332d),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: const TextTheme(),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );

  

  List<ExtendedColor> get extendedColors => [
  ];
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



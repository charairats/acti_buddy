// ActiBuddy Themes (Flutter 3.32, Material 3)
// ------------------------------------------------------------
// ✅ Notes on deprecations & migrations:
// - ColorScheme.background / onBackground are DEPRECATED in M3. Use surface & new surfaceContainer* roles instead.
// - MaterialStateProperty is DEPRECATED typedef → use WidgetStateProperty / WidgetStatePropertyAll.
// - Color.withOpacity is DEPRECATED → use color.withValues(alpha: ...).
// - Component theme normalization introduced CardThemeData (replacing CardTheme in ThemeData).
//
// Sources:
// - New ColorScheme roles & background/onBackground deprecation: docs.flutter.dev → breaking changes (new-color-scheme-roles)
// - MaterialState → WidgetState rename: docs.flutter.dev → breaking changes (material-state)
// - withOpacity deprecation & wide gamut: docs.flutter.dev → breaking changes (wide-gamut-framework)
// - Component theme normalization & CardThemeData: docs.flutter.dev → breaking changes (component-theme-normalization)
// ------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Brand palette (Adventure Minimal)
const Color kBrandYellow = Color(0xFFFFD93D); // Primary
const Color kLightSurface = Colors.white;
const Color kLightOnSurface = Color(0xFF111111);
const Color kDarkSurface = Color(0xFF1C1C1C);
const Color kDarkScaffold = Color(0xFF0D0D0D);

// LIGHT THEME
final ColorScheme _lightScheme = ColorScheme.fromSeed(
  seedColor: kBrandYellow,
  brightness: Brightness.light,
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightScheme.copyWith(
    primary: kBrandYellow,
    onPrimary: Colors.black,
    secondary: Colors.white, // white accents
    onSecondary: Colors.black,
    surface: kLightSurface,
    onSurface: kLightOnSurface,
    // Optional: tailor tone-based containers
    surfaceContainer: const Color(0xFFF6F6F6),
    surfaceContainerLow: const Color(0xFFF8F8F8),
    surfaceContainerHigh: const Color(0xFFF2F2F2),
  ),
  scaffoldBackgroundColor: kLightSurface,
  // textTheme: GoogleFonts.playTextTheme().copyWith(
  //   displayLarge: const TextStyle(color: kDarkSurface),
  //   displayMedium: const TextStyle(color: kDarkSurface),
  //   displaySmall: const TextStyle(color: kDarkSurface),
  //   headlineLarge: const TextStyle(color: kDarkSurface),
  //   headlineMedium: const TextStyle(color: kDarkSurface),
  //   headlineSmall: const TextStyle(color: kDarkSurface),
  //   titleLarge: const TextStyle(color: kDarkSurface),
  //   titleMedium: const TextStyle(color: kDarkSurface),
  //   titleSmall: const TextStyle(color: kDarkSurface),
  //   bodyLarge: const TextStyle(color: kDarkSurface),
  //   bodyMedium: const TextStyle(color: kDarkSurface),
  //   bodySmall: const TextStyle(color: kDarkSurface),
  //   labelLarge: const TextStyle(color: kDarkSurface),
  //   labelMedium: const TextStyle(color: kDarkSurface),
  //   labelSmall: const TextStyle(color: kDarkSurface),
  // ),
  textTheme: GoogleFonts.latoTextTheme(),
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 1,
    margin: EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(kBrandYellow),
      foregroundColor: const WidgetStatePropertyAll(Colors.black),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w700),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: kLightSurface,
    indicatorColor: kBrandYellow.withValues(alpha: 0.18),
    labelTextStyle: const WidgetStatePropertyAll(
      TextStyle(fontWeight: FontWeight.w600),
    ),
    iconTheme: const WidgetStatePropertyAll(IconThemeData(size: 24)),
  ),
);

// DARK THEME
final ColorScheme _darkScheme = ColorScheme.fromSeed(
  seedColor: kBrandYellow,
  brightness: Brightness.dark,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _darkScheme.copyWith(
    primary: kBrandYellow,
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.black,
    surface: kDarkSurface,
    onSurface: Colors.white,
    surfaceContainer: const Color(0xFF222222),
    surfaceContainerLow: const Color(0xFF242424),
    surfaceContainerHigh: const Color(0xFF202020),
  ),
  scaffoldBackgroundColor: kDarkScaffold,
  // fontFamily: GoogleFonts.oxanium.toString(),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: kLightSurface,
    centerTitle: false,
  ),
  // textTheme: GoogleFonts.sarabunTextTheme().copyWith(
  //   displayLarge: const TextStyle(color: kLightSurface),
  //   displayMedium: const TextStyle(color: kLightSurface),
  //   displaySmall: const TextStyle(color: kLightSurface),
  //   headlineLarge: const TextStyle(color: kLightSurface),
  //   headlineMedium: const TextStyle(color: kLightSurface),
  //   headlineSmall: const TextStyle(color: kLightSurface),
  //   titleLarge: const TextStyle(color: kLightSurface),
  //   titleMedium: const TextStyle(color: kLightSurface),
  //   titleSmall: const TextStyle(color: kLightSurface),
  //   bodyLarge: const TextStyle(color: kLightSurface),
  //   bodyMedium: const TextStyle(color: kLightSurface),
  //   bodySmall: const TextStyle(color: kLightSurface),
  //   labelLarge: const TextStyle(color: kLightSurface),
  //   labelMedium: const TextStyle(color: kLightSurface),
  //   labelSmall: const TextStyle(color: kLightSurface),
  // ),
  textTheme: GoogleFonts.latoTextTheme(),
  cardTheme: const CardThemeData(
    color: Color(0xFF1E1E1E),
    elevation: 3,
    margin: EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(kBrandYellow),
      foregroundColor: const WidgetStatePropertyAll(Colors.black),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontWeight: FontWeight.w700),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: kDarkSurface,
    // indicatorColor: kBrandYellow.withValues(alpha: 0.22),
    indicatorColor: kBrandYellow,
    labelTextStyle: const WidgetStatePropertyAll(
      TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
    ),

    iconTheme: const WidgetStatePropertyAll(
      IconThemeData(size: 24, color: Colors.white),
    ),
  ),
  tabBarTheme: TabBarThemeData(
    indicatorColor: kBrandYellow,
    labelColor: kLightSurface,
  ),
);

// Example usage

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kBrandYellow = Color(0xFFF6D658);

const Color kLightPrimary = kBrandYellow;
const Color kLightOnPrimary = Color(0xFF000000);
const Color kLightSecondary = Color(0xFF4C5D6C);
const Color kLightOnSecondary = Color(0xFFFFFFFF);
const Color kLightSurface = Color(0xFFFFFFFF);
const Color kLightOnSurface = Color(0xFF111111);
const Color kLightSurfaceContainerLow = Color(0xFFF2F2F7);
const Color kLightSurfaceContainer = Color(0xFFE5E5EA);
const Color kLightSurfaceContainerHigh = Color(0xFFD1D1D6);

const Color kDarkPrimary = kBrandYellow;
const Color kDarkOnPrimary = Color(0xFF000000);
const Color kDarkSecondary = kBrandYellow;
const Color kDarkOnSecondary = Color(0xFF000000);
const Color kDarkSurface = Color(0xFF1C1C1E);
const Color kDarkOnSurface = Color(0xFFFFFFFF);
const Color kDarkSurfaceContainerLow = Color(0xFF2C2C2E);
const Color kDarkSurfaceContainer = Color(0xFF3A3A3C);
const Color kDarkSurfaceContainerHigh = Color(0xFF48484A);

// LIGHT THEME
final ColorScheme _lightScheme = ColorScheme.fromSeed(
  seedColor: kBrandYellow,
  brightness: Brightness.light,
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightScheme.copyWith(
    primary: kLightPrimary,
    onPrimary: kLightOnPrimary,
    secondary: kLightSecondary,
    onSecondary: kLightOnSecondary,
    surface: kLightSurface,
    onSurface: kLightOnSurface,
    surfaceContainerLow: kLightSurfaceContainerLow,
    surfaceContainer: kLightSurfaceContainer,
    surfaceContainerHigh: kLightSurfaceContainerHigh,
  ),
  scaffoldBackgroundColor: kLightSurface,
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
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: kLightSurface,
    indicatorColor: kBrandYellow,
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(fontWeight: FontWeight.w600),
    ),
    iconTheme: WidgetStatePropertyAll(IconThemeData(size: 24)),
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
    onPrimary: kDarkOnPrimary,
    secondary: kDarkSecondary,
    onSecondary: kDarkOnSecondary,
    surface: kDarkSurface,
    onSurface: kDarkOnSurface,
    surfaceContainerLow: kDarkSurfaceContainerLow,
    surfaceContainer: kDarkSurfaceContainer,
    surfaceContainerHigh: kDarkSurfaceContainerHigh,
  ),
  scaffoldBackgroundColor: kDarkSurface,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: kLightSurface,
    centerTitle: false,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kDarkSurfaceContainer,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    iconColor: kDarkOnSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    prefixIconColor: kDarkOnSurface.withAlpha(100),
    floatingLabelStyle: TextStyle(color: kDarkOnSurface, fontSize: 20),
    labelStyle: const TextStyle(color: kDarkOnSurface, fontSize: 16),
    hintStyle: TextStyle(color: kDarkOnSurface.withAlpha(100)),
    errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
  ),
  textTheme: GoogleFonts.sarabunTextTheme(),
  cardTheme: const CardThemeData(
    color: Color(0xFF1E1E1E),
    elevation: 3,
    margin: EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: kDarkSurfaceContainer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: kDarkSurface,
    // indicatorColor: kBrandYellow.withValues(alpha: 0.22),
    indicatorColor: kBrandYellow,
    labelTextStyle: WidgetStatePropertyAll(
      TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
    ),

    iconTheme: WidgetStatePropertyAll(
      IconThemeData(size: 24, color: Colors.white),
    ),
  ),
  tabBarTheme: const TabBarThemeData(
    indicatorColor: kBrandYellow,
    labelColor: kLightSurface,
  ),
);

// Example usage

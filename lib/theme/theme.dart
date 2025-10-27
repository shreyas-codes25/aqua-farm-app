import 'package:flutter/material.dart';

final Color primaryColor = Color(0xFF00B8D4); // Aqua / teal
final Color primaryVariant = Color(0xFF008C9E);
final Color secondaryColor = Color(0xFF26C6DA); // Lighter teal for accents
final Color secondaryVariant = Color(0xFF00ACC1);
final Color backgroundColor = Color(0xFFF5F9FA); // Light grey / soft white
final Color surfaceColor = Colors.white;
final Color errorColor = Color(0xFFD32F2F); // Red for errors
final Color onPrimaryColor = Colors.white;
final Color onSecondaryColor = Colors.white;
final Color onBackgroundColor = Colors.black87;
final Color onSurfaceColor = Colors.black87;

final ThemeData smartAquaTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: onPrimaryColor,
    secondary: secondaryColor,
    onSecondary: onSecondaryColor,
    error: errorColor,
    onError: Colors.white,
    background: backgroundColor,
    onBackground: onBackgroundColor,
    surface: surfaceColor,
    onSurface: onSurfaceColor,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: onPrimaryColor,
    elevation: 4,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    color: surfaceColor,
    shadowColor: Colors.black26,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      elevation: 4,
    ),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
    headlineSmall: TextStyle(fontSize: 14, color: Colors.grey),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);

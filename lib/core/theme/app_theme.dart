import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF6FBF73);
  static const Color primaryDark = Color(0xFF2E7D32);
  static const Color background = Color(0xFFF6FBF7);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color accentEnergetic = Color(0xFFA5D6A7);
  static const Color accentNormal = Color(0xFFFFF59D);
  static const Color accentTired = Color(0xFFCFD8DC);

  // Spacing
  static const double spacingXs = 8;
  static const double spacingSm = 16;
  static const double spacingMd = 24;
  static const double spacingLg = 32;

  // Border radius
  static const double radiusMd = 20;
  static const double radiusLg = 24;

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ).copyWith(surface: background),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF1B5E20),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: spacingMd,
            horizontal: spacingLg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF424242)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF616161)),
      ),
    );
  }
}

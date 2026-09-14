import 'package:flutter/material.dart';

class DocTabTheme {
  static const cream = Color(0xFFF7F5EE);
  static const ink = Color(0xFF17352D);
  static const sage = Color(0xFFE8EFE2);
  static const sand = Color(0xFFF0E9DD);
  static const accent = Color(0xFF6E8B75);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.light,
      surface: cream,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: ink,
        secondary: accent,
        surface: cream,
      ),
      scaffoldBackgroundColor: cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ink.withValues(alpha: 0.14)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ink.withValues(alpha: 0.14)),
        ),
      ),
    );
  }
}
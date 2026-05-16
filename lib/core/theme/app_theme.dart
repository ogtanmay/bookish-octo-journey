import 'package:flutter/material.dart';

class AppTheme {
  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF050506),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFE8EDF8),
      secondary: Color(0xFF8CB4FF),
      surface: Color(0xFF111318),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.8),
      titleMedium: TextStyle(fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: Color(0xFFC0C7D8)),
    ),
  );
}

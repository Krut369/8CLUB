import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF0E0E0E);
  static const Color accent = Color(0xFF3B82F6);
  static const Color grey = Color(0xFF9CA3AF);
  static const Color input = Color(0xFF1C1C1E);

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(primary: accent),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}

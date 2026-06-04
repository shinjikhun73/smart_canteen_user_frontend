import 'package:flutter/material.dart';

class AppTheme {
  static const Color green = Color(0xFF4CAF50);
  static const Color accentBlue = Color(0xFFA6CDFF);
  static const Color background = Color(0xFFFAFAFA);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF2F2F2F);
  static const Color mutedText = Color(0xFF8A8A8A);
  static const Color border = Color(0xFFD5EED7);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: green,
      brightness: Brightness.light,
      primary: green,
      secondary: accentBlue,
      surface: background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: green, width: 1.3),
        ),
      ),
    );
  }
}
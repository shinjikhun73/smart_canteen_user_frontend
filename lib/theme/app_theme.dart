import 'package:flutter/material.dart';

class AppTheme {
  static const Color green = Color(0xFF4CAF50);
  static const Color greenDark = Color(0xFF2E7D32);
  static const Color greenSurface = Color(0xFFE8F5E9);
  static const Color accentBlue = Color(0xFFA6CDFF);
  static const Color background = Color(0xFFF7F8FA);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF1A1F1A);
  static const Color mutedText = Color(0xFF8A8A8A);
  static const Color border = Color(0xFFE4EDE4);

  static final LinearGradient balanceCardGradient = const LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient headerGradient = const LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

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
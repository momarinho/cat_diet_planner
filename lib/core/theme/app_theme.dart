import 'package:flutter/material.dart';

class AppTheme {
  // Cores base para o tema rosa
  static const Color _primaryPink = Color(0xFFFF85A1);
  static const Color _lightBackground = Color(0xFFFFF5F7);
  static const Color _darkBackground = Color(0xFF1A1617);

  /// Tema Claro: Pink Pastel
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryPink,
        primary: _primaryPink,
        surface: _lightBackground,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: _primaryPink),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryPink,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryPink,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Tema Escuro: Midnight Rose
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryPink,
        primary: _primaryPink,
        surface: const Color(0xFF251F21),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: _primaryPink),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF251F21),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryPink,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryPink,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

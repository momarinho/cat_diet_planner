import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core palette based on the pink pastel and midnight rose guides.
  static const Color primaryNeon = Color(0xFFFF85A1);
  static const Color successGreen = Color(0xFFA8E6CF);
  static const Color warningYellow = Color(0xFFFFD93D);
  static const Color dangerRed = Color(0xFFFF8E8E);

  // Light theme colors
  static const Color lightBackground = Color(0xFFFFF5F7);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF2D3436);
  static const Color lightTextSecondary = Color(0xFF6F6A6C);
  static const Color lightBorder = Color(0xFFFFE2E8);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF1A1617);
  static const Color darkSurfaceCard = Color(0xFF251F21);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFA49D9E);
  static const Color darkBorder = Color(0x33FFFFFF);

  /// Tema Claro: Pink Pastel
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.light().textTheme)
          .copyWith(
            titleLarge: GoogleFonts.manrope(
              color: lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: GoogleFonts.manrope(
              color: lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: GoogleFonts.manrope(color: lightTextPrimary),
            bodyMedium: GoogleFonts.manrope(color: lightTextSecondary),
          ),
      colorScheme: const ColorScheme.light(
        primary: primaryNeon,
        onPrimary: Colors.white,
        secondary: primaryNeon,
        onSecondary: Colors.white,
        surface: lightSurfaceCard,
        onSurface: lightTextPrimary,
        error: dangerRed,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: primaryNeon),
      ),
      cardTheme: const CardThemeData(
        color: lightSurfaceCard,
        elevation: 4,
        shadowColor: Color(0x1A000000), // Sombra 10%
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryNeon,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNeon,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          elevation: 4,
          shadowColor: primaryNeon.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryNeon,
          side: const BorderSide(color: primaryNeon, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Formato Pílula
          ),
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.bold),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryNeon,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.94),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primaryNeon, width: 1.6),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurfaceCard,
        selectedItemColor: primaryNeon,
        unselectedItemColor: lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }

  /// Tema Escuro Principal (Dark Plum & Neon Coral)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            titleLarge: GoogleFonts.manrope(
              color: darkTextPrimary,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: GoogleFonts.manrope(
              color: darkTextPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: GoogleFonts.manrope(color: darkTextPrimary),
            bodyMedium: GoogleFonts.manrope(color: darkTextSecondary),
          ),
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        onPrimary: Color(0xFF1A1617),
        secondary: primaryNeon,
        onSecondary: Color(0xFF1A1617),
        surface: darkSurfaceCard,
        onSurface: darkTextPrimary,
        error: dangerRed,
        onError: Color(0xFF1A1617),
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: primaryNeon),
      ),
      cardTheme: const CardThemeData(
        color: darkSurfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryNeon,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryNeon,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          elevation: 8,
          shadowColor: primaryNeon.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryNeon,
          side: const BorderSide(color: primaryNeon, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // Formato Pílula
          ),
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.bold),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryNeon,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceCard.withValues(alpha: 0.92),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primaryNeon, width: 1.6),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBackground,
        selectedItemColor: primaryNeon,
        unselectedItemColor: darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }
}

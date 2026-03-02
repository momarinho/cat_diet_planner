import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores Compartilhadas
  static const Color primaryNeon = Color(0xFFFF849F);
  static const Color successGreen = Color(0xFF4ADE80);
  static const Color warningYellow = Color(0xFFFBBF24);

  // Cores Tema Claro
  static const Color lightBackground = Color(
    0xFFFFF5F7,
  ); // Cinza super claro/off-white
  static const Color lightSurfaceCard = Color(0xFFFFF5F7);
  static const Color lightTextPrimary = Color(
    0xFF2D2A2B,
  ); // Chumbo escuro suave
  static const Color lightTextSecondary = Color(0xFF8E8A8B); // Cinza neutro

  // Cores Tema Escuro (Dark Plum & Neon Coral)
  static const Color darkBackground = Color(0xFF1E1517); // Ameixa ultra escuro
  static const Color darkSurfaceCard = Color(
    0xFF2A1E22,
  ); // Ameixa mais claro para cards
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(
    0xFFA19398,
  ); // Texto cinza/rosado

  /// Tema Claro
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
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryNeon,
        primary: primaryNeon,
        surface: lightSurfaceCard,
        brightness: Brightness.light,
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
        shadowColor: Color(0x1A000000), // Sombra bem sutil 10%
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
          shadowColor: primaryNeon.withOpacity(0.3),
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
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.bold),
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
        color: Color(0xFFE5E5E5), // Linha divisória clara
        thickness: 1,
        space: 24,
      ),
    );
  }

  /// Tema Escuro Principal
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
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryNeon,
        primary: primaryNeon,
        surface: darkSurfaceCard,
        brightness: Brightness.dark,
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
          elevation: 8, // Para ajudar no efeito Neon Glow básico
          shadowColor: primaryNeon.withOpacity(0.5),
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
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.manrope(fontWeight: FontWeight.bold),
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
        color: Color(0xFF3D262F), // Linhas divisórias sutis bem amadeiradas
        thickness: 1,
        space: 24,
      ),
    );
  }
}

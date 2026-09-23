import 'package:flutter/material.dart';

class ZogbeTheme {
  // Palette de couleurs officielle Zògbé
  static const Color redOilBrown = Color(0xFF8B2622); // RED OIL BROWN (Terre cuite)
  static const Color darkBrown = Color(0xFF23120F);   // DARK BROWN (Brun profond)
  static const Color darkBrownMedium = Color(0xFF3B201A);
  static const Color gariOrange = Color(0xFFE0822D);  // GARI ORANGE (Orange chaud / Ocre)
  static const Color gariOrangeLight = Color(0xFFF39C38);
  static const Color kraftLight = Color(0xFFF7EFE2);  // KRAFT LIGHT (Papier kraft doux)
  static const Color kraftDark = Color(0xFFEADBC4);
  static const Color kraftBorder = Color(0xFFDCC8AA);
  
  // Accents
  static const Color accentGreen = Color(0xFF388E3C); // Vert disponibilité / validation
  static const Color accentGreenBg = Color(0xFFE8F5E9);
  static const Color darkGreen = Color(0xFF2E633B);
  static const Color goldAccent = Color(0xFFD4A373);
  static const Color white = Colors.white;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: kraftLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: gariOrange,
        primary: gariOrange,
        secondary: redOilBrown,
        surface: kraftLight,
        background: kraftLight,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkBrown),
        titleTextStyle: TextStyle(
          color: darkBrown,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: gariOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Typography System
class AppTextTheme {
  AppTextTheme._();

  /// Light Text Theme
  static TextTheme get lightTextTheme => _buildTextTheme(
    baseTextTheme: GoogleFonts.interTextTheme(),
    bodyColor: const Color(0xFF1E293B),
    displayColor: const Color(0xFF0F172A),
  );

  /// Dark Text Theme
  static TextTheme get darkTextTheme => _buildTextTheme(
    baseTextTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    bodyColor: const Color(0xFFF1F5F9),
    displayColor: const Color(0xFFE2E8F0),
  );

  /// Build Text Theme with consistent styling
  static TextTheme _buildTextTheme({
    required TextTheme baseTextTheme,
    required Color bodyColor,
    required Color displayColor,
  }) {
    return baseTextTheme.copyWith(
      // Display Styles (Large headings)
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        color: displayColor,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: displayColor,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: displayColor,
        height: 1.22,
      ),

      // Headline Styles (Medium headings)
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: displayColor,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: displayColor,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: displayColor,
        height: 1.33,
      ),

      // Title Styles (Small headings)
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: displayColor,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: displayColor,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: displayColor,
        height: 1.43,
      ),

      // Body Styles (Content text)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: bodyColor,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: bodyColor,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: bodyColor.withOpacity(0.8),
        height: 1.33,
      ),

      // Label Styles (UI elements)
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: bodyColor,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: bodyColor,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: bodyColor.withOpacity(0.8),
        height: 1.45,
      ),
    );
  }
}

/// Text Style Extensions for easier usage
extension TextStyleExtensions on TextStyle {
  /// Apply semibold weight
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Apply bold weight
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  /// Apply extra bold weight
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);

  /// Apply medium weight
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Apply light weight
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  /// Apply italic style
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Apply custom color
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Apply custom opacity
  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withOpacity(opacity));

  /// Apply custom height (line height)
  TextStyle withHeight(double height) => copyWith(height: height);

  /// Apply custom letter spacing
  TextStyle withLetterSpacing(double letterSpacing) =>
      copyWith(letterSpacing: letterSpacing);
}

/// Predefined text styles for common UI patterns
class AppTextStyles {
  AppTextStyles._();

  /// Error text style
  static TextStyle get error => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: const Color(0xFFEF4444),
    height: 1.33,
  );

  /// Success text style
  static TextStyle get success => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF10B981),
    height: 1.33,
  );

  /// Warning text style
  static TextStyle get warning => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: const Color(0xFFF59E0B),
    height: 1.33,
  );

  /// Link text style
  static TextStyle get link => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF6366F1),
    decoration: TextDecoration.underline,
    height: 1.43,
  );

  /// Button text style
  static TextStyle get button => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.25,
  );

  /// Caption text style
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.2,
  );
}

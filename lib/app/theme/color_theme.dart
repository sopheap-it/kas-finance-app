import 'package:flutter/material.dart';

/// App Color Palette
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryVariant = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryVariant = Color(0xFF7C3AED);
  static const Color tertiary = Color(0xFF06B6D4);
  static const Color tertiaryVariant = Color(0xFF0891B2);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1E293B);
  static const Color lightOnBackground = Color(0xFF0F172A);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOutline = Color(0xFFCBD5E1);
  static const Color lightOutlineVariant = Color(0xFFE2E8F0);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFF1F5F9);
  static const Color darkOnBackground = Color(0xFFE2E8F0);
  static const Color darkOnError = Color(0xFFFFFFFF);
  static const Color darkOutline = Color(0xFF475569);
  static const Color darkOutlineVariant = Color(0xFF64748B);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> successGradient = [
    Color(0xFF10B981),
    Color(0xFF059669),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFF59E0B),
    Color(0xFFD97706),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFEF4444),
    Color(0xFFDC2626),
  ];
}

/// Light Color Scheme
class LightColorScheme {
  static ColorScheme get colorScheme => const ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.lightOnPrimary,
    primaryContainer: AppColors.primaryVariant,
    onPrimaryContainer: AppColors.lightOnPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.lightOnSecondary,
    secondaryContainer: AppColors.secondaryVariant,
    onSecondaryContainer: AppColors.lightOnSecondary,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.lightOnPrimary,
    tertiaryContainer: AppColors.tertiaryVariant,
    onTertiaryContainer: AppColors.lightOnPrimary,
    error: AppColors.error,
    onError: AppColors.lightOnError,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.lightOnError,
    background: AppColors.lightBackground,
    onBackground: AppColors.lightOnBackground,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    surfaceVariant: AppColors.lightSurfaceVariant,
    onSurfaceVariant: AppColors.lightOnSurface,
    outline: AppColors.lightOutline,
    outlineVariant: AppColors.lightOutlineVariant,
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: AppColors.darkSurface,
    onInverseSurface: AppColors.darkOnSurface,
    inversePrimary: AppColors.primary,
    surfaceTint: AppColors.primary,
  );
}

/// Dark Color Scheme
class DarkColorScheme {
  static ColorScheme get colorScheme => const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.primaryVariant,
    onPrimaryContainer: AppColors.darkOnPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.darkOnSecondary,
    secondaryContainer: AppColors.secondaryVariant,
    onSecondaryContainer: AppColors.darkOnSecondary,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.darkOnPrimary,
    tertiaryContainer: AppColors.tertiaryVariant,
    onTertiaryContainer: AppColors.darkOnPrimary,
    error: AppColors.error,
    onError: AppColors.darkOnError,
    errorContainer: AppColors.errorLight,
    onErrorContainer: AppColors.darkOnError,
    background: AppColors.darkBackground,
    onBackground: AppColors.darkOnBackground,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    surfaceVariant: AppColors.darkSurfaceVariant,
    onSurfaceVariant: AppColors.darkOnSurface,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: AppColors.lightSurface,
    onInverseSurface: AppColors.lightOnSurface,
    inversePrimary: AppColors.primary,
    surfaceTint: AppColors.primary,
  );
}

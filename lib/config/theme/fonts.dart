import 'package:flutter/material.dart';

/// Typography configuration for VisionScan Pro
///
/// Defines text styles following Material Design 3 typography scale
/// with custom Inter font family for modern, readable interface.
class AppFonts {
  const AppFonts._();

  /// Primary font family
  static const String primaryFontFamily = 'Inter';

  /// Font weights
  static const FontWeight regular = FontWeight.w400;

  /// Medium font weight
  static const FontWeight medium = FontWeight.w500;

  /// Semi bold font weight
  static const FontWeight semiBold = FontWeight.w600;

  /// Bold font weight
  static const FontWeight bold = FontWeight.w700;

  /// Base text theme for light mode
  static TextTheme get lightTextTheme => _buildTextTheme(Colors.black);

  /// Base text theme for dark mode
  static TextTheme get darkTextTheme => _buildTextTheme(Colors.white);

  /// Builds text theme with specified base color
  static TextTheme _buildTextTheme(Color baseColor) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 57,
        fontWeight: bold,
        height: 1.12,
        letterSpacing: -0.25,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 45,
        fontWeight: bold,
        height: 1.16,
        color: baseColor,
      ),
      displaySmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 36,
        fontWeight: semiBold,
        height: 1.22,
        color: baseColor,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 32,
        fontWeight: semiBold,
        height: 1.25,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 28,
        fontWeight: semiBold,
        height: 1.29,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 24,
        fontWeight: semiBold,
        height: 1.33,
        color: baseColor,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 22,
        fontWeight: semiBold,
        height: 1.27,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 16,
        fontWeight: medium,
        height: 1.50,
        letterSpacing: 0.15,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 14,
        fontWeight: medium,
        height: 1.43,
        letterSpacing: 0.10,
        color: baseColor,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 14,
        fontWeight: medium,
        height: 1.43,
        letterSpacing: 0.10,
        color: baseColor,
      ),
      labelMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 12,
        fontWeight: medium,
        height: 1.33,
        letterSpacing: 0.50,
        color: baseColor,
      ),
      labelSmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 11,
        fontWeight: medium,
        height: 1.45,
        letterSpacing: 0.50,
        color: baseColor,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 16,
        fontWeight: regular,
        height: 1.50,
        letterSpacing: 0.15,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 14,
        fontWeight: regular,
        height: 1.43,
        letterSpacing: 0.25,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontFamily: primaryFontFamily,
        fontSize: 12,
        fontWeight: regular,
        height: 1.33,
        letterSpacing: 0.40,
        color: baseColor,
      ),
    );
  }

  /// Custom text styles for specific UI components
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    height: 1.25,
    letterSpacing: 0.15,
  );

  /// Button medium text style
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    height: 1.29,
    letterSpacing: 0.10,
  );

  /// Button small text style
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: medium,
    height: 1.33,
    letterSpacing: 0.50,
  );

  /// Numeric display styles for OCR results
  static const TextStyle numberDisplayLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: 0.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Number display medium text style
  static const TextStyle numberDisplayMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.25,
    letterSpacing: 0.3,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Number display small text style
  static const TextStyle numberDisplaySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: medium,
    height: 1.3,
    letterSpacing: 0.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

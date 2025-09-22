import 'package:flutter/material.dart';

/// VisionScan Pro color palette following Material Design 3 principles
/// with modern enhancements for glassmorphism and premium UI elements.
class AppColors {
  const AppColors._();

  // Primary Brand Colors

  /// Primary blue color
  static const Color primaryBlue = Color(0xFF2563EB);

  /// Primary blue dark color
  static const Color primaryBlueDark = Color(0xFF1D4ED8);

  /// Primary blue light color
  static const Color primaryBlueLight = Color(0xFF3B82F6);

  // Secondary Colors

  /// Secondary purple color
  static const Color secondaryPurple = Color(0xFF8B5CF6);

  /// Secondary purple dark color
  static const Color secondaryPurpleDark = Color(0xFF7C3AED);

  /// Secondary purple light color
  static const Color secondaryPurpleLight = Color(0xFFA855F7);

  // Accent Colors

  /// Accent green color
  static const Color accentGreen = Color(0xFF10B981);

  /// Accent orange color
  static const Color accentOrange = Color(0xFFF59E0B);

  /// Accent red color
  static const Color accentRed = Color(0xFFEF4444);

  // Neutral Colors - Light Theme

  /// Neutral white color
  static const Color neutralWhite = Color(0xFFFFFFFF);

  /// Neutral grey 50 color
  static const Color neutralGrey50 = Color(0xFFFAFAFA);

  /// Neutral grey 100 color
  static const Color neutralGrey100 = Color(0xFFF5F5F5);

  /// Neutral grey 200 color
  static const Color neutralGrey200 = Color(0xFFE5E5E5);

  /// Neutral grey 300 color
  static const Color neutralGrey300 = Color(0xFFD4D4D4);

  /// Neutral grey 400 color
  static const Color neutralGrey400 = Color(0xFFA3A3A3);

  /// Neutral grey 500 color
  static const Color neutralGrey500 = Color(0xFF737373);

  /// Neutral grey 600 color
  static const Color neutralGrey600 = Color(0xFF525252);

  /// Neutral grey 700 color
  static const Color neutralGrey700 = Color(0xFF404040);

  /// Neutral grey 800 color
  static const Color neutralGrey800 = Color(0xFF262626);

  /// Neutral grey 900 color
  static const Color neutralGrey900 = Color(0xFF171717);

  /// Neutral black color
  static const Color neutralBlack = Color(0xFF000000);

  // Dark Theme Specific Colors

  /// Dark surface color
  static const Color darkSurface = Color(0xFF121212);

  /// Dark surface variant color
  static const Color darkSurfaceVariant = Color(0xFF1E1E1E);

  /// Dark background color
  static const Color darkBackground = Color(0xFF0A0A0A);

  // Glass Effect Colors

  /// Glass white color
  static const Color glassWhite = Color(0x1AFFFFFF);

  /// Glass dark color
  static const Color glassDark = Color(0x1A000000);

  /// Glass blur color
  static const Color glassBlur = Color(0x0DFFFFFF);

  // Gradient Colors

  /// Primary gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, secondaryPurple],
  );

  /// Surface gradient
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neutralGrey50, neutralWhite],
  );

  /// Dark surface gradient
  static const LinearGradient darkSurfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkSurface, darkSurfaceVariant],
  );

  // Camera Overlay Colors

  /// Camera overlay color
  static const Color cameraOverlay = Colors.transparent;

  /// Camera guide color
  static const Color cameraGuide = Color(0xFFFFFFFF);

  /// Camera focus color
  static const Color cameraFocus = primaryBlue;

  // Status Colors

  /// Success green color
  static const Color successGreen = Color(0xFF10B981);

  /// Warning yellow color
  static const Color warningYellow = Color(0xFFF59E0B);

  /// Error red color
  static const Color errorRed = Color(0xFFEF4444);

  /// Info blue color
  static const Color infoBlue = Color(0xFF3B82F6);

  // Shadow Colors

  /// Shadow light color
  static const Color shadowLight = Color(0x1A000000);

  /// Shadow medium color
  static const Color shadowMedium = Color(0x26000000);

  /// Shadow dark color
  static const Color shadowDark = Color(0x40000000);

  // App-specific Colors

  /// Background color
  static const Color background = neutralGrey50;

  /// Surface variant color
  static const Color surfaceVariant = neutralGrey100;

  /// Creates a color scheme for light theme
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primaryBlue,
    primary: primaryBlue,
    secondary: secondaryPurple,
    tertiary: accentGreen,
    surface: neutralWhite,
    onSurface: neutralGrey900,
    surfaceContainerHighest: neutralGrey100,
    outline: neutralGrey300,
    error: errorRed,
  );

  /// Creates a color scheme for dark theme
  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primaryBlue,
    brightness: Brightness.dark,
    primary: primaryBlueLight,
    secondary: secondaryPurpleLight,
    tertiary: accentGreen,
    surface: darkSurface,
    onSurface: neutralWhite,
    surfaceContainerHighest: darkSurfaceVariant,
    outline: neutralGrey600,
    error: errorRed,
  );
}

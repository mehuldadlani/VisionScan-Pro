import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Premium black & white design system for VisionScan Pro
/// Inspired by Apple, CRED, and modern minimalist design principles
class AppTheme {
  // Private constructor
  AppTheme._();

  /// Color Palette - Pure monochrome with subtle neutrals
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color neutralGray50 = Color(0xFFFAFAFA);
  static const Color neutralGray100 = Color(0xFFF5F5F5);
  static const Color neutralGray200 = Color(0xFFEEEEEE);
  static const Color neutralGray300 = Color(0xFFE0E0E0);
  static const Color neutralGray400 = Color(0xFFBDBDBD);
  static const Color neutralGray500 = Color(0xFF9E9E9E);
  static const Color neutralGray600 = Color(0xFF757575);
  static const Color neutralGray700 = Color(0xFF616161);
  static const Color neutralGray800 = Color(0xFF424242);
  static const Color neutralGray900 = Color(0xFF212121);

  /// Typography System - Premium font hierarchy
  static const String fontFamily = 'SF Pro Display';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: primaryBlack,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: primaryBlack,
    height: 1.3,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: primaryBlack,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: primaryBlack,
    height: 1.4,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: primaryBlack,
    height: 1.4,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: primaryBlack,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: primaryBlack,
    height: 1.5,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    color: primaryBlack,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: neutralGray700,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: neutralGray600,
    height: 1.3,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: primaryBlack,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: neutralGray600,
    height: 1.3,
  );

  /// Spacing System - 8pt grid system
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space10 = 10;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space56 = 56;
  static const double space64 = 64;

  /// Border Radius System
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusXLarge = 20;
  static const double radiusCircular = 50;

  /// Elevation & Shadow System
  static List<BoxShadow> get neumorphicShadow => [
    BoxShadow(
      color: primaryBlack.withValues(alpha: 0.1),
      offset: const Offset(2, 2),
      blurRadius: 4,
    ),
    BoxShadow(
      color: primaryWhite.withValues(alpha: 0.8),
      offset: const Offset(-2, -2),
      blurRadius: 4,
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: primaryBlack.withValues(alpha: 0.08),
      offset: const Offset(0, 4),
      blurRadius: 12,
    ),
    BoxShadow(
      color: primaryBlack.withValues(alpha: 0.04),
      offset: const Offset(0, 2),
      blurRadius: 6,
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: primaryBlack.withValues(alpha: 0.12),
      offset: const Offset(0, 8),
      blurRadius: 24,
    ),
    BoxShadow(
      color: primaryBlack.withValues(alpha: 0.08),
      offset: const Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryBlack,
        secondary: neutralGray700,
        onSecondary: primaryWhite,
        surface: neutralGray50,
        error: primaryBlack,
      ),

      // Scaffold
      scaffoldBackgroundColor: primaryWhite,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: headlineMedium,
        iconTheme: IconThemeData(color: primaryBlack),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlack,
          foregroundColor: primaryWhite,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: space24,
            vertical: space16,
          ),
          textStyle: labelLarge.copyWith(color: primaryWhite),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: primaryBlack, size: 24),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: neutralGray200,
        thickness: 1,
        space: 1,
      ),
    );
  }

  /// Dark Theme (for camera overlay)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: primaryWhite,
        secondary: neutralGray300,
        surface: primaryBlack,
        error: primaryWhite,
      ),

      scaffoldBackgroundColor: primaryBlack,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: primaryWhite,
        ),
        iconTheme: IconThemeData(color: primaryWhite),
      ),

      textTheme: TextTheme(
        displayLarge: displayLarge.copyWith(color: primaryWhite),
        displayMedium: displayMedium.copyWith(color: primaryWhite),
        headlineLarge: headlineLarge.copyWith(color: primaryWhite),
        headlineMedium: headlineMedium.copyWith(color: primaryWhite),
        titleLarge: titleLarge.copyWith(color: primaryWhite),
        titleMedium: titleMedium.copyWith(color: primaryWhite),
        bodyLarge: bodyLarge.copyWith(color: primaryWhite),
        bodyMedium: bodyMedium.copyWith(color: neutralGray300),
        labelLarge: labelLarge.copyWith(color: primaryWhite),
        labelMedium: labelMedium.copyWith(color: neutralGray400),
      ),
    );
  }
}

/// Neumorphic Design Extensions
extension NeumorphicDecoration on BoxDecoration {
  /// Creates a neumorphic container decoration
  static BoxDecoration neumorphic({
    Color? color,
    double borderRadius = AppTheme.radiusMedium,
    bool pressed = false,
  }) {
    return BoxDecoration(
      color: color ?? AppTheme.neutralGray100,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: pressed
          ? [
              BoxShadow(
                color: AppTheme.primaryBlack.withValues(alpha: 0.15),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ]
          : AppTheme.neumorphicShadow,
    );
  }

  /// Creates a soft elevated card decoration
  static BoxDecoration softCard({
    Color? color,
    double borderRadius = AppTheme.radiusLarge,
  }) {
    return BoxDecoration(
      color: color ?? AppTheme.primaryWhite,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: AppTheme.neutralGray200),
      boxShadow: AppTheme.softShadow,
    );
  }
}

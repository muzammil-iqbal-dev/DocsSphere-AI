import 'package:flutter/material.dart';

/// Centralized Design Tokens for DocSphereAI
/// Adheres to WCAG 2.2 AA contrast standards and professional Windows desktop aesthetics.
class AppColors {
  // Application background & surfaces
  static const Color background = Color(0xFFF7F9FC); // Soft off-white canvas
  static const Color surface = Color(0xFFFFFFFF); // Pure white card surface
  static const Color surfaceSubtle = Color(0xFFF1F4F9); // Secondary surface
  static const Color surfaceHover = Color(0xFFF8FAFD); // Surface on hover

  // Primary palette (DocSphere Royal Blue)
  static const Color primary = Color(0xFF356AE6);
  static const Color primaryHover = Color(0xFF2457CD);
  static const Color primaryPale = Color(0xFFEEF3FF);
  static const Color primaryBorder = Color(0xFFC7D7FA);

  // Secondary palette (Restrained Teal Accent)
  static const Color secondary = Color(0xFF159A91);
  static const Color secondaryHover = Color(0xFF0F7D76);
  static const Color secondaryPale = Color(0xFFE6F6F5);
  static const Color secondaryBorder = Color(0xFFB8E5E2);

  // Typography / Neutral palette
  static const Color ink = Color(0xFF202938); // Deep charcoal primary text
  static const Color inkSubtle = Color(0xFF3D495C); // Medium charcoal
  static const Color muted = Color(0xFF657184); // Muted secondary text
  static const Color mutedLight = Color(0xFF8E9BAE); // Placeholder / disabled text
  static const Color line = Color(0xFFE3E8F0); // Subtle divider / card border
  static const Color lineSubtle = Color(0xFFEDF2F7);

  // Semantic & status colors (with non-color accessible pairings)
  static const Color success = Color(0xFF1B8755);
  static const Color successBg = Color(0xFFEAF7EE);
  static const Color successBorder = Color(0xFFBCE3C9);

  static const Color warning = Color(0xFFB76E00);
  static const Color warningBg = Color(0xFFFFF7E6);
  static const Color warningBorder = Color(0xFFFFE0A3);

  static const Color danger = Color(0xFFC53030);
  static const Color dangerBg = Color(0xFFFDF0F0);
  static const Color dangerBorder = Color(0xFFF7C5C5);

  static const Color info = Color(0xFF2B6CB0);
  static const Color infoBg = Color(0xFFEBF3FB);
  static const Color infoBorder = Color(0xFFBEE3F8);

  // Admin accent
  static const Color adminPurple = Color(0xFF7451B8);
  static const Color adminPurpleBg = Color(0xFFF4F0FB);
  static const Color adminPurpleBorder = Color(0xFFDDD2F3);
}

class AppRadius {
  static const double sm = 6.0;
  static const double md = 10.0;
  static const double lg = 14.0;
  static const double xl = 18.0;
  static const double pill = 999.0;
}

class AppShadows {
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x060F172A),
      blurRadius: 6,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> hover = [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 18,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x2E0F172A),
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Segoe UI',
      typography: Typography.material2021(platform: TargetPlatform.windows),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
          letterSpacing: -0.3,
          height: 1.25,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
          height: 1.3,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
          height: 1.3,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: AppColors.ink,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 13.5,
          color: AppColors.ink,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.muted,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: AppColors.muted,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.line),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(color: AppColors.mutedLight, fontSize: 13.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.line),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          side: const BorderSide(color: AppColors.line),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
        ),
        waitDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

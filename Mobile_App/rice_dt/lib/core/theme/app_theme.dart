import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  // ── Light ────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.leafGreen,
        onPrimary: Colors.white,
        primaryContainer: AppColors.sageMint,
        onPrimaryContainer: AppColors.darkForest,
        secondary: AppColors.sageLight,
        onSecondary: AppColors.darkForest,
        secondaryContainer: AppColors.sageMint,
        onSecondaryContainer: AppColors.darkForest,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.error,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        onSurfaceVariant: AppColors.lightTextSecondary,
        outline: AppColors.lightBorder,
        outlineVariant: AppColors.lightBorder,
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: AppColors.darkSurface,
        onInverseSurface: AppColors.darkTextPrimary,
        inversePrimary: AppColors.sageLight,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkForest,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBackground,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.leafGreen),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.leafGreen
              : Colors.grey.shade400,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.sageMint
              : Colors.grey.shade200,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.leafGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        filled: true,
        fillColor: AppColors.lightSurface,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.leafGreen,
        linearTrackColor: AppColors.sageMint,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkForest,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Dark ─────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.sageLight,
        onPrimary: AppColors.darkForest,
        primaryContainer: AppColors.leafGreen,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.sageMint,
        onSecondary: AppColors.darkForest,
        secondaryContainer: AppColors.darkSurface2,
        onSecondaryContainer: AppColors.sageLight,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: Color(0xFF4A1010),
        onErrorContainer: AppColors.errorLight,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkBorder,
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: AppColors.lightSurface,
        onInverseSurface: AppColors.lightTextPrimary,
        inversePrimary: AppColors.leafGreen,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkSurface2,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.sageLight),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.sageLight
              : Colors.grey.shade600,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.darkSurface2
              : Colors.grey.shade800,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.leafGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        filled: true,
        fillColor: AppColors.darkSurface,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.sageLight,
        linearTrackColor: AppColors.darkSurface2,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurface2,
        contentTextStyle: const TextStyle(color: AppColors.darkTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

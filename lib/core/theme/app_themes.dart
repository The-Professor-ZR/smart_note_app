import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final primary = isDark ? AppColors.darkPrimary : AppColors.primary;
    final onPrimary = isDark ? const Color(0xFF2B1F6B) : Colors.white;
    final background =
    isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary =
    isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
    isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final hint = isDark ? AppColors.darkHint : AppColors.lightHint;
    final error = isDark ? AppColors.errorDark : AppColors.error;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: onPrimary,
      surface: background,
      onSurface: textPrimary,
      surfaceContainerHighest: surface,
      outline: border,
      error: error,
    );

    final baseText = GoogleFonts.dmSansTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(bodyColor: textPrimary, displayColor: textPrimary);

    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: baseText.copyWith(
        headlineMedium: baseText.headlineMedium?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: -0.5,
        ),
        titleLarge: baseText.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium:
        baseText.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        bodyMedium: baseText.bodyMedium?.copyWith(color: textSecondary),
        bodySmall: baseText.bodySmall?.copyWith(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: textPrimary,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        hintStyle: TextStyle(color: hint),
        labelStyle: TextStyle(
          color: primary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        border: inputBorder(border),
        enabledBorder: inputBorder(border),
        focusedBorder: inputBorder(primary, 1.6),
        errorBorder: inputBorder(error),
        focusedErrorBorder: inputBorder(error, 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(54),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        extendedTextStyle: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.darkSurface : textPrimary,
        contentTextStyle: GoogleFonts.dmSans(
          color: isDark ? AppColors.darkTextPrimary : Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: primary),
      dividerColor: border,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontStyle: FontStyle.italic,
      color: AppColors.ink,
      height: 1.65,
      letterSpacing: 0.1,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 21,
      fontStyle: FontStyle.italic,
      color: AppColors.ink,
      height: 1.65,
      letterSpacing: 0.1,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 17,
      color: AppColors.ink,
      height: 1.5,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      letterSpacing: -0.5,
    ),
    titleLarge: GoogleFonts.playfairDisplay(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    titleMedium: GoogleFonts.ibmPlexSans(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
    bodyLarge: GoogleFonts.playfairDisplay(
      fontSize: 14,
      color: AppColors.ink,
      height: 1.65,
    ),
    bodyMedium: GoogleFonts.ibmPlexSans(
      fontSize: 13,
      height: 1.5,
      color: AppColors.inkLight,
    ),
    labelLarge: GoogleFonts.ibmPlexSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.red,
      letterSpacing: 1.5,
    ),
    labelSmall: GoogleFonts.ibmPlexSans(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      color: AppColors.inkMuted,
      letterSpacing: 1.8,
    ),
  );

  static ThemeData get light {
    final colorScheme = const ColorScheme.light(
      surface: AppColors.paper,
      primary: AppColors.red,
      onPrimary: AppColors.redOnRed,
      secondary: AppColors.ink,
      onSecondary: AppColors.paper,
      onSurface: AppColors.ink,
      outline: AppColors.rule,
      error: AppColors.red,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.paper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(size: 20, color: AppColors.ink),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.ink,
        thickness: 1,
        space: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.redOnRed,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.ibmPlexSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.ink, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.ibmPlexSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.paper,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.ink, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: AppColors.rule, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: AppColors.rule, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: AppColors.red, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.paper,
        labelStyle: _textTheme.labelSmall,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        side: const BorderSide(color: AppColors.ink, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }
}

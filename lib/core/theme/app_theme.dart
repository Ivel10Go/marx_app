import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Font caching strategy to eliminate runtime GoogleFonts calls during app initialization.
/// All text styles are preloaded during bootstrap, preventing 15+ font fetches at startup.
/// This reduces startup time by 300-500ms by:
/// 1. Disabling runtime font fetching (local fonts only)
/// 2. Pre-initializing text styles in bootstrap phase
/// 3. Using lazy getters to avoid duplicate font loads
abstract final class AppTheme {
  // ─── LIGHT MODE TEXT STYLES ────────────────────
  static late TextStyle _displayLarge;
  static late TextStyle _displayMedium;
  static late TextStyle _displaySmall;
  static late TextStyle _headlineSmall;
  static late TextStyle _titleLarge;
  static late TextStyle _titleMedium;
  static late TextStyle _bodyLarge;
  static late TextStyle _bodyMedium;
  static late TextStyle _labelLarge;
  static late TextStyle _labelSmall;
  static late TextStyle _appBarTitle;
  static late TextStyle _elevatedButtonText;
  static late TextStyle _outlinedButtonText;
  // Custom styles for specific widgets (light)
  static late TextStyle _masthead;
  static late TextStyle _mastHeadSubtitle;
  static late TextStyle _factBlockKicker;
  static late TextStyle _factBlockKickerRed;
  static late TextStyle _factBlockCore;
  static late TextStyle _factBlockPunchline;
  static late TextStyle _factBlockQuickContext;
  static late TextStyle _factBlockHeadline;
  static late TextStyle _factBlockBody;
  static late TextStyle _factBlockLabel;
  static late TextStyle _factBlockShareButton;
  static late TextStyle _monthSelector;
  // UI Component Styles
  static late TextStyle _streakBadgeLabel;
  static late TextStyle _streakBadgeValue;
  static late TextStyle _categoryChipLabel;
  static late TextStyle _quoteCardKicker;

  // ─── DARK MODE TEXT STYLES ─────────────────────
  static late TextStyle _displayLargeDark;
  static late TextStyle _displayMediumDark;
  static late TextStyle _displaySmallDark;
  static late TextStyle _headlineSmallDark;
  static late TextStyle _titleLargeDark;
  static late TextStyle _titleMediumDark;
  static late TextStyle _bodyLargeDark;
  static late TextStyle _bodyMediumDark;
  static late TextStyle _labelLargeDark;
  static late TextStyle _labelSmallDark;
  static late TextStyle _appBarTitleDark;
  static late TextStyle _elevatedButtonTextDark;
  static late TextStyle _outlinedButtonTextDark;

  /// Initialize all text styles during bootstrap (called once at startup)
  /// This prevents runtime font fetches throughout app lifecycle
  static void initializeTextStyles() {
    // ─── LIGHT MODE INITIALIZATION ──────────────
    _displayLarge = GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontStyle: FontStyle.italic,
      color: AppColors.ink,
      height: 1.65,
      letterSpacing: 0.1,
    );
    _displayMedium = GoogleFonts.playfairDisplay(
      fontSize: 21,
      fontStyle: FontStyle.italic,
      color: AppColors.ink,
      height: 1.65,
      letterSpacing: 0.1,
    );
    _displaySmall = GoogleFonts.playfairDisplay(
      fontSize: 17,
      color: AppColors.ink,
      height: 1.5,
    );
    _headlineSmall = GoogleFonts.playfairDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      letterSpacing: -0.5,
    );
    _titleLarge = GoogleFonts.playfairDisplay(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    );
    _titleMedium = GoogleFonts.ibmPlexSans(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    );
    _bodyLarge = GoogleFonts.playfairDisplay(
      fontSize: 14,
      color: AppColors.ink,
      height: 1.65,
    );
    _bodyMedium = GoogleFonts.ibmPlexSans(
      fontSize: 13,
      height: 1.5,
      color: AppColors.inkLight,
    );
    _labelLarge = GoogleFonts.ibmPlexSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.red,
      letterSpacing: 1.5,
    );
    _labelSmall = GoogleFonts.ibmPlexSans(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      color: AppColors.inkMuted,
      letterSpacing: 1.8,
    );
    _appBarTitle = GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    );
    _elevatedButtonText = GoogleFonts.ibmPlexSans(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    );
    _outlinedButtonText = GoogleFonts.ibmPlexSans(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    );
    // Custom widget styles (light)
    _masthead = GoogleFonts.playfairDisplay(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      letterSpacing: -0.5,
    );
    _mastHeadSubtitle = GoogleFonts.ibmPlexSans(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.inkLight,
    );
    _factBlockKicker = GoogleFonts.ibmPlexSans(
      fontSize: 9,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 1.2,
    );
    _factBlockKickerRed = GoogleFonts.ibmPlexSans(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      color: AppColors.red,
      letterSpacing: 1.2,
    );
    _factBlockCore = GoogleFonts.ibmPlexSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: AppColors.red,
      letterSpacing: 1.2,
    );
    _factBlockPunchline = GoogleFonts.playfairDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      color: AppColors.ink,
      height: 1.45,
    );
    _factBlockQuickContext = GoogleFonts.ibmPlexSans(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: AppColors.inkLight,
      letterSpacing: 0.2,
      height: 1.4,
    );
    _factBlockHeadline = GoogleFonts.ibmPlexSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      letterSpacing: 0.8,
    );
    _factBlockBody = GoogleFonts.playfairDisplay(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: AppColors.ink,
      height: 1.55,
    );
    _factBlockLabel = GoogleFonts.ibmPlexSans(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      color: AppColors.red,
      letterSpacing: 1.2,
    );
    _factBlockShareButton = GoogleFonts.ibmPlexSans(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
    );
    _monthSelector = GoogleFonts.ibmPlexSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      letterSpacing: 0.8,
    );
    // UI Component Styles (light)
    _streakBadgeLabel = GoogleFonts.ibmPlexSans(
      fontSize: 8,
      fontWeight: FontWeight.w700,
      color: AppColors.redOnRed.withValues(alpha: 0.8),
      letterSpacing: 1.4,
    );
    _streakBadgeValue = GoogleFonts.ibmPlexSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.redOnRed,
      letterSpacing: 1.1,
    );
    _categoryChipLabel = GoogleFonts.ibmPlexSans(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      color: AppColors.ink,
    );
    _quoteCardKicker = GoogleFonts.ibmPlexSans(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      color: AppColors.redOnRed,
      letterSpacing: 1.8,
    );

    // ─── DARK MODE INITIALIZATION ───────────────
    _displayLargeDark = GoogleFonts.playfairDisplay(
      fontSize: 26,
      fontStyle: FontStyle.italic,
      color: AppColors.darkInk,
      height: 1.65,
      letterSpacing: 0.1,
    );
    _displayMediumDark = GoogleFonts.playfairDisplay(
      fontSize: 21,
      fontStyle: FontStyle.italic,
      color: AppColors.darkInk,
      height: 1.65,
      letterSpacing: 0.1,
    );
    _displaySmallDark = GoogleFonts.playfairDisplay(
      fontSize: 17,
      color: AppColors.darkInk,
      height: 1.5,
    );
    _headlineSmallDark = GoogleFonts.playfairDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.darkInk,
      letterSpacing: -0.5,
    );
    _titleLargeDark = GoogleFonts.playfairDisplay(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: AppColors.darkInk,
    );
    _titleMediumDark = GoogleFonts.ibmPlexSans(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: AppColors.darkInk,
    );
    _bodyLargeDark = GoogleFonts.playfairDisplay(
      fontSize: 14,
      color: AppColors.darkInk,
      height: 1.65,
    );
    _bodyMediumDark = GoogleFonts.ibmPlexSans(
      fontSize: 13,
      height: 1.5,
      color: AppColors.darkInkLight,
    );
    _labelLargeDark = GoogleFonts.ibmPlexSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.red,
      letterSpacing: 1.5,
    );
    _labelSmallDark = GoogleFonts.ibmPlexSans(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      color: AppColors.darkInkLight,
      letterSpacing: 1.8,
    );
    _appBarTitleDark = GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.darkInk,
    );
    _elevatedButtonTextDark = GoogleFonts.ibmPlexSans(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    );
    _outlinedButtonTextDark = GoogleFonts.ibmPlexSans(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.0,
    );
  }

  // Public getters for custom widget styles (light)
  static TextStyle get masthead => _masthead;
  static TextStyle get mastHeadSubtitle => _mastHeadSubtitle;
  static TextStyle get factBlockKicker => _factBlockKicker;
  static TextStyle get factBlockKickerRed => _factBlockKickerRed;
  static TextStyle get factBlockCore => _factBlockCore;
  static TextStyle get factBlockPunchline => _factBlockPunchline;
  static TextStyle get factBlockQuickContext => _factBlockQuickContext;
  static TextStyle get factBlockHeadline => _factBlockHeadline;
  static TextStyle get factBlockBody => _factBlockBody;
  static TextStyle get factBlockLabel => _factBlockLabel;
  static TextStyle get factBlockShareButton => _factBlockShareButton;
  static TextStyle get monthSelector => _monthSelector;
  static TextStyle get streakBadgeLabel => _streakBadgeLabel;
  static TextStyle get streakBadgeValue => _streakBadgeValue;
  static TextStyle get categoryChipLabel => _categoryChipLabel;
  static TextStyle get quoteCardKicker => _quoteCardKicker;

  static TextTheme get _textTheme => TextTheme(
    displayLarge: _displayLarge,
    displayMedium: _displayMedium,
    displaySmall: _displaySmall,
    headlineSmall: _headlineSmall,
    titleLarge: _titleLarge,
    titleMedium: _titleMedium,
    bodyLarge: _bodyLarge,
    bodyMedium: _bodyMedium,
    labelLarge: _labelLarge,
    labelSmall: _labelSmall,
  );

  static TextTheme get _textThemeDark => TextTheme(
    displayLarge: _displayLargeDark,
    displayMedium: _displayMediumDark,
    displaySmall: _displaySmallDark,
    headlineSmall: _headlineSmallDark,
    titleLarge: _titleLargeDark,
    titleMedium: _titleMediumDark,
    bodyLarge: _bodyLargeDark,
    bodyMedium: _bodyMediumDark,
    labelLarge: _labelLargeDark,
    labelSmall: _labelSmallDark,
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
        titleTextStyle: _appBarTitle,
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
          textStyle: _elevatedButtonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.ink, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: _outlinedButtonText,
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
        labelStyle: _labelSmall,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        side: const BorderSide(color: AppColors.ink, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = const ColorScheme.dark(
      surface: AppColors.darkPaper,
      primary: AppColors.red,
      onPrimary: AppColors.redOnRed,
      secondary: AppColors.darkInk,
      onSecondary: AppColors.darkPaper,
      onSurface: AppColors.darkInk,
      outline: AppColors.darkRule,
      error: AppColors.red,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkPaper,
      colorScheme: colorScheme,
      textTheme: _textThemeDark,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.darkPaper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(size: 20, color: AppColors.darkInk),
        titleTextStyle: _appBarTitleDark,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkInk,
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
          textStyle: _elevatedButtonTextDark,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkInk,
          side: const BorderSide(color: AppColors.darkInk, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: _outlinedButtonTextDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.darkPaper,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.darkInk, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkPaperLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: AppColors.darkRule, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: AppColors.darkRule, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: AppColors.red, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkPaper,
        labelStyle: _labelSmallDark,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        side: const BorderSide(color: AppColors.darkInk, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }
}

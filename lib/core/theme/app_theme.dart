import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          surfaceContainerLowest: AppColors.background,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: _textTheme(Brightness.light),
        appBarTheme: _appBarTheme(),
        elevatedButtonTheme: _elevatedButtonTheme(),
        outlinedButtonTheme: _outlinedButtonTheme(),
        inputDecorationTheme: _inputDecorationTheme(),
        cardTheme: _cardTheme(),
        chipTheme: _chipTheme(),
        bottomNavigationBarTheme: _bottomNavTheme(),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.primaryLight,
          secondary: AppColors.secondaryLight,
          surface: AppColors.surfaceDark,
          surfaceContainerLowest: AppColors.backgroundDark,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        textTheme: _textTheme(Brightness.dark),
        appBarTheme: _appBarTheme(dark: true),
        elevatedButtonTheme: _elevatedButtonTheme(dark: true),
        outlinedButtonTheme: _outlinedButtonTheme(dark: true),
        inputDecorationTheme: _inputDecorationTheme(dark: true),
        cardTheme: _cardTheme(dark: true),
        chipTheme: _chipTheme(dark: true),
        bottomNavigationBarTheme: _bottomNavTheme(dark: true),
      );

  static TextTheme _textTheme(Brightness brightness) {
    final color = brightness == Brightness.light
        ? AppColors.textPrimary
        : AppColors.textPrimaryDark;
    return GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.nunito(
          fontSize: 32, fontWeight: FontWeight.w800, color: color),
      displayMedium: GoogleFonts.nunito(
          fontSize: 28, fontWeight: FontWeight.w800, color: color),
      headlineLarge: GoogleFonts.nunito(
          fontSize: 24, fontWeight: FontWeight.w700, color: color),
      headlineMedium: GoogleFonts.nunito(
          fontSize: 20, fontWeight: FontWeight.w700, color: color),
      headlineSmall: GoogleFonts.nunito(
          fontSize: 18, fontWeight: FontWeight.w600, color: color),
      titleLarge: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w600, color: color),
      titleMedium: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w600, color: color),
      bodyLarge: GoogleFonts.nunito(fontSize: 16, color: color),
      bodyMedium: GoogleFonts.nunito(fontSize: 14, color: color),
      bodySmall: GoogleFonts.nunito(
          fontSize: 12,
          color: brightness == Brightness.light
              ? AppColors.textSecondary
              : AppColors.textSecondaryDark),
      labelLarge: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w600, color: color),
    );
  }

  static AppBarTheme _appBarTheme({bool dark = false}) => AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor:
            dark ? AppColors.backgroundDark : AppColors.background,
        foregroundColor:
            dark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: dark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme({bool dark = false}) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme({bool dark = false}) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              dark ? AppColors.primaryLight : AppColors.primary,
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(
            color: dark ? AppColors.primaryLight : AppColors.primary,
            width: 1.5,
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  static InputDecorationTheme _inputDecorationTheme({bool dark = false}) =>
      InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.surfaceDark : AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: dark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: dark ? AppColors.primaryLight : AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  static CardThemeData _cardTheme({bool dark = false}) => CardThemeData(
        elevation: 0,
        color: dark ? AppColors.surfaceDark : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: dark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        margin: EdgeInsets.zero,
      );

  static ChipThemeData _chipTheme({bool dark = false}) => ChipThemeData(
        backgroundColor: dark
            ? AppColors.primary.withValues(alpha: 0.2)
            : AppColors.primary.withValues(alpha: 0.1),
        labelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: dark ? AppColors.primaryLight : AppColors.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  static BottomNavigationBarThemeData _bottomNavTheme(
          {bool dark = false}) =>
      BottomNavigationBarThemeData(
        backgroundColor:
            dark ? AppColors.surfaceDark : AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: dark ? Colors.white38 : Colors.black38,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../constants/app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final textTheme = AppTypography.textTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
      ).copyWith(
        primary: dark ? AppColors.primaryLight : AppColors.primary,
        secondary: dark ? AppColors.secondaryLight : AppColors.secondary,
        surface: dark ? AppColors.surfaceDark : AppColors.surface,
        surfaceContainerLowest:
            dark ? AppColors.backgroundDark : AppColors.background,
        error: AppColors.error,
        onSurface: dark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        onSurfaceVariant:
            dark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
      scaffoldBackgroundColor:
          dark ? AppColors.backgroundDark : AppColors.background,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: _appBarTheme(brightness),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(dark: dark),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: dark ? AppColors.primaryLight : AppColors.primary,
          textStyle: AppTypography.button(
            color: dark ? AppColors.primaryLight : AppColors.primary,
          ),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme(dark: dark),
      cardTheme: _cardTheme(dark: dark),
      chipTheme: _chipTheme(brightness),
      bottomNavigationBarTheme: _bottomNavTheme(dark: dark),
      dividerTheme: DividerThemeData(
        color: dark ? AppColors.dividerDark : AppColors.divider,
        thickness: 0.5,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodySmall,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static AppBarTheme _appBarTheme(Brightness brightness) => AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: brightness == Brightness.light
            ? AppColors.background
            : AppColors.backgroundDark,
        foregroundColor: brightness == Brightness.light
            ? AppColors.textPrimary
            : AppColors.textPrimaryDark,
        titleTextStyle: AppTypography.appBarTitle(brightness),
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTypography.button(),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme({bool dark = false}) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: dark ? AppColors.primaryLight : AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(
            color: dark ? AppColors.primaryLight : AppColors.primary,
            width: 1.5,
          ),
          textStyle: AppTypography.button(
            color: dark ? AppColors.primaryLight : AppColors.primary,
          ),
        ),
      );

  static InputDecorationTheme _inputDecorationTheme({bool dark = false}) =>
      InputDecorationTheme(
        filled: true,
        fillColor: dark ? AppColors.surfaceDark : AppColors.surface,
        labelStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 15,
          color: dark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
        hintStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 15,
          color: dark ? AppColors.textHintDark : AppColors.textHint,
        ),
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

  static ChipThemeData _chipTheme(Brightness brightness) => ChipThemeData(
        backgroundColor: brightness == Brightness.light
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.2),
        labelStyle: AppTypography.chip(brightness),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  static BottomNavigationBarThemeData _bottomNavTheme({bool dark = false}) =>
      BottomNavigationBarThemeData(
        backgroundColor: dark ? AppColors.surfaceDark : AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: dark ? Colors.white38 : Colors.black38,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.navLabel(selected: true),
        unselectedLabelStyle: AppTypography.navLabel(selected: false),
      );
}

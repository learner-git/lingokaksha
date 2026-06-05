import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Bundled Nunito typography tuned for iOS-friendly reading sizes.
/// All styles scale automatically with the system [TextScaler].
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Nunito';

  /// Maximum text scale factor to keep dense layouts usable on iOS.
  static const double maxTextScaleFactor = 1.4;

  static TextTheme textTheme(Brightness brightness) {
    final primary = brightness == Brightness.light
        ? AppColors.textPrimary
        : AppColors.textPrimaryDark;
    final secondary = brightness == Brightness.light
        ? AppColors.textSecondary
        : AppColors.textSecondaryDark;

    TextStyle base({
      required double size,
      FontWeight weight = FontWeight.w400,
      Color? color,
      double? height,
      double? letterSpacing,
    }) {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: size,
        fontWeight: weight,
        color: color ?? primary,
        height: height,
        letterSpacing: letterSpacing,
      );
    }

    return TextTheme(
      // Large titles (iOS ~34pt)
      displayLarge: base(
        size: 34,
        weight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.5,
      ),
      displayMedium: base(
        size: 28,
        weight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.3,
      ),
      displaySmall: base(
        size: 24,
        weight: FontWeight.w700,
        height: 1.2,
      ),
      // Section headers (iOS ~22pt)
      headlineLarge: base(
        size: 22,
        weight: FontWeight.w700,
        height: 1.25,
      ),
      headlineMedium: base(
        size: 20,
        weight: FontWeight.w700,
        height: 1.25,
      ),
      headlineSmall: base(
        size: 18,
        weight: FontWeight.w600,
        height: 1.3,
      ),
      // Emphasized body
      titleLarge: base(
        size: 17,
        weight: FontWeight.w600,
        height: 1.35,
      ),
      titleMedium: base(
        size: 15,
        weight: FontWeight.w600,
        height: 1.35,
      ),
      titleSmall: base(
        size: 13,
        weight: FontWeight.w600,
        height: 1.35,
      ),
      // Body (iOS default ~17pt)
      bodyLarge: base(
        size: 17,
        weight: FontWeight.w400,
        height: 1.45,
      ),
      bodyMedium: base(
        size: 15,
        weight: FontWeight.w400,
        height: 1.45,
      ),
      bodySmall: base(
        size: 13,
        weight: FontWeight.w400,
        color: secondary,
        height: 1.4,
      ),
      // Labels & buttons
      labelLarge: base(
        size: 15,
        weight: FontWeight.w600,
        height: 1.2,
      ),
      labelMedium: base(
        size: 13,
        weight: FontWeight.w600,
        height: 1.2,
      ),
      labelSmall: base(
        size: 11,
        weight: FontWeight.w600,
        color: secondary,
        height: 1.2,
      ),
    );
  }

  static TextStyle button({Color color = Colors.white}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.2,
      );

  static TextStyle appBarTitle(Brightness brightness) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: brightness == Brightness.light
            ? AppColors.textPrimary
            : AppColors.textPrimaryDark,
      );

  static TextStyle navLabel({required bool selected}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      );

  static TextStyle chip(Brightness brightness) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: brightness == Brightness.light
            ? AppColors.primary
            : AppColors.primaryLight,
      );
}

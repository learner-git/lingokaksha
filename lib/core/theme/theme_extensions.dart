import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_typography.dart';

extension AppThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  bool get isDark => theme.brightness == Brightness.dark;

  Color get textPrimary =>
      isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

  Color get textSecondary =>
      isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

  Color get surfaceColor =>
      isDark ? AppColors.surfaceDark : AppColors.surface;

  Color get backgroundColor =>
      isDark ? AppColors.backgroundDark : AppColors.background;

  Color get dividerColor =>
      isDark ? AppColors.dividerDark : AppColors.divider;
}

/// Applies a readable text-scale clamp for dense screens (iOS Dynamic Type).
class AppTextScaler extends StatelessWidget {
  final Widget child;

  const AppTextScaler({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final clamped = scaler.clamp(
      minScaleFactor: 1.0,
      maxScaleFactor: AppTypography.maxTextScaleFactor,
    );

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: clamped),
      child: child,
    );
  }
}

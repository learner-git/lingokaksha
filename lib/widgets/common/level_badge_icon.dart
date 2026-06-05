import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import 'app_svg.dart';

/// CEFR level badge with a consistent vector icon.
class LevelBadgeIcon extends StatelessWidget {
  final String level;
  final double size;
  final Color? color;

  const LevelBadgeIcon({
    super.key,
    required this.level,
    this.size = 40,
    this.color,
  });

  Color _levelColor(String code) {
    switch (code.toUpperCase()) {
      case 'A1':
        return AppColors.levelA1;
      case 'A2':
        return AppColors.levelA2;
      case 'B1':
        return AppColors.levelB1;
      case 'B2':
        return AppColors.levelB2;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tint = color ?? _levelColor(level);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      alignment: Alignment.center,
      child: AppSvg(
        asset: AppAssets.levelIcon(level),
        width: size * 0.55,
        height: size * 0.55,
        color: tint,
      ),
    );
  }
}

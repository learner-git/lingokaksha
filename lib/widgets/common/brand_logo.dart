import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import 'app_svg.dart';

/// Shared brand mark used on splash, login, and other entry screens.
class BrandLogo extends StatelessWidget {
  final double size;
  final bool showShadow;

  const BrandLogo({
    super.key,
    this.size = 100,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.28;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: EdgeInsets.all(size * 0.18),
          child: const AppSvg(
            asset: AppAssets.logoMark,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/theme_extensions.dart';

/// Single shimmer placeholder block.
class AppSkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  const AppSkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final base = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE2E8F0);
    final highlight =
        isDark ? const Color(0xFF3A3A52) : const Color(0xFFF1F5F9);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Home screen loading placeholder.
class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          AppSkeletonBox(width: 120, height: 14),
          SizedBox(height: 12),
          AppSkeletonBox(width: 220, height: 28),
          SizedBox(height: 24),
          AppSkeletonBox(width: double.infinity, height: 120, borderRadius: BorderRadius.all(Radius.circular(20))),
          SizedBox(height: 16),
          AppSkeletonBox(width: double.infinity, height: 120, borderRadius: BorderRadius.all(Radius.circular(20))),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: AppSkeletonBox(height: 88, borderRadius: BorderRadius.all(Radius.circular(14)))),
              SizedBox(width: 10),
              Expanded(child: AppSkeletonBox(height: 88, borderRadius: BorderRadius.all(Radius.circular(14)))),
            ],
          ),
        ],
      ),
    );
  }
}

/// Quiz loading placeholder.
class QuizLoadingSkeleton extends StatelessWidget {
  final String? message;

  const QuizLoadingSkeleton({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppSkeletonBox(
              width: double.infinity,
              height: 100,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            const SizedBox(height: 16),
            const AppSkeletonBox(width: double.infinity, height: 52),
            const SizedBox(height: 12),
            const AppSkeletonBox(width: double.infinity, height: 52),
            const SizedBox(height: 12),
            const AppSkeletonBox(width: double.infinity, height: 52),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

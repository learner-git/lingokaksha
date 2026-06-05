import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../core/constants/app_assets.dart';
import '../../widgets/common/brand_logo.dart';
import '../../widgets/common/app_svg.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    final user = ref.read(authStateProvider).valueOrNull;
    if (user != null) {
      context.go('/home');
    } else {
      context.go('/auth/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BrandLogo(size: 100, showShadow: true)
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 20),
            const AppSvg(
              asset: AppAssets.logoWordmark,
              width: 240,
              height: 40,
              color: Colors.white,
            )
                .animate()
                .slideY(begin: 0.3, duration: 500.ms, delay: 200.ms)
                .fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              'Learn with AI',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 500.ms),
            const SizedBox(height: 60),
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                color: Colors.white54,
                strokeWidth: 2.5,
              ),
            ).animate().fadeIn(duration: 300.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}

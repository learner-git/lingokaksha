import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

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
    await Future.delayed(const Duration(milliseconds: 2000));
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
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Center(
                child: Text(
                  '🇩🇪',
                  style: TextStyle(fontSize: 52),
                ),
              ),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            const Text(
              'LingoKaksha',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            )
                .animate()
                .slideY(begin: 0.3, duration: 500.ms, delay: 200.ms)
                .fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: 8),
            const Text(
              'Learn with AI',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers/auth_provider.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/onboarding_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/lesson/lesson_screen.dart';
import '../../screens/lesson/lesson_list_screen.dart';
import '../../screens/lesson/dynamic_lesson_screen.dart';
import '../../screens/quiz/quiz_screen.dart';
import '../../screens/quiz/quiz_hub_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/vocabulary/vocabulary_screen.dart';
import '../../widgets/common/main_shell.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/voice/voice_tutor_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final auth = authState;

      if (auth.isLoading) return '/splash';

      final isLoggedIn = auth.valueOrNull != null;

      final isSplash = state.matchedLocation == '/splash';
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isLoggedIn && !isAuthRoute) {
        return '/auth/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      if (isSplash) return null;

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (_, __) => const LoginScreen(),
        routes: [
          GoRoute(
            path: 'onboarding',
            name: 'onboarding',
            builder: (_, __) => const OnboardingScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/lessons',
            name: 'lessons',
            builder: (_, __) => const LessonListScreen(),
          ),
          GoRoute(
            path: '/lesson/:topic',
            name: 'lesson',
            builder: (_, state) => DynamicLessonScreen(
              topic: state.pathParameters['topic']!,
              level: state.uri.queryParameters['level'] ?? 'A1',
            ),
          ),
          GoRoute(
            path: '/chat',
            name: 'chat',
            builder: (_, __) => const ChatScreen(),
          ),
          GoRoute(
            path: '/voice-tutor',
            name: 'voice-tutor',
            builder: (_, __) => const VoiceTutorScreen(),
          ),
          GoRoute(
            path: '/quiz-hub',
            name: 'quiz-hub',
            builder: (_, __) => const QuizHubScreen(),
          ),
          GoRoute(
            path: '/quiz/:topic',
            name: 'quiz',
            builder: (_, state) => QuizScreen(
              topic: state.pathParameters['topic']!,
              level: state.uri.queryParameters['level'] ?? 'A2',
            ),
          ),
          GoRoute(
            path: '/vocabulary',
            name: 'vocabulary',
            builder: (_, __) => const VocabularyScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (_, __) => const DashboardScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

import '../../core/constants/app_constants.dart';
import '../../data/repositories/user_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _selectedLanguage = AppConstants.defaultLanguage;
  String? _selectedLevel;
  int _goalMinutes = 10;
  bool _isSaving = false;

  final _languages = AppConstants.supportedLanguages;
  final List<Map<String, dynamic>> _levels = [
    {
      'code': 'A1',
      'label': 'Complete Beginner',
      'desc': 'I know little or no German',
      'emoji': '🌱',
      'color': AppColors.levelA1,
    },
    {
      'code': 'A2',
      'label': 'Elementary',
      'desc': 'I know basic words and phrases',
      'emoji': '📗',
      'color': AppColors.levelA2,
    },
    {
      'code': 'B1',
      'label': 'Intermediate',
      'desc': 'I can hold simple conversations',
      'emoji': '📘',
      'color': AppColors.levelB1,
    },
    {
      'code': 'B2',
      'label': 'Upper Intermediate',
      'desc': 'I can discuss most topics',
      'emoji': '📙',
      'color': AppColors.levelB2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Let\'s build your\nlearning path',
                style: theme.textTheme.displayMedium,
              ).animate().fadeIn().slideY(begin: -0.1),
              const SizedBox(height: 8),
              Text(
                'Personalize your LingoKaksha experience',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 32),

              // Language selection
              Text(
                'Which language do you want to learn?',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: _languages.map((lang) {
                  final sel = _selectedLanguage == lang['id'];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedLanguage = lang['id']),
                        child: AnimatedContainer(
                          duration: 200.ms,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: sel ? AppColors.primary : AppColors.divider,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              lang['name']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: sel ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),
              Text(
                'What is your current level?',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              
              // Level cards
              Expanded(
                child: ListView.separated(
                  itemCount: _levels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final level = _levels[i];
                    final selected = _selectedLevel == level['code'];
                    return _LevelCard(
                      level: level,
                      selected: selected,
                      onTap: () =>
                          setState(() => _selectedLevel = level['code'] as String),
                    ).animate().fadeIn(delay: (100 + i * 60).ms).slideX(begin: 0.15);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Daily goal
              Text(
                'Daily goal',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [5, 10, 15, 20].map((min) {
                  final sel = _goalMinutes == min;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => setState(() => _goalMinutes = min),
                        child: AnimatedContainer(
                          duration: 200.ms,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: sel
                                  ? AppColors.primary
                                  : AppColors.divider,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$min',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: sel
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'min',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: sel
                                      ? Colors.white70
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_selectedLevel == null || _isSaving)
                      ? null
                      : _handleFinish,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Start learning'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleFinish() async {
    setState(() => _isSaving = true);
    try {
      final userRepo = ref.read(userRepositoryProvider);
      // Update global level and language choice
      await userRepo.updateLevels(
        currentLevel: _selectedLevel!,
        targetLevel: 'B2', // Default target
      );
      
      // Initialize the chosen language slot in Firestore
      // (This follows the professional users/{uid}/languages/{id} pattern)
      await userRepo.flushSession(
        xpEarned: 0,
        events: [],
        language: _selectedLanguage,
      );

      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving preferences: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

class _LevelCard extends StatelessWidget {
  final Map<String, dynamic> level;
  final bool selected;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = level['color'] as Color;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : AppColors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              level['emoji'] as String,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          level['code'] as String,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        level['label'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level['desc'] as String,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: color, size: 22),
          ],
        ),
      ),
    );
  }
}

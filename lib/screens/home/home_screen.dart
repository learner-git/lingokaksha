import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../../providers/auth_provider.dart';
import '../../providers/session_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/vocab_provider.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/curriculum_repository.dart';
import '../../widgets/common/app_skeleton.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final session = ref.watch(sessionNotifierProvider);
    final userDoc = ref.watch(userDocProvider);
    final selectedLevel = ref.watch(selectedLevelProvider) ?? 'A1';
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: userDoc.when(
          data: (doc) {
            final data = doc.data() ?? {};
            
            // Use the locally selected level for logic but sync other data
            final level = selectedLevel;
            
            // Derive lesson ID from level if not explicitly set for this level
            final currentLesson = data['currentLesson_$level'] ?? '${level.toLowerCase()}-intro';
            final xp = data['xp_$level'] ?? 0;

            return CustomScrollView(
              slivers: [
                /// ── Header ─────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _greeting(ref.watch(selectedLanguageProvider)),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: context.textSecondary,
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      user?.displayName ??
                                          user?.email?.split('@').first ??
                                          'Learner',
                                      style: theme.textTheme.headlineLarge,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  _LevelDropdown(currentLevel: level),
                                  const SizedBox(width: 4),
                                  const _LanguageSelector(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            (user?.displayName?.isNotEmpty == true
                                    ? user!.displayName![0]
                                    : 'L')
                                .toUpperCase(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
                ),

                /// ── Level Selection (Conditional) ────────
                if (data['targetLevel'] == null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: _LevelSetupCard(
                        currentLevel: level,
                        onUpdate: (curr, target) => ref
                            .read(userRepositoryProvider)
                            .updateLevels(
                                currentLevel: curr, targetLevel: target),
                      ),
                    ),
                  ),

                /// ── Streak Card ─────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _StreakCard(
                      sessionXp: session.sessionXp,
                      level: level,
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                ),

                /// ── Continue Lesson ─────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Continue learning',
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Builder(
                          builder: (context) {
                            final topics = ref.watch(curriculumRepositoryProvider).getTopicsByLevel(level);
                            if (topics.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                                ),
                                child: const Text('No lessons available for this level yet.',
                                    style: TextStyle(color: AppColors.textSecondary)),
                              );
                            }
                            return _ContinueLessonCard(
                              lessonTopic: topics.first.id,
                              level: level,
                            );
                          }
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 150.ms),
                ),

                /// ── Quick Actions ───────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quick actions',
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),
                        const _QuickActionsGrid(),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                ),

                /// ── Practice Challenge (Quiz) ─────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: _PracticeChallengeCard(level: level),
                  ).animate().fadeIn(delay: 220.ms),
                ),

                /// ── Word of the Day ─────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    child: const _WordOfTheDay(),
                  ).animate().fadeIn(delay: 250.ms),
                ),
              ],
            );
          },

          loading: () => const HomeLoadingSkeleton(),
          error: (_, __) =>
              const Center(child: Text('Failed to load user data')),
        ),
      ),
    );
  }

  String _greeting(String language) {
    final hour = DateTime.now().hour;
    if (language == 'french') {
      if (hour < 18) return 'Bonjour !';
      return 'Bonsoir !';
    }
    if (language == 'spanish') {
      if (hour < 12) return '¡Buenos días!';
      if (hour < 20) return '¡Buenas tardes!';
      return '¡Buenas noches!';
    }
    // Default to German
    if (hour < 12) return 'Guten Morgen!';
    if (hour < 17) return 'Guten Tag!';
    return 'Guten Abend!';
  }
}

/// ── Level Setup Card ──────────────────────────────────────────
/// ── Language Selector ──────────────────────────────────────────
class _LanguageSelector extends ConsumerWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLanguage = ref.watch(selectedLanguageProvider);
    
    // Map for flags and labels
    const languages = {
      'german': {'flag': '🇩🇪', 'name': 'German'},
      'french': {'flag': '🇫🇷', 'name': 'French'},
      'spanish': {'flag': '🇪🇸', 'name': 'Spanish'},
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: activeLanguage,
          isDense: true,
          items: languages.entries.map((e) {
            return DropdownMenuItem(
              value: e.key,
              child: Row(
                children: [
                  Text(
                    e.value['flag']!,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    e.value['name']!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(selectedLanguageProvider.notifier).state = val;
              ref.read(userRepositoryProvider).updateUserField('targetLanguage', val);
            }
          },
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.secondary,
            size: 14,
          ),
        ),
      ),
    );
  }
}

/// ── Level Setup Card ──────────────────────────────────────────
class _LevelSetupCard extends StatelessWidget {
  final String currentLevel;
  final Function(String, String) onUpdate;

  const _LevelSetupCard({
    required this.currentLevel,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personalize your path',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          const Text(
            'Set your target level to get tailored content.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _LevelChip(label: 'Target: B1', onTap: () => onUpdate(currentLevel, 'B1')),
              const SizedBox(width: 8),
              _LevelChip(label: 'Target: B2', onTap: () => onUpdate(currentLevel, 'B2')),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LevelChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
    );
  }
}

/// ── Level Dropdown ──────────────────────────────────────────
class _LevelDropdown extends ConsumerWidget {
  final String currentLevel;

  const _LevelDropdown({required this.currentLevel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'Business'];
    // Listen to the local state for instant feedback
    final activeLevel = ref.watch(selectedLevelProvider) ?? currentLevel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: levels.contains(activeLevel) ? activeLevel : 'A1',
          isDense: true,
          items: levels.map((l) {
            return DropdownMenuItem(
              value: l,
              child: Text(
                l,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              // 1. Update local state immediately (Instant UI feedback)
              ref.read(selectedLevelProvider.notifier).state = val;
              // 2. Sync to Firestore in the background
              ref.read(userRepositoryProvider).updateLevel(val);
            }
          },
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
            size: 14,
          ),
        ),
      ),
    );
  }
}

/// ── Streak Card ─────────────────────────────────────────────
class _StreakCard extends StatelessWidget {
  final int sessionXp;
  final String level;

  const _StreakCard({
    required this.sessionXp,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.15),
            AppColors.accent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keep learning!',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  sessionXp > 0
                      ? "$sessionXp XP earned today"
                      : "Start your lesson today 🚀",
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              level,
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ── Continue Lesson Card ─────────────────────────────────────
class _ContinueLessonCard extends StatelessWidget {
  final String lessonTopic;
  final String level;

  const _ContinueLessonCard({
    required this.lessonTopic,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/lesson/$lessonTopic?level=$level'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$level · Current',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.play_circle_rounded,
                    color: Colors.white, size: 28),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              lessonTopic.replaceAll('-', ' ').toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: 0.1, // Placeholder
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              'Click to start lesson',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── Quick Actions ───────────────────────────────────────────
class _QuickActionsGrid extends ConsumerWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final actions = [
      {
        'icon': Icons.menu_book_rounded,
        'label': 'Lessons',
        'sub': 'Explore curriculum',
        'color': AppColors.primary,
        'route': '/lessons',
      },
      {
        'icon': Icons.chat_bubble_rounded,
        'label': 'Chat Tutor',
        'sub': 'Practice speaking',
        'color': AppColors.secondary,
        'route': '/chat',
      },
      {
        'icon': Icons.mic_rounded,
        'label': 'Voice Tutor',
        'sub': 'AI Voice Practice',
        'color': Colors.deepPurple,
        'route': '/voice-tutor',
      },
      {
        'icon': Icons.style_rounded,
        'label': 'Vocabulary',
        'sub': 'Flashcard review',
        'color': AppColors.secondary,
        'route': '/vocabulary',
      },
      {
        'icon': Icons.quiz_rounded,
        'label': 'Quiz Center',
        'sub': 'Test your skills',
        'color': AppColors.warning,
        'route': '/quiz-hub',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.85,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        final color = action['color'] as Color;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(action['route'] as String),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: color.withOpacity(0.15), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          action['label'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          action['sub'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PracticeChallengeCard extends ConsumerWidget {
  final String level;
  const _PracticeChallengeCard({required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(curriculumRepositoryProvider).getTopicsByLevel(level);

    if (topics.isEmpty) return const SizedBox.shrink();

    // Pick a random topic from the curriculum
    final randomTopic = topics[math.Random().nextInt(topics.length)].id;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Challenge',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Take a quick 5-question quiz on ${randomTopic.replaceAll("-", " ")}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push('/quiz/$randomTopic?level=$level'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Start Quiz'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text('🎯', style: TextStyle(fontSize: 48)),
        ],
      ),
    );
  }
}

/// ── Word of the Day ───────────────────────────────────────────────
class _WordOfTheDay extends ConsumerWidget {
  const _WordOfTheDay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final word = ref.watch(wordOfTheDayProvider);
    final theme = Theme.of(context);

    if (word == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('💡', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Text(
                'Word of the day',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.secondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  word.level,
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            word.targetText,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            word.english,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (word.exampleSentence != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.secondary.withOpacity(0.1)),
              ),
              child: Text(
                '"${word.exampleSentence}"',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

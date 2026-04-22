import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/session_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String topic;
  final String level;
  const QuizScreen({super.key, required this.topic, required this.level});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizNotifierProvider.notifier).loadQuiz(
            topic: widget.topic,
            level: widget.level,
            count: 5,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quiz: ${widget.topic}',
                style: theme.textTheme.titleLarge),
            Text('Level ${widget.level}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            ref.read(quizNotifierProvider.notifier).resetQuiz();
            context.go('/home');
          },
        ),
      ),
      body: quizState.when(
        loading: () => const _QuizLoading(),
        error: (e, _) => _QuizError(
          error: e.toString(),
          onRetry: () => ref.read(quizNotifierProvider.notifier).loadQuiz(
                topic: widget.topic,
                level: widget.level,
              ),
        ),
        data: (session) {
          if (session == null) return const _QuizLoading();
          if (session.completed) {
            return _QuizResult(session: session);
          }
          final q = session.questions[session.currentIndex];
          final userAnswer = session.userAnswers[session.currentIndex];
          final answered = userAnswer != null;
          final isDark = theme.brightness == Brightness.dark;
          
          final cardColor = isDark ? AppColors.surfaceVariantDark : theme.cardColor;
          final borderColor = isDark ? AppColors.dividerDark : AppColors.divider;
          final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
          final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Progress bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (session.currentIndex + 1) /
                                session.questions.length,
                            backgroundColor: borderColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.warning),
                            minHeight: 7,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${session.currentIndex + 1}/${session.questions.length}',
                        style: theme.textTheme.bodySmall?.copyWith(color: secondaryTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Question card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      q.question,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                      .animate(key: ValueKey(session.currentIndex))
                      .fadeIn(duration: 300.ms)
                      .scale(begin: const Offset(0.95, 0.95)),

                  const SizedBox(height: 20),

                  // Answer options
                  Expanded(
                    child: ListView(
                      children: q.options.asMap().entries.map((entry) {
                        final i = entry.key;
                        final opt = entry.value;
                        Color? bg;
                        Color? border;
                        Color textColor = primaryTextColor;

                        if (answered) {
                          if (i == q.correctIndex) {
                            bg = AppColors.correct.withOpacity(0.15);
                            border = AppColors.correct;
                            textColor = AppColors.correct;
                          } else if (i == userAnswer) {
                            bg = AppColors.incorrect.withOpacity(0.15);
                            border = AppColors.incorrect;
                            textColor = AppColors.incorrect;
                          }
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: answered
                                ? null
                                : () => ref
                                    .read(quizNotifierProvider.notifier)
                                    .answerQuestion(
                                        session.currentIndex, i),
                            child: AnimatedContainer(
                              duration: 200.ms,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                              decoration: BoxDecoration(
                                color: bg ?? cardColor,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: border ?? borderColor,
                                  width: border != null ? 2 : 1,
                                ),
                                boxShadow: [
                                  if (!answered)
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: (border ?? borderColor)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        ['A', 'B', 'C', 'D'][i],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                          color: border ?? secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      opt,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                  if (answered && i == q.correctIndex)
                                    const Icon(Icons.check_circle_rounded,
                                        color: AppColors.correct, size: 20),
                                  if (answered &&
                                      i == userAnswer &&
                                      i != q.correctIndex)
                                    const Icon(Icons.cancel_rounded,
                                        color: AppColors.incorrect, size: 20),
                                ],
                              ),
                            ),
                          ),
                        )
                            .animate(delay: (i * 60).ms)
                            .fadeIn(duration: 250.ms)
                            .slideX(begin: 0.1);
                      }).toList(),
                    ),
                  ),

                  // Explanation
                  if (answered) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: (userAnswer == q.correctIndex
                                ? AppColors.correct
                                : AppColors.incorrect)
                            .withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (userAnswer == q.correctIndex
                                  ? AppColors.correct
                                  : AppColors.incorrect)
                              .withOpacity(0.4),
                        ),
                      ),
                      child: Text(q.explanation,
                          style: const TextStyle(fontSize: 13, height: 1.5)),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.2),
                    const SizedBox(height: 12),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: answered
                          ? () => ref
                              .read(quizNotifierProvider.notifier)
                              .nextQuestion()
                          : null,
                      child: Text(session.currentIndex ==
                              session.questions.length - 1
                          ? 'See results'
                          : 'Next question'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Loading state ────────────────────────────────────────────────────────────
class _QuizLoading extends StatelessWidget {
  const _QuizLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('GermanShikshak is preparing your quiz...',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          const Text('🤖', style: TextStyle(fontSize: 36))
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 1500.ms),
        ],
      ),
    );
  }
}

// ── Error state ──────────────────────────────────────────────────────────────
class _QuizError extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _QuizError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😕', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text('Could not generate quiz',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Oops! This service is temporarily unavailable. Please try again later.',
                style: TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Result screen ────────────────────────────────────────────────────────────
class _QuizResult extends ConsumerWidget {
  final dynamic session;
  const _QuizResult({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = session.score as int;
    final total = session.questions.length as int;
    final accuracy = score / total;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionNotifierProvider.notifier).recordQuizResult(score, total);
    });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              accuracy >= 0.8 ? '🎉' : accuracy >= 0.5 ? '👍' : '💪',
              style: const TextStyle(fontSize: 72),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            Text(
              accuracy >= 0.8
                  ? 'Ausgezeichnet!'
                  : accuracy >= 0.5
                      ? 'Gut gemacht!'
                      : 'Keep practising!',
              style: Theme.of(context).textTheme.headlineMedium,
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 8),
            Text(
              '$score / $total correct · +${session.xpEarned} XP',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 16),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(quizNotifierProvider.notifier).resetQuiz();
                  context.go('/home');
                },
                child: const Text('Back to home'),
              ),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(quizNotifierProvider.notifier).loadQuiz(
                        topic: session.topic as String,
                        level: session.level as String,
                      );
                },
                child: const Text('Try again'),
              ),
            ).animate().fadeIn(delay: 550.ms),
          ],
        ),
      ),
    );
  }
}

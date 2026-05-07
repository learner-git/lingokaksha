import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/session_provider.dart';
import '../../providers/user_provider.dart';
import '../../data/services/gpt_service.dart';
import '../../data/models/lesson_model.dart';
import '../../data/services/audio_service.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String lessonId;
  final String? level;
  const LessonScreen({super.key, required this.lessonId, this.level});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  int _currentStep = 0;
  int? _selectedOption;
  bool _answered = false;
  int _score = 0;
  
  LessonContent? _lessonContent;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final language = ref.read(selectedLanguageProvider);
      final level = widget.level ?? ref.read(selectedLevelProvider) ?? 'A1';
      
      final content = await ref.read(gptServiceProvider).generateLesson(
        topic: widget.lessonId,
        level: level,
        language: language,
      );

      if (mounted) {
        setState(() {
          _lessonContent = content;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _steps {
    if (_lessonContent == null) return [];
    
    final List<Map<String, dynamic>> steps = [];
    
    // Explanation steps
    for (var segment in _lessonContent!.explanation) {
      steps.add({
        'type': 'explanation',
        'title': _lessonContent!.title,
        'targetText': segment.targetText,
        'english': segment.english,
        'content': '', // Using targetText/english fields instead
      });
    }

    // Dialogue step
    if (_lessonContent!.dialogue.isNotEmpty) {
      steps.add({
        'type': 'explanation',
        'title': 'Dialogue',
        'content': 'Listen and read this conversation.',
        'dialogue': _lessonContent!.dialogue,
      });
    }

    // Common Pitfall
    if (_lessonContent!.commonPitfall != null) {
      steps.add({
        'type': 'explanation',
        'title': 'Common Pitfall',
        'content': 'Be careful with this common mistake.',
        'pitfall': _lessonContent!.commonPitfall,
      });
    }

    // Pro Tip
    if (_lessonContent!.proTip != null && _lessonContent!.proTip!.isNotEmpty) {
      steps.add({
        'type': 'explanation',
        'title': 'Pro-Tip',
        'content': 'A little something to help you remember.',
        'proTip': _lessonContent!.proTip,
      });
    }

    // Example steps
    if (_lessonContent!.examples.isNotEmpty) {
      steps.add({
        'type': 'explanation',
        'title': 'Examples',
        'content': 'Study these examples carefully.',
        'examples': _lessonContent!.examples,
      });
    }

    // Quiz steps
    for (var q in _lessonContent!.practiceQuestions) {
      steps.add({
        'type': 'multiple_choice',
        'question': q.question,
        'options': q.options,
        'correct': q.correctIndex,
        'explanation': q.explanation,
      });
    }

    return steps;
  }

  bool get _isLastStep => _currentStep >= _steps.length - 1;
  Map<String, dynamic> get _step => _steps[_currentStep];

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == _step['correct']) _score++;
    });
  }

  void _next() {
    if (_isLastStep) {
      ref.read(sessionNotifierProvider.notifier)
          .recordLessonComplete(widget.lessonId, _score);
      _showResultDialog();
      return;
    }
    setState(() {
      _currentStep++;
      _selectedOption = null;
      _answered = false;
    });
  }

  void _showResultDialog() {
    final total = _steps.where((s) => s['type'] == 'multiple_choice').length;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            const Text('Lesson Complete!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '$_score / $total correct • +${_score * 5 + 20} XP',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/home');
                },
                child: const Text('Back to home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text('Generating your lesson...', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              const Text('This may take up to a minute.', 
                  style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    if (_error != null || _lessonContent == null) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              const Text('Failed to load lesson', 
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_error ?? 'Unknown error occurred', 
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadLesson, 
                child: const Text('Try Again'),
              ),
              TextButton(
                onPressed: () => context.go('/home'), 
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    }

    final progress = (_currentStep + 1) / _steps.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/home'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lesson Progress',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 2),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.divider,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 5,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentStep + 1}/${_steps.length}',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: _step['type'] == 'explanation'
                    ? _ExplanationStep(step: _step)
                        .animate(key: ValueKey(_currentStep))
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: 0.1)
                    : _QuizStep(
                        step: _step,
                        selectedOption: _selectedOption,
                        answered: _answered,
                        onSelect: _selectOption,
                      )
                        .animate(key: ValueKey(_currentStep))
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: 0.1),
              ),

              // Feedback banner
              if (_answered && _step['type'] == 'multiple_choice')
                _FeedbackBanner(
                  correct: _selectedOption == _step['correct'],
                  explanation: _step['explanation'] as String,
                )
                    .animate()
                    .slideY(begin: 0.3, duration: 300.ms)
                    .fadeIn(duration: 300.ms),

              const SizedBox(height: 16),

              // Continue / Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_step['type'] == 'multiple_choice' && !_answered)
                      ? null
                      : _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _answered && _selectedOption == _step['correct']
                            ? AppColors.success
                            : AppColors.primary,
                  ),
                  child: Text(_isLastStep ? 'Finish lesson' : 'Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Explanation Step ─────────────────────────────────────────────────────────
class _ExplanationStep extends ConsumerWidget {
  final Map<String, dynamic> step;
  const _ExplanationStep({required this.step});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step['title'] as String,
              style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(step['content'] as String,
              style: theme.textTheme.bodyLarge),
          const SizedBox(height: 20),
          if (step.containsKey('targetText'))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(step['targetText'] as String,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.5)),
                      ),
                      IconButton(
                        onPressed: () => ref.read(audioServiceProvider).pronounce(step['targetText'] as String),
                        icon: const Icon(Icons.volume_up, size: 22, color: AppColors.primary),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(step['english'] as String,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 14)),
                ],
              ),
            ),
          if (step.containsKey('examples')) ...[
            const SizedBox(height: 16),
            ...(step['examples'] as List<LessonExample>).map((ex) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(ex.targetText,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          onPressed: () => ref.read(audioServiceProvider).pronounce(ex.targetText),
                          icon: const Icon(Icons.volume_up, size: 18, color: AppColors.primary),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    Text(ex.english,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textSecondary)),
                    if (ex.note != null) ...[
                      const SizedBox(height: 8),
                      Text("Note: ${ex.note}",
                          style: const TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.primary)),
                    ]
                  ],
                ),
              ),
            )),
          ],
          if (step.containsKey('dialogue')) ...[
            const SizedBox(height: 16),
            _buildDialogueSection(step['dialogue'] as List<LessonDialogueLine>, theme, ref),
          ],
          if (step.containsKey('pitfall')) ...[
            const SizedBox(height: 16),
            _buildCommonPitfall(step['pitfall'] as LessonCommonPitfall),
          ],
          if (step.containsKey('proTip')) ...[
            const SizedBox(height: 16),
            _buildProTip(step['proTip'] as String),
          ],
          if (step.containsKey('rule')) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('💡', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 6),
                      Text('Grammar rule',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(step['rule'] as String,
                      style: const TextStyle(fontSize: 14, height: 1.6)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDialogueSection(List<LessonDialogueLine> dialogue, ThemeData theme, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.divider.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: dialogue.map((line) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(line.speaker[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(line.speaker, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(line.text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                        IconButton(
                          onPressed: () => ref.read(audioServiceProvider).pronounce(line.text),
                          icon: const Icon(Icons.volume_up, size: 18, color: AppColors.primary),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    Text(line.translation, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCommonPitfall(LessonCommonPitfall pitfall) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
              SizedBox(width: 8),
              Text('Common Pitfall', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 12),
          Text('❌ ${pitfall.error}', style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text('✅ ${pitfall.correction}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(pitfall.explanation, style: const TextStyle(fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildProTip(String proTip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb, color: AppColors.secondary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pro-Tip', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 16)),
                const SizedBox(height: 4),
                Text(proTip, style: const TextStyle(fontSize: 14, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quiz Step ────────────────────────────────────────────────────────────────
class _QuizStep extends StatelessWidget {
  final Map<String, dynamic> step;
  final int? selectedOption;
  final bool answered;
  final void Function(int) onSelect;

  const _QuizStep({
    required this.step,
    required this.selectedOption,
    required this.answered,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final options = (step['options'] as List).cast<String>();
    final correct = step['correct'] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Icon(Icons.quiz_outlined, color: AppColors.primary, size: 20),
          SizedBox(width: 8),
          Text('Choose the correct answer',
              style:
                  TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              Text(
                step['question'] as String,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
                textAlign: TextAlign.center,
              ),
              if (step.containsKey('translation')) ...[
                const SizedBox(height: 8),
                Text(step['translation'] as String,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...options.asMap().entries.map((e) {
          final i = e.key;
          final opt = e.value;
          Color? bg;
          Color? borderColor;
          Color textColor = AppColors.textPrimary;

          if (answered) {
            if (i == correct) {
              bg = AppColors.correctBg;
              borderColor = AppColors.correct;
              textColor = AppColors.correct;
            } else if (i == selectedOption) {
              bg = AppColors.incorrectBg;
              borderColor = AppColors.incorrect;
              textColor = AppColors.incorrect;
            }
          } else if (i == selectedOption) {
            bg = AppColors.selectedBg;
            borderColor = AppColors.primary;
            textColor = AppColors.primary;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: 200.ms,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bg ?? Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: borderColor ?? AppColors.divider,
                    width: borderColor != null ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(opt,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: textColor)),
                    ),
                    if (answered && i == correct)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.correct, size: 20),
                    if (answered && i == selectedOption && i != correct)
                      const Icon(Icons.cancel_rounded,
                          color: AppColors.incorrect, size: 20),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ── Feedback Banner ──────────────────────────────────────────────────────────
class _FeedbackBanner extends StatelessWidget {
  final bool correct;
  final String explanation;
  const _FeedbackBanner({required this.correct, required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: correct ? AppColors.correctBg : AppColors.incorrectBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: correct ? AppColors.correct : AppColors.incorrect,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(correct ? '✅' : '❌', style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  correct ? 'Richtig! Well done!' : 'Almost — try again next time',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: correct ? AppColors.correct : AppColors.incorrect,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(explanation,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/lesson_provider.dart';
import '../../providers/user_provider.dart';
import '../../data/models/lesson_model.dart';
import '../../data/services/gpt_service.dart';

class DynamicLessonScreen extends ConsumerStatefulWidget {
  final String topic;
  final String level;

  const DynamicLessonScreen({super.key, required this.topic, required this.level});

  @override
  ConsumerState<DynamicLessonScreen> createState() => _DynamicLessonScreenState();
}

class _DynamicLessonScreenState extends ConsumerState<DynamicLessonScreen> {
  final Map<int, int?> _answers = {};
  LessonClarification? _clarification;
  bool _isClarifying = false;

  Future<void> _handleClarify(List<LessonSegment> segments) async {
    final language = ref.read(selectedLanguageProvider);
    final currentExplanation = segments.map((s) => '${s.targetText} (${s.english})').join('\n');
    setState(() => _isClarifying = true);
    try {
      final result = await ref.read(gptServiceProvider).clarifyLesson(
            topic: widget.topic,
            level: widget.level,
            currentExplanation: currentExplanation,
            language: language,
          );
      setState(() {
        _clarification = result;
        _isClarifying = false;
      });
    } catch (e) {
      setState(() => _isClarifying = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oops! This service is temporarily unavailable. Please try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonFuture = ref.watch(dynamicLessonProvider(topic: widget.topic, level: widget.level));

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.level}: ${widget.topic}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: lessonFuture.when(
        data: (lesson) => _buildContent(lesson),
        loading: () => _buildShimmer(),
        error: (err, _) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('😕', style: TextStyle(fontSize: 48)),
                SizedBox(height: 16),
                Text(
                  'Oops! This service is temporarily unavailable. Please try again later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(LessonContent lesson) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Title & Explanation segments
          Text(lesson.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: primaryTextColor)),
          const SizedBox(height: 16),
          ...lesson.explanation.map((segment) => _buildExplanationSegment(segment, isDark, primaryTextColor, secondaryTextColor)),
          
          if (_clarification == null && !_isClarifying)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextButton.icon(
                onPressed: () => _handleClarify(lesson.explanation),
                icon: const Icon(Icons.lightbulb_outline, size: 20),
                label: const Text('Need more clarification?'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero),
              ),
            ),
          
          if (_isClarifying)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  const SizedBox(width: 12),
                  Text('Getting deeper explanation...', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: secondaryTextColor)),
                ],
              ),
            ),

          if (_clarification != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(isDark ? 0.1 : 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                      SizedBox(width: 8),
                      Text('Deeper Insight', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_clarification!.deeperExplanation, style: TextStyle(fontSize: 15, height: 1.5, color: primaryTextColor)),
                  if (_clarification!.newExamples.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Additional Examples:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: primaryTextColor)),
                    const SizedBox(height: 8),
                    ..._clarification!.newExamples.map((ex) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ${ex.targetText}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                              Text('  ${ex.english}', style: TextStyle(fontSize: 13, color: secondaryTextColor)),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),
          Text('Examples', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryTextColor)),
          const SizedBox(height: 12),
          ...lesson.examples.map((ex) => _buildExampleCard(ex, isDark, primaryTextColor, secondaryTextColor)),

          const SizedBox(height: 32),
          Text('Practice', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryTextColor)),
          const SizedBox(height: 12),
          ...lesson.practiceQuestions.asMap().entries.map((entry) => _buildPracticeQuestion(entry.key, entry.value, isDark, primaryTextColor, secondaryTextColor)),
          
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _answers.length == lesson.practiceQuestions.length ? () => Navigator.pop(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Complete Lesson', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildExplanationSegment(LessonSegment segment, bool isDark, Color primaryTextColor, Color secondaryTextColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            segment.targetText,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: primaryTextColor, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            segment.english,
            style: TextStyle(fontSize: 15, color: secondaryTextColor, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(LessonExample ex, bool isDark, Color primaryTextColor, Color secondaryTextColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.dividerDark : Colors.grey.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ex.targetText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
          Text(ex.english, style: TextStyle(fontSize: 14, color: secondaryTextColor)),
          if (ex.note != null) ...[
            const Divider(height: 20),
            Text(ex.note!, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.accent)),
          ],
        ],
      ),
    );
  }

  Widget _buildPracticeQuestion(int index, LessonPracticeQuestion q, bool isDark, Color primaryTextColor, Color secondaryTextColor) {
    final selectedIndex = _answers[index];
    final isAnswered = selectedIndex != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('${index + 1}. ${q.question}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryTextColor)),
        ),
        ...q.options.asMap().entries.map((opt) {
          final optionIndex = opt.key;
          final isSelected = selectedIndex == optionIndex;
          final isCorrect = optionIndex == q.correctIndex;
          
          Color bgColor = isDark ? AppColors.surfaceVariantDark : Colors.grey.withOpacity(0.05);
          Color borderColor = isDark ? AppColors.dividerDark : Colors.transparent;
          IconData? icon;
          Color? iconColor;

          if (isAnswered) {
            if (isCorrect) {
              bgColor = Colors.green.withOpacity(0.15);
              borderColor = Colors.green;
              if (isSelected) {
                icon = Icons.check_circle;
                iconColor = Colors.green;
              }
            } else if (isSelected) {
              bgColor = Colors.red.withOpacity(0.15);
              borderColor = Colors.red;
              icon = Icons.cancel;
              iconColor = Colors.red;
            }
          }

          return GestureDetector(
            onTap: isAnswered ? null : () => setState(() => _answers[index] = optionIndex),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      opt.value,
                      style: TextStyle(
                        fontWeight: isSelected || (isAnswered && isCorrect) ? FontWeight.bold : FontWeight.normal,
                        color: isAnswered && isCorrect ? Colors.green.shade400 : (isSelected ? Colors.red.shade400 : primaryTextColor),
                      ),
                    ),
                  ),
                  if (icon != null) Icon(icon, color: iconColor, size: 20),
                ],
              ),
            ),
          );
        }),
        if (isAnswered)
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.info.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    q.explanation,
                    style: const TextStyle(fontSize: 13, color: AppColors.info, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildShimmer() {
    return const Center(child: CircularProgressIndicator());
  }
}

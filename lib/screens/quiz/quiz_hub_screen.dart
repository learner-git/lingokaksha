import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';

class QuizHubScreen extends ConsumerWidget {
  const QuizHubScreen({super.key});

  void _showQuickQuizOptions(BuildContext context, String level) {
    final topicController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Quiz Mode',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Select how you want to test your $level skills.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            
            // Option 1: Random Level Quiz
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tileColor: AppColors.primary.withOpacity(0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              leading: const CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.shuffle, color: Colors.white),
              ),
              title: const Text('Random Level Quiz', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Covers general $level grammar & vocab'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.pop(context);
                context.push('/quiz/General-$level?level=$level');
              },
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            // Option 2: Custom Topic Quiz
            const Text(
              'Quiz on a Specific Topic',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: topicController,
              decoration: InputDecoration(
                hintText: 'e.g., Dative Prepositions, Food...',
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.topic_outlined),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  Navigator.pop(context);
                  context.push('/quiz/${val.trim()}?level=$level');
                }
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (topicController.text.trim().isNotEmpty) {
                    Navigator.pop(context);
                    context.push('/quiz/${topicController.text.trim()}?level=$level');
                  }
                },
                child: const Text('Start Topic Quiz'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExamPrepOptions(BuildContext context, String level) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exam Preparation',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Mock tests designed according to official $level standards.',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            _ExamOptionTile(
              title: 'Goethe-Zertifikat $level',
              subtitle: 'Focus on Reading & Grammar modules',
              onTap: () {
                Navigator.pop(context);
                context.push('/quiz/Goethe-$level-Mock-Test?level=$level');
              },
            ),
            const SizedBox(height: 12),
            _ExamOptionTile(
              title: 'TELC Deutsch $level',
              subtitle: 'Focus on Vocabulary & Structure',
              onTap: () {
                Navigator.pop(context);
                context.push('/quiz/Telc-$level-Mock-Test?level=$level');
              },
            ),
            const SizedBox(height: 12),
            _ExamOptionTile(
              title: 'ÖSD $level Standard',
              subtitle: 'Austrian German variants & usage',
              onTap: () {
                Navigator.pop(context);
                context.push('/quiz/OSD-$level-Mock-Test?level=$level');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedLevel = ref.watch(selectedLevelProvider) ?? 'A1';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Center'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ready to practice, Learner?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your preferred mode for Level $selectedLevel.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              _PracticeOptionCard(
                title: 'Quick Quiz',
                subtitle: 'Level-based or Custom Topic',
                icon: Icons.bolt_rounded,
                color: AppColors.warning,
                onTap: () => _showQuickQuizOptions(context, selectedLevel),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1),
              
              const SizedBox(height: 16),
              
              _PracticeOptionCard(
                title: 'Grammar Check',
                subtitle: 'AI-powered sentence validation',
                icon: Icons.auto_fix_high_rounded,
                color: AppColors.secondary,
                onTap: () => context.push('/chat'),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: 0.1),
              
              const SizedBox(height: 16),
              
              _PracticeOptionCard(
                title: 'Exam Preparation',
                subtitle: 'Official Mock Tests (Goethe/Telc)',
                icon: Icons.assignment_rounded,
                color: AppColors.info,
                onTap: () => _showExamPrepOptions(context, selectedLevel),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideX(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExamOptionTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: AppColors.info.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.info.withOpacity(0.1)),
      ),
      leading: const CircleAvatar(
        backgroundColor: AppColors.info,
        child: Icon(Icons.school_rounded, color: Colors.white, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    );
  }
}

class _PracticeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PracticeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color.withOpacity(0.3),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

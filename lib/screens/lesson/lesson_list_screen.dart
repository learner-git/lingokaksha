import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_extensions.dart';
import '../../providers/user_provider.dart';
import '../../data/repositories/curriculum_repository.dart';
import '../../data/models/lesson_model.dart';

class LessonListScreen extends ConsumerWidget {
  const LessonListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(selectedLevelProvider) ?? 'A1';
    final topics =
        ref.watch(curriculumRepositoryProvider).getTopicsByLevel(selectedLevel);
    final theme = Theme.of(context);

    final groupedTopics = <String, List<LessonTopic>>{};
    for (var topic in topics) {
      groupedTopics.putIfAbsent(topic.category, () => []).add(topic);
    }

    final categories = groupedTopics.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$selectedLevel Roadmap'),
        centerTitle: true,
      ),
      body: topics.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📚', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text('Coming Soon', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Content for $selectedLevel is under development.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: context.textSecondary)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: categories.length,
        itemBuilder: (context, categoryIndex) {
          final category = categories[categoryIndex];
          final categoryTopics = groupedTopics[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 12, left: 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      category.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 1.2,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ...categoryTopics
                  .map((topic) => _buildTopicCard(context, topic))
                  .toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, LessonTopic topic) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.dividerColor),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.auto_stories_rounded,
              color: AppColors.primary, size: 24),
        ),
        title: Text(
          topic.title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          topic.description,
          style: theme.textTheme.bodySmall,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: context.textSecondary,
          size: 16,
        ),
        onTap: () => context.push('/lesson/${topic.id}'),
      ),
    );
  }
}

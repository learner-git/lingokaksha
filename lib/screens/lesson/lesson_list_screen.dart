import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../data/repositories/curriculum_repository.dart';
import '../../data/models/lesson_model.dart';

class LessonListScreen extends ConsumerWidget {
  const LessonListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLevel = ref.watch(selectedLevelProvider) ?? 'A1';
    final topics = ref.watch(curriculumRepositoryProvider).getTopicsByLevel(selectedLevel);
    
    // Group topics by category
    final groupedTopics = <String, List<LessonTopic>>{};
    for (var topic in topics) {
      groupedTopics.putIfAbsent(topic.category, () => []).add(topic);
    }

    final categories = groupedTopics.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Slightly off-white background
      appBar: AppBar(
        title: Text('$selectedLevel Roadmap', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: categories.length,
        itemBuilder: (context, categoryIndex) {
          final category = categories[categoryIndex];
          final categoryTopics = groupedTopics[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🏷️ Category Header
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 12, left: 4),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // 📦 Topic Cards for this category
              ...categoryTopics.map((topic) => _buildTopicCard(context, topic)).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, LessonTopic topic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/lesson/${topic.id}?level=${topic.level}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon or Numbering
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_stories_rounded, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topic.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/constants/hive_keys.dart';
import '../data/models/lesson_model.dart';
import '../data/repositories/lesson_repository.dart';
import '../data/services/gpt_service.dart';
import 'user_provider.dart';

part 'lesson_provider.g.dart';

@riverpod
Future<LessonContent> dynamicLesson(DynamicLessonRef ref, {required String topic, required String level}) async {
  final gpt = ref.read(gptServiceProvider);
  final repo = ref.read(lessonRepositoryProvider);
  final language = ref.watch(selectedLanguageProvider);
  
  final box = Hive.box(HiveKeys.lessonCache);
  final cacheKey = 'dynamic_lesson_${language}_${level}_$topic';
  
  // 1. Try local Hive cache first (Fastest)
  final cachedLocal = box.get(cacheKey);
  if (cachedLocal != null) {
    try {
      return LessonContent.fromJson(jsonDecode(cachedLocal));
    } catch (e) {
      print('Error decoding cached lesson: $e');
    }
  }

  // 2. Try Firestore cache (Cost-saving)
  final cachedRemote = await repo.fetchCachedAiLesson(language, level, topic);
  if (cachedRemote != null) {
    // Save to local for next time
    await box.put(cacheKey, jsonEncode(cachedRemote.toJson()));
    return cachedRemote;
  }

  // 3. Generate from AI (Fallback)
  final lesson = await gpt.generateLesson(topic: topic, level: level, language: language);
  
  // Save to both caches
  await box.put(cacheKey, jsonEncode(lesson.toJson()));
  await repo.cacheAiLesson(language, level, topic, lesson);
  
  return lesson;
}

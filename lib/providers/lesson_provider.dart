import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/lesson_model.dart';
import '../data/services/gpt_service.dart';
import 'user_provider.dart';

part 'lesson_provider.g.dart';

@riverpod
Future<LessonContent> dynamicLesson(DynamicLessonRef ref, {required String topic, required String level}) async {
  final gpt = ref.read(gptServiceProvider);
  final language = ref.watch(selectedLanguageProvider);
  return gpt.generateLesson(topic: topic, level: level, language: language);
}

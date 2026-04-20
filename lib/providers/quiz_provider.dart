import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/models/quiz_model.dart';
import '../data/services/gpt_service.dart';
import 'user_provider.dart';

part 'quiz_provider.g.dart';

@riverpod
class QuizNotifier extends _$QuizNotifier {
  @override
  AsyncValue<QuizSession?> build() => const AsyncValue.data(null);

  Future<void> loadQuiz({
    required String topic,
    required String level,
    int count = 5,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final gptService = ref.read(gptServiceProvider);
      final language = ref.read(selectedLanguageProvider);
      final questions = await gptService.generateQuiz(
        topic: topic,
        level: level,
        count: count,
        language: language,
      );
      
      if (questions.isEmpty) {
        throw Exception("AI could not generate questions. Please try again.");
      }

      return QuizSession(
        id: const Uuid().v4(),
        questions: questions,
        topic: topic,
        level: level,
        userAnswers: List.filled(questions.length, null),
        startedAt: DateTime.now(),
      );
    });
  }

  void answerQuestion(int questionIndex, int answerIndex) {
    final session = state.value;
    if (session == null) return;

    final updated = List<int?>.from(session.userAnswers);
    updated[questionIndex] = answerIndex;

    state = AsyncValue.data(session.copyWith(
      userAnswers: updated,
      currentIndex: questionIndex,
    ));
  }

  void nextQuestion() {
    final session = state.value;
    if (session == null) return;
    if (session.currentIndex >= session.questions.length - 1) {
      completeQuiz();
      return;
    }
    state = AsyncValue.data(
      session.copyWith(currentIndex: session.currentIndex + 1),
    );
  }

  void completeQuiz() {
    final session = state.value;
    if (session == null) return;
    state = AsyncValue.data(session.copyWith(
      completed: true,
      completedAt: DateTime.now(),
    ));
  }

  void resetQuiz() {
    state = const AsyncValue.data(null);
  }
}

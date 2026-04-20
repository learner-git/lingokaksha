import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/activity_event.dart';
import '../data/models/lesson_model.dart';
import 'auth_provider.dart';
import 'user_provider.dart';

part 'session_provider.freezed.dart';
part 'session_provider.g.dart';

@freezed
class SessionState with _$SessionState {
  const factory SessionState({
    @Default(0) int sessionXp,
    @Default(0) int sessionMinutes,
    @Default(false) bool lessonCompleted,
    String? completedLessonId,
    @Default(0) int quizScore,
    @Default(0) int quizTotal,
    @Default([]) List<ActivityEvent> sessionEvents,
    DateTime? startedAt,
  }) = _SessionState;
}

@riverpod
class SessionNotifier extends _$SessionNotifier {
  @override
  SessionState build() => SessionState(startedAt: DateTime.now());

  void addXp(int points) {
    state = state.copyWith(sessionXp: state.sessionXp + points);
  }

  void recordLessonComplete(String lessonId, int score) {
    state = state.copyWith(
      lessonCompleted: true,
      completedLessonId: lessonId,
      quizScore: score,
    );
    _addEvent(ActivityEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'lesson',
      description: 'Completed lesson $lessonId',
      xpEarned: 20,
      timestamp: DateTime.now(),
    ));

    // 🔥 Sync to Firestore
    _syncToFirestore(xp: 20, lessonId: lessonId);
  }

  void recordQuizResult(int correct, int total) {
    final xp = correct * 5;
    state = state.copyWith(quizScore: correct, quizTotal: total);
    addXp(xp);
    _addEvent(ActivityEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'quiz',
      description: 'Quiz: $correct/$total correct',
      xpEarned: xp,
      timestamp: DateTime.now(),
    ));

    // 🔥 Sync to Firestore
    _syncToFirestore(xp: xp);
  }

  void recordChatMessage() {
    addXp(1);
    _syncToFirestore(xp: 1);
  }

  /// Internal helper to persist progress to the language-specific subcollection
  void _syncToFirestore({required int xp, String? lessonId}) {
    final language = ref.read(selectedLanguageProvider);
    ref.read(authNotifierProvider.notifier).updateProgress(
          xp: xp,
          language: language,
          lessonId: lessonId,
        );
  }

  void _addEvent(ActivityEvent event) {
    state = state.copyWith(
      sessionEvents: [...state.sessionEvents, event],
    );
  }

  void resetSession() {
    state = SessionState(startedAt: DateTime.now());
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

/// Helper to handle the bilingual map or strings from the backend
class BilingualStringConverter implements JsonConverter<String, dynamic> {
  const BilingualStringConverter();

  @override
  String fromJson(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) {
      if (value.containsKey('de') || value.containsKey('en')) {
        final de = value['de']?.toString() ?? '';
        final en = value['en']?.toString() ?? '';
        if (de.isNotEmpty && en.isNotEmpty) return "$de\n\n$en";
        return de.isNotEmpty ? de : en;
      }
      return value.values.map((e) => e.toString()).join('\n\n');
    }
    return value.toString();
  }

  @override
  dynamic toJson(String object) => object;
}

/// Helper to handle cases where correctIndex might be a String or Int
class FlexibleIntConverter implements JsonConverter<int, dynamic> {
  const FlexibleIntConverter();

  @override
  int fromJson(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  @override
  dynamic toJson(int object) => object;
}

@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    @BilingualStringConverter() required String question,
    required List<String> options,
    @FlexibleIntConverter() required int correctIndex,
    @BilingualStringConverter() required String explanation,
    String? hint,
    String? topic,
    String? level,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => _$QuizQuestionFromJson(json);
}

@freezed
class QuizSession with _$QuizSession {
  const factory QuizSession({
    required String id,
    required List<QuizQuestion> questions,
    required String topic,
    required String level,
    @Default([]) List<int?> userAnswers,
    @Default(0) int currentIndex,
    @Default(false) bool completed,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _QuizSession;

  factory QuizSession.fromJson(Map<String, dynamic> json) => _$QuizSessionFromJson(json);

  const QuizSession._();

  int get score {
    int correct = 0;
    for (int i = 0; i < userAnswers.length; i++) {
      if (i < questions.length && userAnswers[i] == questions[i].correctIndex) {
        correct++;
      }
    }
    return correct;
  }

  double get accuracy =>
      questions.isEmpty ? 0 : score / questions.length;

  int get xpEarned => score * 5;
}

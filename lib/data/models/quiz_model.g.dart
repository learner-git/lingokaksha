// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      id: json['id'] as String,
      question: const BilingualStringConverter().fromJson(json['question']),
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      correctIndex: const FlexibleIntConverter().fromJson(json['correctIndex']),
      explanation:
          const BilingualStringConverter().fromJson(json['explanation']),
      hint: json['hint'] as String?,
      topic: json['topic'] as String?,
      level: json['level'] as String?,
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': const BilingualStringConverter().toJson(instance.question),
      'options': instance.options,
      'correctIndex':
          const FlexibleIntConverter().toJson(instance.correctIndex),
      'explanation':
          const BilingualStringConverter().toJson(instance.explanation),
      'hint': instance.hint,
      'topic': instance.topic,
      'level': instance.level,
    };

_$QuizSessionImpl _$$QuizSessionImplFromJson(Map<String, dynamic> json) =>
    _$QuizSessionImpl(
      id: json['id'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      topic: json['topic'] as String,
      level: json['level'] as String,
      userAnswers: (json['userAnswers'] as List<dynamic>?)
              ?.map((e) => (e as num?)?.toInt())
              .toList() ??
          const [],
      currentIndex: (json['currentIndex'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$QuizSessionImplToJson(_$QuizSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questions': instance.questions,
      'topic': instance.topic,
      'level': instance.level,
      'userAnswers': instance.userAnswers,
      'currentIndex': instance.currentIndex,
      'completed': instance.completed,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

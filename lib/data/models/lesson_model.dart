import 'package:cloud_firestore/cloud_firestore.dart';

class LessonContent {
  final String title;
  final List<LessonSegment> explanation;
  final List<LessonExample> examples;
  final List<LessonPracticeQuestion> practiceQuestions;

  LessonContent({
    required this.title,
    required this.explanation,
    required this.examples,
    required this.practiceQuestions,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) {
    return LessonContent(
      title: json['title'] ?? '',
      explanation: (json['explanation'] as List? ?? [])
          .map((e) => LessonSegment.fromJson(e))
          .toList(),
      examples: (json['examples'] as List? ?? [])
          .map((e) => LessonExample.fromJson(e))
          .toList(),
      practiceQuestions: (json['practiceQuestions'] as List? ?? [])
          .map((q) => LessonPracticeQuestion.fromJson(q))
          .toList(),
    );
  }
}

class LessonSegment {
  final String targetText;
  final String english;

  LessonSegment({
    required this.targetText,
    required this.english,
  });

  factory LessonSegment.fromJson(Map<String, dynamic> json) {
    return LessonSegment(
      targetText: json['targetText'] ?? json['german'] ?? '',
      english: json['english'] ?? '',
    );
  }
}

class LessonExample {
  final String targetText;
  final String english;
  final String? note;

  LessonExample({
    required this.targetText,
    required this.english,
    this.note,
  });

  factory LessonExample.fromJson(Map<String, dynamic> json) {
    return LessonExample(
      targetText: json['targetText'] ?? json['german'] ?? '',
      english: json['english'] ?? '',
      note: json['note'],
    );
  }
}

class LessonPracticeQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  LessonPracticeQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory LessonPracticeQuestion.fromJson(Map<String, dynamic> json) {
    // Robustly handle index potentially being a String or Number from AI
    int cIndex = 0;
    if (json['correctIndex'] is int) {
      cIndex = json['correctIndex'];
    } else if (json['correctIndex'] is String) {
      cIndex = int.tryParse(json['correctIndex']) ?? 0;
    }

    return LessonPracticeQuestion(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: cIndex,
      explanation: json['explanation'] ?? '',
    );
  }
}

class LessonClarification {
  final String deeperExplanation;
  final List<LessonExample> newExamples;

  LessonClarification({
    required this.deeperExplanation,
    required this.newExamples,
  });

  factory LessonClarification.fromJson(Map<String, dynamic> json) {
    return LessonClarification(
      deeperExplanation: json['deeperExplanation'] ?? '',
      newExamples: (json['newExamples'] as List? ?? [])
          .map((e) => LessonExample.fromJson(e))
          .toList(),
    );
  }
}

class LessonTopic {
  final String id;
  final String title;
  final String description;
  final String level;
  final String category;

  LessonTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.category,
  });
}

class LessonModel {
  final String id;
  final String title;
  final String unit;
  final String level;
  final int order;
  final int estimatedMinutes;
  final List<Map<String, dynamic>> steps;
  final List<String> vocabulary;
  final List<String> grammarPoints;

  const LessonModel({
    required this.id,
    required this.title,
    required this.unit,
    required this.level,
    required this.order,
    required this.estimatedMinutes,
    required this.steps,
    required this.vocabulary,
    required this.grammarPoints,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      level: json['level'] as String? ?? 'A1',
      order: json['order'] as int? ?? 0,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 10,
      steps: List<Map<String, dynamic>>.from(json['steps'] ?? []),
      vocabulary: List<String>.from(json['vocabulary'] ?? []),
      grammarPoints: List<String>.from(json['grammarPoints'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'unit': unit,
        'level': level,
        'order': order,
        'estimatedMinutes': estimatedMinutes,
        'steps': steps,
        'vocabulary': vocabulary,
        'grammarPoints': grammarPoints,
      };
}

class LessonProgress {
  final String lessonId;
  final String userId;
  final bool isCompleted;
  final int bestScore;
  final DateTime lastStudied;

  LessonProgress({
    required this.lessonId,
    required this.userId,
    required this.isCompleted,
    required this.bestScore,
    required this.lastStudied,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lessonId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      bestScore: json['bestScore'] as int? ?? 0,
      lastStudied: json['lastStudied'] != null
          ? (json['lastStudied'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

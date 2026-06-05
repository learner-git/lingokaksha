import 'package:hive/hive.dart';

part 'vocab_card.g.dart';

@HiveType(typeId: 0)
class VocabCard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String targetText;

  @HiveField(2)
  final String english;

  @HiveField(3)
  final String? exampleSentence;

  @HiveField(4)
  final String? audioUrl;

  @HiveField(5)
  String level; // A1, A2, B1, B2

  @HiveField(6)
  double easeFactor; // SM-2 ease factor (default 2.5)

  @HiveField(7)
  int interval; // days until next review

  @HiveField(8)
  int repetitions; // number of successful reviews

  @HiveField(9)
  DateTime nextReview;

  @HiveField(10)
  DateTime addedAt;

  @HiveField(11)
  String? category; // e.g. 'greetings', 'verbs', 'nouns'

  @HiveField(12)
  bool isFavorite;

  @HiveField(13)
  final String? examplePresent;

  @HiveField(14)
  final String? examplePast;

  @HiveField(15)
  final String? exampleFuture;

  @HiveField(16)
  final String? translationPresent;

  @HiveField(17)
  final String? translationPast;

  @HiveField(18)
  final String? translationFuture;

  VocabCard({
    required this.id,
    required this.targetText,
    required this.english,
    this.exampleSentence,
    this.audioUrl,
    this.level = 'A1',
    this.easeFactor = 2.5,
    this.interval = 1,
    this.repetitions = 0,
    DateTime? nextReview,
    DateTime? addedAt,
    this.category,
    this.isFavorite = false,
    this.examplePresent,
    this.examplePast,
    this.exampleFuture,
    this.translationPresent,
    this.translationPast,
    this.translationFuture,
  })  : nextReview = nextReview ?? DateTime.now(),
        addedAt = addedAt ?? DateTime.now();

  bool get isDue => DateTime.now().isAfter(nextReview);

  VocabCard reviewed(int quality) {
    // SM-2 algorithm
    double ef = easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    if (ef < 1.3) ef = 1.3;

    int newInterval;
    int newReps;

    if (quality < 3) {
      newInterval = 1;
      newReps = 0;
    } else if (repetitions == 0) {
      newInterval = 1;
      newReps = 1;
    } else if (repetitions == 1) {
      newInterval = 6;
      newReps = 2;
    } else {
      newInterval = (interval * ef).round();
      newReps = repetitions + 1;
    }

    return VocabCard(
      id: id,
      targetText: targetText,
      english: english,
      exampleSentence: exampleSentence,
      audioUrl: audioUrl,
      level: level,
      easeFactor: ef,
      interval: newInterval,
      repetitions: newReps,
      nextReview: DateTime.now().add(Duration(days: newInterval)),
      addedAt: addedAt,
      category: category,
      isFavorite: isFavorite,
      examplePresent: examplePresent,
      examplePast: examplePast,
      exampleFuture: exampleFuture,
      translationPresent: translationPresent,
      translationPast: translationPast,
      translationFuture: translationFuture,
    );
  }

  VocabCard copyWith({
    String? targetText,
    String? english,
    String? exampleSentence,
    String? level,
    bool? isFavorite,
    double? easeFactor,
    int? interval,
    int? repetitions,
    DateTime? nextReview,
    String? category,
    String? examplePresent,
    String? examplePast,
    String? exampleFuture,
    String? translationPresent,
    String? translationPast,
    String? translationFuture,
  }) {
    return VocabCard(
      id: id,
      targetText: targetText ?? this.targetText,
      english: english ?? this.english,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      audioUrl: audioUrl,
      level: level ?? this.level,
      easeFactor: easeFactor ?? this.easeFactor,
      interval: interval ?? this.interval,
      repetitions: repetitions ?? this.repetitions,
      nextReview: nextReview ?? this.nextReview,
      addedAt: addedAt,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      examplePresent: examplePresent ?? this.examplePresent,
      examplePast: examplePast ?? this.examplePast,
      exampleFuture: exampleFuture ?? this.exampleFuture,
      translationPresent: translationPresent ?? this.translationPresent,
      translationPast: translationPast ?? this.translationPast,
      translationFuture: translationFuture ?? this.translationFuture,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'targetText': targetText,
        'english': english,
        'exampleSentence': exampleSentence,
        'level': level,
        'easeFactor': easeFactor,
        'interval': interval,
        'repetitions': repetitions,
        'nextReview': nextReview.toIso8601String(),
        'addedAt': addedAt.toIso8601String(),
        'category': category,
        'isFavorite': isFavorite,
        'examplePresent': examplePresent,
        'examplePast': examplePast,
        'exampleFuture': exampleFuture,
        'translationPresent': translationPresent,
        'translationPast': translationPast,
        'translationFuture': translationFuture,
      };
}

import 'package:hive/hive.dart';

part 'activity_event.g.dart';

@HiveType(typeId: 1)
class ActivityEvent extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type; // 'lesson', 'quiz', 'chat', 'vocab'

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int xpEarned;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final Map<String, dynamic> metadata;

  ActivityEvent({
    required this.id,
    required this.type,
    required this.description,
    required this.xpEarned,
    required this.timestamp,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'description': description,
        'xpEarned': xpEarned,
        'timestamp': timestamp.toIso8601String(),
        'metadata': metadata,
      };
}

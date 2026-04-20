import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message.dart';

part 'chat_session.freezed.dart';
part 'chat_session.g.dart';

@freezed
class ChatSession with _$ChatSession {
  const factory ChatSession({
    required String id,
    required String topic,
    required String level,
    required List<ChatMessage> messages,
    @Default(0.0) double progress,
    required DateTime lastInteraction,
    @Default(false) bool isCompleted,
  }) = _ChatSession;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
}

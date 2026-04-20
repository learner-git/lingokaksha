import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

enum MessageRole { user, assistant, system }
enum MessageStatus { sending, sent, error }

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required MessageRole role,
    required String content,
    @Default(MessageStatus.sent) MessageStatus status,
    @Default(false) bool isLoading,
    String? correction,       // GPT grammar correction
    String? translation,      // German → English
    DateTime? timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  factory ChatMessage.user(String content) => ChatMessage(
        id: const Uuid().v4(),
        role: MessageRole.user,
        content: content,
        status: MessageStatus.sending,
        timestamp: DateTime.now(),
      );

  factory ChatMessage.assistant(String content) => ChatMessage(
        id: const Uuid().v4(),
        role: MessageRole.assistant,
        content: content,
        timestamp: DateTime.now(),
      );

  factory ChatMessage.loading() => ChatMessage(
        id: const Uuid().v4(),
        role: MessageRole.assistant,
        content: '',
        isLoading: true,
        timestamp: DateTime.now(),
      );
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatSessionImpl _$$ChatSessionImplFromJson(Map<String, dynamic> json) =>
    _$ChatSessionImpl(
      id: json['id'] as String,
      topic: json['topic'] as String,
      level: json['level'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      lastInteraction: DateTime.parse(json['lastInteraction'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatSessionImplToJson(_$ChatSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'level': instance.level,
      'messages': instance.messages,
      'progress': instance.progress,
      'lastInteraction': instance.lastInteraction.toIso8601String(),
      'isCompleted': instance.isCompleted,
    };

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/hive_keys.dart';
import '../models/chat_message.dart';

class ChatRepository {
  final Box<List> _chatBox = Hive.box<List>(HiveKeys.chatCache);

  /// Load messages for a specific session (or general)
  List<ChatMessage> getMessages(String sessionId) {
    final rawData = _chatBox.get(sessionId);
    if (rawData == null) return [];
    
    return rawData.map((e) {
      final Map<String, dynamic> json = Map<String, dynamic>.from(e as Map);
      return ChatMessage.fromJson(json);
    }).toList();
  }

  /// Save message history
  Future<void> saveMessages(String sessionId, List<ChatMessage> messages) async {
    final data = messages.map((m) => m.toJson()).toList();
    await _chatBox.put(sessionId, data);
  }

  /// Update progress for a session
  Future<void> updateProgress(String sessionId, double progress) async {
    final box = Hive.box(HiveKeys.userPrefs);
    await box.put('progress_$sessionId', progress);
  }

  double getProgress(String sessionId) {
    final box = Hive.box(HiveKeys.userPrefs);
    return box.get('progress_$sessionId', defaultValue: 0.0) as double;
  }

  Future<void> clearHistory(String sessionId) async {
    await _chatBox.delete(sessionId);
  }
}

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/hive_keys.dart';

part 'hive_store.g.dart';

@riverpod
HiveStore hiveStore(HiveStoreRef ref) => HiveStore();

class HiveStore {
  // ── User preferences ──────────────────────────────────────────────────────

  Box get _prefs => Hive.box(HiveKeys.userPrefs);

  String get userLevel => _prefs.get('level', defaultValue: 'A1') as String;
  set userLevel(String v) => _prefs.put('level', v);

  int get dailyGoalMinutes =>
      _prefs.get('dailyGoal', defaultValue: 10) as int;
  set dailyGoalMinutes(int v) => _prefs.put('dailyGoal', v);

  bool get notificationsEnabled =>
      _prefs.get('notifications', defaultValue: true) as bool;
  set notificationsEnabled(bool v) => _prefs.put('notifications', v);

  bool get darkMode => _prefs.get('darkMode', defaultValue: false) as bool;
  set darkMode(bool v) => _prefs.put('darkMode', v);

  String? get lastLessonId => _prefs.get('lastLesson') as String?;
  set lastLessonId(String? v) =>
      v != null ? _prefs.put('lastLesson', v) : _prefs.delete('lastLesson');

  // ── Chat cache (last N messages per topic) ─────────────────────────────

  Box get _chat => Hive.box(HiveKeys.chatCache);

  void saveChatSnippet(String topic, List<Map<String, String>> messages) {
    _chat.put('chat_$topic', jsonEncode(messages));
  }

  List<Map<String, String>> getChatSnippet(String topic) {
    final raw = _chat.get('chat_$topic') as String?;
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Map<String, String>.from(e as Map)).toList();
  }

  void clearChatCache() => _chat.clear();

  // ── Generic TTL cache ─────────────────────────────────────────────────────

  Box get _lessonCache => Hive.box(HiveKeys.lessonCache);

  Future<void> setCached(String key, String json, {Duration? ttl}) async {
    final expires = ttl != null
        ? DateTime.now().add(ttl).millisecondsSinceEpoch
        : null;
    await _lessonCache.put(key, json);
    if (expires != null) await _lessonCache.put('${key}_exp', expires);
  }

  String? getCached(String key) {
    final exp = _lessonCache.get('${key}_exp') as int?;
    if (exp != null && DateTime.now().millisecondsSinceEpoch > exp) {
      _lessonCache.delete(key);
      _lessonCache.delete('${key}_exp');
      return null;
    }
    return _lessonCache.get(key) as String?;
  }

  Future<void> clearAll() async {
    await _prefs.clear();
    await _chat.clear();
    await _lessonCache.clear();
  }
}

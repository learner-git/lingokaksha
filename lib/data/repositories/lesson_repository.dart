import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/hive_keys.dart';
import '../models/lesson_model.dart';

part 'lesson_repository.g.dart';

@riverpod
LessonRepository lessonRepository(LessonRepositoryRef ref) =>
    LessonRepository();

class LessonRepository {
  final _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: AppConstants.firestoreDatabaseId,
  );
  late final Box _cache = Hive.box(HiveKeys.lessonCache);

  CollectionReference<Map<String, dynamic>> _getLessons(String language) =>
      _db.collection('languages').doc(language).collection('curriculum');

  // ── Fetch lessons by level with Hive cache ────────────────────────────────

  Future<List<LessonModel>> fetchLessonsForLevel(String level, {String? language}) async {
    final lang = language ?? AppConstants.defaultLanguage;
    final cacheKey = 'lessons_${lang}_$level';
    final cachedAt = _cache.get('${cacheKey}_ts') as int?;
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheTtl =
        AppConstants.lessonCacheDays * 24 * 60 * 60 * 1000;

    // Return cache if fresh
    if (cachedAt != null && now - cachedAt < cacheTtl) {
      final raw = _cache.get(cacheKey) as String?;
      if (raw != null) {
        final list = jsonDecode(raw) as List;
        return list
            .map((j) => LessonModel.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      }
    }

    // Fetch from Firestore
    try {
      final snap = await _getLessons(lang)
          .where('level', isEqualTo: level)
          .orderBy('order')
          .get();

      final lessons = snap.docs
          .map((d) => LessonModel.fromJson({...d.data(), 'id': d.id}))
          .toList();

      // Cache the result
      await _cache.put(cacheKey, jsonEncode(lessons.map((l) => l.toJson()).toList()));
      await _cache.put('${cacheKey}_ts', now);

      return lessons;
    } catch (e) {
      // Fallback to stale cache
      final raw = _cache.get(cacheKey) as String?;
      if (raw != null) {
        final list = jsonDecode(raw) as List;
        return list
            .map((j) => LessonModel.fromJson(Map<String, dynamic>.from(j)))
            .toList();
      }
      // Return static fallback data if completely offline
      return _staticFallbackLessons(level);
    }
  }

  // ── Fetch single lesson ───────────────────────────────────────────────────

  Future<LessonModel?> fetchLesson(String lessonId, {String? language}) async {
    final lang = language ?? AppConstants.defaultLanguage;
    final cacheKey = 'lesson_${lang}_$lessonId';
    final raw = _cache.get(cacheKey) as String?;

    if (raw != null) {
      return LessonModel.fromJson(
          Map<String, dynamic>.from(jsonDecode(raw)));
    }

    try {
      final doc = await _getLessons(lang).doc(lessonId).get();
      if (!doc.exists) return null;
      final lesson = LessonModel.fromJson({...doc.data()!, 'id': doc.id});
      await _cache.put(cacheKey, jsonEncode(lesson.toJson()));
      return lesson;
    } catch (_) {
      return null;
    }
  }

  // ── Fetch user progress ───────────────────────────────────────────────────

  Future<LessonProgress?> fetchProgress(
      String userId, String lessonId) async {
    try {
      final doc = await _db
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(lessonId)
          .get();
      if (!doc.exists) return null;
      return LessonProgress.fromJson({...doc.data()!, 'lessonId': lessonId, 'userId': userId});
    } catch (_) {
      return null;
    }
  }

  // ── Recommend next lesson ─────────────────────────────────────────────────

  Future<LessonModel?> recommendNext({
    required String level,
    required List<String> completedIds,
  }) async {
    final all = await fetchLessonsForLevel(level);
    return all.firstWhere(
      (l) => !completedIds.contains(l.id),
      orElse: () => all.first,
    );
  }

  // ── AI Lesson Cache ───────────────────────────────────────────────────────

  Future<LessonContent?> fetchCachedAiLesson(String language, String level, String topic) async {
    final lang = language.toLowerCase().trim();
    final docId = _getAiLessonDocId(level, topic);
    try {
      final doc = await _db
          .collection('languages')
          .doc(lang)
          .collection('ai_cache')
          .doc(docId)
          .get();
      if (doc.exists) {
        return LessonContent.fromJson(doc.data()!);
      }
    } catch (e) {
      // Permission denied is common if rules aren't set up for this new collection
      // We log it as a debug message instead of an error to avoid alarming the developer
      if (e.toString().contains('permission-denied')) {
        print('AI Cache: Firestore permission denied (check security rules). Falling back to AI.');
      } else {
        print('AI Cache: Error fetching from Firestore: $e');
      }
    }
    return null;
  }

  Future<void> cacheAiLesson(String language, String level, String topic, LessonContent content) async {
    final lang = language.toLowerCase().trim();
    final docId = _getAiLessonDocId(level, topic);
    try {
      await _db
          .collection('languages')
          .doc(lang)
          .collection('ai_cache')
          .doc(docId)
          .set(content.toJson());
    } catch (e) {
      if (!e.toString().contains('permission-denied')) {
        print('AI Cache: Error saving to Firestore: $e');
      }
    }
  }

  String _getAiLessonDocId(String level, String topic) {
    final normalizedTopic = topic.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    return '${level.toLowerCase()}_$normalizedTopic';
  }

  // ── Static fallback (offline dev / testing) ───────────────────────────────

  List<LessonModel> _staticFallbackLessons(String level) {
    if (level == 'A1') {
      return [
        const LessonModel(
          id: 'a1-intro',
          title: 'Welcome to German',
          unit: 'Unit 1',
          level: 'A1',
          order: 1,
          estimatedMinutes: 5,
          steps: [],
          vocabulary: ['hallo', 'danke'],
          grammarPoints: ['Basics'],
        ),
      ];
    }
    if (level == 'B1') {
      return [
        const LessonModel(
          id: 'b1-past-tense',
          title: 'Mastering the Past',
          unit: 'Unit 1',
          level: 'B1',
          order: 1,
          estimatedMinutes: 15,
          steps: [],
          vocabulary: ['war', 'hatte'],
          grammarPoints: ['Präteritum'],
        ),
      ];
    }
    if (level == 'B2') {
      return [
        const LessonModel(
          id: 'b2-complex-sentences',
          title: 'Complex Structures',
          unit: 'Unit 1',
          level: 'B2',
          order: 1,
          estimatedMinutes: 20,
          steps: [],
          vocabulary: ['obwohl', 'trotzdem'],
          grammarPoints: ['Subordinate clauses'],
        ),
      ];
    }
    if (level != 'A2') return [];
    return [
      const LessonModel(
        id: 'a2-unit4-dativ-1',
        title: 'Der Dativ — Indirect Objects',
        unit: 'Unit 4',
        level: 'A2',
        order: 1,
        estimatedMinutes: 12,
        steps: [],
        vocabulary: ['dem', 'der', 'Dativ', 'indirektes Objekt'],
        grammarPoints: ['Dative case', 'Dative prepositions'],
      ),
      const LessonModel(
        id: 'a2-unit4-dativ-2',
        title: 'Dative Prepositions',
        unit: 'Unit 4',
        level: 'A2',
        order: 2,
        estimatedMinutes: 10,
        steps: [],
        vocabulary: ['aus', 'bei', 'mit', 'nach', 'seit', 'von', 'zu'],
        grammarPoints: ['Dative prepositions list', 'Mnemonic'],
      ),
    ];
  }
}

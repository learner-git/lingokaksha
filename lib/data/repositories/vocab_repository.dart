import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/hive_keys.dart';
import '../models/vocab_card.dart';

part 'vocab_repository.g.dart';

@riverpod
VocabRepository vocabRepository(VocabRepositoryRef ref) => VocabRepository();

class VocabRepository {
  Box<Map> get _box => Hive.box<Map>(HiveKeys.vocabulary);

  // ── CRUD ─────────────────────────────────────────────────────────────────

  Future<void> addCard(VocabCard card) async {
    await _box.put(card.id, card.toJson());
  }

  Future<void> addCards(List<VocabCard> cards) async {
    final map = {for (final c in cards) c.id: c.toJson()};
    await _box.putAll(map);
  }

  Future<void> deleteCard(String id) async {
    await _box.delete(id);
  }

  List<VocabCard> getAllCards() {
    return _box.values
        .map((v) => VocabCard(
              id: v['id'] as String,
              targetText: (v['targetText'] ?? v['german']) as String,
              english: v['english'] as String,
              exampleSentence: v['exampleSentence'] as String?,
              level: v['level'] as String? ?? 'A1',
              easeFactor: (v['easeFactor'] as num?)?.toDouble() ?? 2.5,
              interval: v['interval'] as int? ?? 1,
              repetitions: v['repetitions'] as int? ?? 0,
              nextReview: v['nextReview'] != null
                  ? DateTime.parse(v['nextReview'] as String)
                  : DateTime.now(),
              addedAt: v['addedAt'] != null
                  ? DateTime.parse(v['addedAt'] as String)
                  : DateTime.now(),
              category: v['category'] as String?,
              isFavorite: v['isFavorite'] as bool? ?? false,
            ))
        .toList();
  }

  // ── SM-2 review ───────────────────────────────────────────────────────────

  Future<VocabCard> reviewCard(String id, int quality) async {
    final raw = _box.get(id);
    if (raw == null) throw Exception('Card $id not found');

    final card = VocabCard(
      id: raw['id'] as String,
      targetText: (raw['targetText'] ?? raw['german']) as String,
      english: raw['english'] as String,
      exampleSentence: raw['exampleSentence'] as String?,
      level: raw['level'] as String? ?? 'A1',
      easeFactor: (raw['easeFactor'] as num?)?.toDouble() ?? 2.5,
      interval: raw['interval'] as int? ?? 1,
      repetitions: raw['repetitions'] as int? ?? 0,
      nextReview: raw['nextReview'] != null
          ? DateTime.parse(raw['nextReview'] as String)
          : DateTime.now(),
      category: raw['category'] as String?,
      isFavorite: raw['isFavorite'] as bool? ?? false,
    );

    final updated = card.reviewed(quality);
    await _box.put(id, updated.toJson());
    return updated;
  }

  // ── Due cards (SM-2 scheduler) ────────────────────────────────────────────

  List<VocabCard> getDueCards({
    int limit = 20, 
    String? currentLevel, 
    String? targetLevel,
    String? language,
  }) {
    final now = DateTime.now();
    var all = getAllCards();

    // Filter by level if provided
    if (currentLevel != null && targetLevel != null) {
      final levels = _getLevelRange(currentLevel, targetLevel);
      all = all.where((c) => levels.contains(c.level)).toList();
    }

    // Filter by language if provided (assuming language is stored in category for now or we just use general)
    if (language != null && language != 'german') {
       all = all.where((c) => c.category?.toLowerCase() == language.toLowerCase()).toList();
    }
    
    // 1. Get cards that are strictly due
    final due = all
        .where((c) => c.nextReview.isBefore(now))
        .toList()
      ..sort((a, b) => a.nextReview.compareTo(b.nextReview));
      
    if (due.length >= limit) return due.take(limit).toList();

    // 2. If not enough due, add "New" cards (never reviewed)
    final newCards = all
        .where((c) => c.repetitions == 0 && !due.any((d) => d.id == c.id))
        .toList();
    
    final combined = [...due, ...newCards];
    return combined.take(limit).toList();
  }

  List<String> _getLevelRange(String start, String end) {
    const allLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
    final startIndex = allLevels.indexOf(start);
    final endIndex = allLevels.indexOf(end);
    if (startIndex == -1 || endIndex == -1 || startIndex > endIndex) {
      return [start];
    }
    return allLevels.sublist(startIndex, endIndex + 1);
  }

  // ── Stats ─────────────────────────────────────────────────────────────────

  int get totalCards => _box.length;

  int get dueCount => getDueCards().length;

  Map<String, int> get cardsByLevel {
    final all = getAllCards();
    final map = <String, int>{};
    for (final c in all) {
      map[c.level] = (map[c.level] ?? 0) + 1;
    }
    return map;
  }

  double get averageEaseFactor {
    final all = getAllCards();
    if (all.isEmpty) return 2.5;
    return all.map((c) => c.easeFactor).reduce((a, b) => a + b) / all.length;
  }

  Future<void> toggleFavorite(String id) async {
    final raw = _box.get(id);
    if (raw == null) return;
    final isFav = raw['isFavorite'] as bool? ?? false;
    raw['isFavorite'] = !isFav;
    await _box.put(id, raw);
  }

  Future<void> updateCard(VocabCard card) async {
    await _box.put(card.id, card.toJson());
  }

  List<VocabCard> getFavoriteCards() {
    return getAllCards().where((c) => c.isFavorite).toList();
  }

  List<String> getUniqueCategories() {
    final all = getAllCards();
    final categories = all
        .map((c) => c.category)
        .where((cat) => cat != null && cat.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  List<VocabCard> getCardsByCategory(String category) {
    return getAllCards().where((c) => c.category == category).toList();
  }

  // ── Seed sample vocab ────────────────────────────────────────────────────

  Future<void> seedSampleVocab() async {
    if (_box.isNotEmpty) return; // Only seed once
    
    try {
      final String response = await rootBundle.loadString('assets/data/vocab_list.json');
      final List<dynamic> data = jsonDecode(response);
      
      const uuid = Uuid();
      final List<VocabCard> cards = data.map((item) {
        // Handle both old 'german' and new 'targetText' format in JSON
        final targetText = (item['targetText'] ?? item['german']) as String;
        
        // Determine category (language) if not explicitly set
        // If 'german' key exists, it's a german card
        String? category = item['category'] as String?;
        if (category == null && item.containsKey('german')) {
          category = 'german';
        }

        return VocabCard(
          id: uuid.v4(),
          targetText: targetText,
          english: item['english'] as String,
          level: item['level'] as String? ?? 'A1',
          category: category,
          exampleSentence: item['example'] as String?,
        );
      }).toList();
      
      await addCards(cards);
    } catch (e) {
      print('Error seeding vocab: $e');
      // Fallback to minimal hardcoded list if JSON fails
      await _seedFallback();
    }
  }

  Future<void> _seedFallback() async {
    const uuid = Uuid();
    final samples = [
      VocabCard(id: uuid.v4(), targetText: 'der Hund', english: 'the dog', level: 'A1', category: 'german'),
      VocabCard(id: uuid.v4(), targetText: 'die Katze', english: 'the cat', level: 'A1', category: 'german'),
    ];
    await addCards(samples);
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/vocab_card.dart';
import '../data/repositories/vocab_repository.dart';
import 'user_provider.dart';

part 'vocab_provider.g.dart';

// ── Due cards for review session ────────────────────────────────────────────

@riverpod
class VocabReviewNotifier extends _$VocabReviewNotifier {
  @override
  List<VocabCard> build() {
    final repo = ref.read(vocabRepositoryProvider);
    // Watch the reactive local level and language
    final level = (ref.watch(selectedLevelProvider) ?? 'A1').toUpperCase().trim();
    final language = ref.watch(selectedLanguageProvider).toLowerCase().trim();
    
    return repo.getDueCards(
      limit: 20, 
      currentLevel: level, 
      targetLevel: level,
      language: language,
    );
  }

  Future<void> reviewCard(String id, int quality) async {
    final repo = ref.read(vocabRepositoryProvider);
    await repo.reviewCard(id, quality);
    // Remove reviewed card from session queue
    state = state.where((c) => c.id != id).toList();
  }

  Future<void> refreshDue() async {
    final repo = ref.read(vocabRepositoryProvider);
    await repo.seedSampleVocab(); // Ensure seeded
    final level = (ref.read(selectedLevelProvider) ?? 'A1').toUpperCase();
    final language = ref.read(selectedLanguageProvider).toLowerCase().trim();

    state = repo.getDueCards(
      limit: 20,
      currentLevel: level,
      targetLevel: level,
      language: language,
    );
  }

  Future<void> toggleFavorite(String id) async {
    final repo = ref.read(vocabRepositoryProvider);
    await repo.toggleFavorite(id);
    // Force refresh of all providers watching the repo
    ref.invalidate(favoriteVocabCardsProvider);
    ref.invalidate(allVocabCardsProvider);
  }
}

// ── Favorite vocab cards ────────────────────────────────────────────────────

@riverpod
List<VocabCard> favoriteVocabCards(FavoriteVocabCardsRef ref) {
  final repo = ref.read(vocabRepositoryProvider);
  return repo.getFavoriteCards();
}

// ── All vocab cards ─────────────────────────────────────────────────────────

@riverpod
List<VocabCard> allVocabCards(AllVocabCardsRef ref) {
  final repo = ref.read(vocabRepositoryProvider);
  final level = (ref.watch(selectedLevelProvider) ?? 'A1').toUpperCase();
  final language = ref.watch(selectedLanguageProvider).toLowerCase().trim();

  final isGerman = language == 'german';

  return repo.getAllCards()
      .where((c) => c.level.toUpperCase() == level && (c.category?.toLowerCase() == language || isGerman))
      .toList();
}

// ── Vocab stats ─────────────────────────────────────────────────────────────

@riverpod
Map<String, dynamic> vocabStats(VocabStatsRef ref) {
  final repo = ref.read(vocabRepositoryProvider);
  return {
    'total': repo.totalCards,
    'due': repo.dueCount,
    'byLevel': repo.cardsByLevel,
    'avgEaseFactor': repo.averageEaseFactor,
  };
}

// ── Word of the Day ─────────────────────────────────────────────────────────

@riverpod
VocabCard? wordOfTheDay(WordOfTheDayRef ref) {
  final allCards = ref.watch(allVocabCardsProvider);
  if (allCards.isEmpty) return null;

  // Use the day of the year as a seed to pick a consistent word for the day
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  
  // Sort by ID to ensure consistent indexing across devices
  final sortedCards = [...allCards]..sort((a, b) => a.id.compareTo(b.id));
  
  return sortedCards[dayOfYear % sortedCards.length];
}

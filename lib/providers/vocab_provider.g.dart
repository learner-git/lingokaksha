// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoriteVocabCardsHash() =>
    r'131480f043f6bf18da8da709ae18c938de40f636';

/// See also [favoriteVocabCards].
@ProviderFor(favoriteVocabCards)
final favoriteVocabCardsProvider =
    AutoDisposeProvider<List<VocabCard>>.internal(
  favoriteVocabCards,
  name: r'favoriteVocabCardsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoriteVocabCardsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FavoriteVocabCardsRef = AutoDisposeProviderRef<List<VocabCard>>;
String _$allVocabCardsHash() => r'9d3f2a48a5b995ae2e32bae4ee53bdaabcb998ba';

/// See also [allVocabCards].
@ProviderFor(allVocabCards)
final allVocabCardsProvider = AutoDisposeProvider<List<VocabCard>>.internal(
  allVocabCards,
  name: r'allVocabCardsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allVocabCardsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllVocabCardsRef = AutoDisposeProviderRef<List<VocabCard>>;
String _$vocabStatsHash() => r'067d614a67264f36be3b32b39e164538da9144cc';

/// See also [vocabStats].
@ProviderFor(vocabStats)
final vocabStatsProvider = AutoDisposeProvider<Map<String, dynamic>>.internal(
  vocabStats,
  name: r'vocabStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$vocabStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef VocabStatsRef = AutoDisposeProviderRef<Map<String, dynamic>>;
String _$wordOfTheDayHash() => r'fcf4c5c94fd68cdcab3722b30919a97b379537f0';

/// See also [wordOfTheDay].
@ProviderFor(wordOfTheDay)
final wordOfTheDayProvider = AutoDisposeProvider<VocabCard?>.internal(
  wordOfTheDay,
  name: r'wordOfTheDayProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$wordOfTheDayHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WordOfTheDayRef = AutoDisposeProviderRef<VocabCard?>;
String _$vocabReviewNotifierHash() =>
    r'6a91228eefc589ab8d2004b89efd50d1544b12eb';

/// See also [VocabReviewNotifier].
@ProviderFor(VocabReviewNotifier)
final vocabReviewNotifierProvider =
    AutoDisposeNotifierProvider<VocabReviewNotifier, List<VocabCard>>.internal(
  VocabReviewNotifier.new,
  name: r'vocabReviewNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vocabReviewNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VocabReviewNotifier = AutoDisposeNotifier<List<VocabCard>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

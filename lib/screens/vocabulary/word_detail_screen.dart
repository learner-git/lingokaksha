import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/gpt_service.dart';
import '../../providers/user_provider.dart';
import '../../data/repositories/vocab_repository.dart';

import '../../data/models/vocab_card.dart';

class WordDetailScreen extends ConsumerStatefulWidget {
  final String word;
  final String level;
  final VocabCard? card;

  const WordDetailScreen({
    super.key,
    required this.word,
    required this.level,
    this.card,
  });

  @override
  ConsumerState<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends ConsumerState<WordDetailScreen> {
  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _loadDetails();
  }

  Future<Map<String, dynamic>> _loadDetails() async {
    final language = ref.read(selectedLanguageProvider);
    final repo = ref.read(vocabRepositoryProvider);

    // 1. HIGH PRIORITY: Use passed card
    if (widget.card != null && _isCardComplete(widget.card!)) {
      return _mapCardToDetails(widget.card!);
    }

    // 2. MEDIUM PRIORITY: Search local Database (JSON seeded data)
    final localCard = _findLocalCard(repo, language);
    if (localCard != null && _isCardComplete(localCard)) {
      return _mapCardToDetails(localCard);
    }

    // 3. LOW PRIORITY: AI Fallback (Only if online)
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      return ref.read(gptServiceProvider).getWordDetails(
            word: widget.word,
            language: language,
            level: widget.level,
          );
    }

    // 4. CRITICAL FALLBACK: Offline & Not found
    throw Exception('You are offline and this word is not in your local dictionary.');
  }

  bool _isCardComplete(VocabCard card) {
    return card.examplePresent != null &&
        card.examplePast != null &&
        card.exampleFuture != null;
  }

  VocabCard? _findLocalCard(VocabRepository repo, String language) {
    try {
      final normalizedWord = widget.word.toLowerCase().trim();
      final normalizedLevel = widget.level.toUpperCase().trim();
      final normalizedLang = language.toLowerCase().trim();

      return repo.getAllCards().firstWhere(
            (c) =>
                c.targetText.toLowerCase().trim() == normalizedWord &&
                c.level.toUpperCase().trim() == normalizedLevel &&
                (normalizedLang == 'german' || c.category?.toLowerCase() == normalizedLang),
          );
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _mapCardToDetails(VocabCard card) {
    return {
      'meaning': card.english,
      'examples': [
        {
          'tense': 'present',
          'sentence': card.examplePresent ?? 'N/A',
          'translation': card.translationPresent ?? 'Present tense example',
        },
        {
          'tense': 'past',
          'sentence': card.examplePast ?? 'N/A',
          'translation': card.translationPast ?? 'Past tense example',
        },
        {
          'tense': 'future',
          'sentence': card.exampleFuture ?? 'N/A',
          'translation': card.translationFuture ?? 'Future tense example',
        },
      ]
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final cardColor = isDark ? AppColors.surfaceVariantDark : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('😕', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 16),
                    const Text(
                      'Oops! This service is temporarily unavailable. Please try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => setState(() => _detailsFuture = _loadDetails()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;
          final meaning = data['meaning'] as String;
          final examples = data['examples'] as List;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.word,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 8),
                Text(
                  meaning,
                  style: TextStyle(fontSize: 20, color: secondaryTextColor, fontWeight: FontWeight.w500),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 32),
                Text(
                  'Examples',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                ),
                const SizedBox(height: 16),
                ...examples.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final ex = entry.value as Map<String, dynamic>;
                  final tense = ex['tense'] as String;
                  final sentence = ex['sentence'] as String;
                  final translation = ex['translation'] as String;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tense.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          sentence,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          translation,
                          style: TextStyle(
                            fontSize: 15,
                            color: secondaryTextColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: (200 + idx * 100).ms).fadeIn().slideY(begin: 0.1);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

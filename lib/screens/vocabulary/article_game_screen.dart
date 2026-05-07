import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/vocab_card.dart';
import '../../providers/vocab_provider.dart';
import '../../providers/user_provider.dart';

class ArticleGameScreen extends ConsumerStatefulWidget {
  const ArticleGameScreen({super.key});

  @override
  ConsumerState<ArticleGameScreen> createState() => _ArticleGameScreenState();
}

class _ArticleGameScreenState extends ConsumerState<ArticleGameScreen> {
  List<VocabCard> _allNouns = [];
  List<VocabCard> _pendingNouns = [];
  VocabCard? _currentWord;
  String? _selectedArticle;
  bool _isCorrect = false;
  bool _answered = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNouns();
    });
  }

  List<String> _getArticles(String language) {
    switch (language.toLowerCase()) {
      case 'french':
        return ['Le', 'La', 'Les'];
      case 'spanish':
        return ['El', 'La', 'Los', 'Las'];
      case 'german':
      default:
        return ['Der', 'Die', 'Das'];
    }
  }

  void _loadNouns() {
    final allCards = ref.read(allVocabCardsProvider);
    final language = ref.read(selectedLanguageProvider);
    final articles = _getArticles(language).map((e) => e.toLowerCase()).toList();

    _allNouns = allCards.where((card) {
      final g = card.targetText.toLowerCase();
      return articles.any((article) => g.startsWith('$article '));
    }).toList();
    _pendingNouns = List.from(_allNouns)..shuffle();
    _nextWord();
  }

  void _nextWord() {
    if (_pendingNouns.isEmpty && _allNouns.isNotEmpty) {
      // Refresh session if all done
      _pendingNouns = List.from(_allNouns)..shuffle();
    }
    
    if (_pendingNouns.isEmpty) return;

    setState(() {
      _currentWord = _pendingNouns.first;
      _selectedArticle = null;
      _answered = false;
      _isCorrect = false;
    });
  }

  void _checkAnswer(String article) {
    if (_answered || _currentWord == null) return;

    final correctArticle = _currentWord!.targetText.split(' ')[0].toLowerCase();
    final isCorrect = article.toLowerCase() == correctArticle;
    
    setState(() {
      _selectedArticle = article;
      _answered = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      // Remove from pending if correct
      _pendingNouns.removeAt(0);
    } else {
      // Failed: move to end of queue to come back later
      final failedWord = _pendingNouns.removeAt(0);
      _pendingNouns.add(failedWord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allCards = ref.watch(allVocabCardsProvider);
    final language = ref.watch(selectedLanguageProvider);
    final articles = _getArticles(language);
    final articlesLower = articles.map((e) => e.toLowerCase()).toList();
    
    // Update nouns list if cards changed
    final currentNouns = allCards.where((card) {
      final g = card.targetText.toLowerCase();
      return articlesLower.any((article) => g.startsWith('$article '));
    }).toList();

    if (currentNouns.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔍', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 10),
              const Text('No nouns found for this level',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('The "Guess the Article" game requires nouns starting with ${articles.join(', ')}.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => ref.invalidate(allVocabCardsProvider),
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentWord == null || !currentNouns.contains(_currentWord)) {
      // Initialize or reset if the level changed and current word is no longer valid
      Future.microtask(() {
        setState(() {
          _nouns = currentNouns;
          _nextWord();
        });
      });
      return const Center(child: CircularProgressIndicator());
    }

    final nounParts = _currentWord!.targetText.split(' ');
    final nounPart = nounParts.length > 1 ? nounParts.sublist(1).join(' ') : _currentWord!.targetText;
    final correctArticle = nounParts[0];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final cardColor = isDark ? AppColors.surfaceVariantDark : Theme.of(context).cardColor;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'What is the correct article?',
                style: TextStyle(fontSize: 18, color: secondaryTextColor),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: _answered ? '$correctArticle ' : '____ ',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _answered
                                ? (_isCorrect ? AppColors.success : AppColors.error)
                                : AppColors.primary,
                          ),
                        ),
                        TextSpan(
                          text: nounPart,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate(key: ValueKey(_currentWord!.id)).fadeIn().slideY(begin: 0.1),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: articles.map((art) => SizedBox(
                  width: (MediaQuery.of(context).size.width - 48 - (articles.length > 3 ? 24 : 12) * (articles.length - 1)) / (articles.length > 3 ? 2 : articles.length),
                  child: _buildArticleOption(art, isDark),
                )).toList(),
              ),
              const SizedBox(height: 32),
              if (_answered) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isCorrect
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isCorrect ? 'Richtig! (Correct)' : 'Falsch! (Incorrect)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isCorrect ? AppColors.success : AppColors.error,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'English: ${_currentWord!.english}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: primaryTextColor),
                      ),
                      if (_currentWord!.exampleSentence != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Example: ${_currentWord!.exampleSentence}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn().scale(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextWord,
                    child: const Text('Next Word'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleOption(String article, bool isDark) {
    final bool isSelected = _selectedArticle == article;
    final bool isCorrectOption = _answered &&
        _currentWord!.targetText.split(' ')[0].toLowerCase() == article.toLowerCase();

    Color borderColor = AppColors.primary.withOpacity(0.2);
    Color? backgroundColor;
    Color textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    if (_answered) {
      if (isCorrectOption) {
        borderColor = AppColors.success;
        backgroundColor = AppColors.success.withOpacity(0.15);
        textColor = AppColors.success;
      } else if (isSelected) {
        borderColor = AppColors.error;
        backgroundColor = AppColors.error.withOpacity(0.15);
        textColor = AppColors.error;
      } else {
        borderColor = Colors.grey.withOpacity(0.2);
        textColor = isDark ? AppColors.textHintDark : Colors.grey;
      }
    } else {
      if (isSelected) {
        borderColor = AppColors.primary;
        backgroundColor = AppColors.primary.withOpacity(0.15);
        textColor = AppColors.primary;
      }
    }

    return Expanded(
      child: InkWell(
        onTap: () => _checkAnswer(article),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Center(
            child: Text(
              article,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

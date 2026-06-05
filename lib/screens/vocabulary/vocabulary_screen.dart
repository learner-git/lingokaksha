import 'article_game_screen.dart';
import 'word_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/vocab_card.dart';
import '../../core/utils/app_haptics.dart';
import '../../widgets/common/app_widgets.dart';
import '../../widgets/common/app_svg.dart';
import '../../data/repositories/vocab_repository.dart';
import '../../providers/vocab_provider.dart';
import '../../providers/user_provider.dart';

class VocabularyScreen extends ConsumerStatefulWidget {
  const VocabularyScreen({super.key});

  @override
  ConsumerState<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends ConsumerState<VocabularyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  bool _flipped = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _rate(VocabCard card, int quality) async {
    AppHaptics.tap();
    await ref.read(vocabReviewNotifierProvider.notifier).reviewCard(card.id, quality);
    
    setState(() {
      _flipped = false;
      if (ref.read(vocabReviewNotifierProvider).isEmpty) {
        _showSessionComplete();
      }
    });
  }

  void _showSessionComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🎉', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text('Session complete!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('You have reviewed all due cards.',
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(vocabReviewNotifierProvider.notifier).refreshDue();
            },
            child: const Text('Back to Start'),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary'),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Flashcards'),
            Tab(text: 'Guess Article'),
            Tab(text: 'Word list'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildFlashcardTab(),
          const ArticleGameScreen(),
          _buildWordListTab(),
          _buildCategoriesTab(),
        ],
      ),
    );
  }

  Widget _buildFlashcardTab() {
    final dueCards = ref.watch(vocabReviewNotifierProvider);
    final language = ref.watch(selectedLanguageProvider);
    final languageLabel = language.isNotEmpty
        ? language[0].toUpperCase() + language.substring(1)
        : 'German';
    final theme = Theme.of(context);

    if (dueCards.isEmpty) {
      return EmptyState(
        illustrationAsset: AppAssets.emptySuccess,
        title: 'All caught up!',
        subtitle: 'Check back later for new reviews.',
        action: ElevatedButton(
          onPressed: () =>
              ref.read(vocabReviewNotifierProvider.notifier).refreshDue(),
          child: const Text('Refresh'),
        ),
      );
    }

    final card = dueCards[0];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reviewing ${dueCards.length} cards', style: theme.textTheme.bodySmall),
              IconButton(
                icon: Icon(card.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: card.isFavorite ? Colors.red : null),
                onPressed: () => ref.read(vocabReviewNotifierProvider.notifier).toggleFavorite(card.id),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _flipped = !_flipped),
              child: AnimatedSwitcher(
                duration: 300.ms,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: _flipped
                    ? _FlashCard(
                        key: const ValueKey('back'),
                        topLabel: 'English',
                        mainText: card.english,
                        subText: card.exampleSentence ?? '',
                        color: AppColors.secondary,
                      )
                    : _FlashCard(
                        key: const ValueKey('front'),
                        topLabel: '$languageLabel · Tap to reveal',
                        mainText: card.targetText,
                        subText: card.category ?? '',
                        color: AppColors.primary,
                      ),
              ),
            ),
          ),

          if (_flipped) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                _RateButton(label: 'Again', iconAsset: AppAssets.rateAgain, color: AppColors.error, onTap: () => _rate(card, 0)),
                const SizedBox(width: 8),
                _RateButton(label: 'Hard', iconAsset: AppAssets.rateHard, color: AppColors.warning, onTap: () => _rate(card, 2)),
                const SizedBox(width: 8),
                _RateButton(label: 'Good', iconAsset: AppAssets.rateGood, color: AppColors.info, onTap: () => _rate(card, 3)),
                const SizedBox(width: 8),
                _RateButton(label: 'Easy', iconAsset: AppAssets.rateEasy, color: AppColors.success, onTap: () => _rate(card, 5)),
              ],
            ),
          ] else ...[
            const SizedBox(height: 40),
            const Text('Tap the card to reveal the answer',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWordListTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final language = ref.watch(selectedLanguageProvider).toLowerCase().trim();

    // If searching, we show cards from ALL levels for that language
    List<VocabCard> displayCards;
    if (_searchQuery.isEmpty) {
      displayCards = ref.watch(allVocabCardsProvider);
    } else {
      final allRepoCards = ref.read(vocabRepositoryProvider).getAllCards();
      displayCards = allRepoCards.where((c) {
        final matchesQuery = c.targetText.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.english.toLowerCase().contains(_searchQuery.toLowerCase());
        final isGerman = language == 'german';
        final matchesLang = (c.category?.toLowerCase() == language || isGerman);
        return matchesQuery && matchesLang;
      }).toList();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search words across all levels...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    }) 
                  : null,
              filled: true,
              fillColor: isDark ? AppColors.surfaceVariantDark : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: displayCards.isEmpty
            ? EmptyState(
                illustrationAsset: _searchQuery.isEmpty
                    ? AppAssets.emptyVocab
                    : AppAssets.emptySearch,
                title: _searchQuery.isEmpty
                    ? 'No words found'
                    : 'No matches found',
                subtitle: _searchQuery.isEmpty
                    ? 'Add vocabulary or change your level to see words here.'
                    : 'Try a different search term for "$_searchQuery".',
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: displayCards.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.divider),
                itemBuilder: (context, i) {
                  final card = displayCards[i];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WordDetailScreen(
                            word: card.targetText,
                            level: card.level,
                            card: card,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    title: Text(card.targetText, style: TextStyle(fontWeight: FontWeight.w600, color: primaryTextColor)),
                    subtitle: Text(card.english, style: TextStyle(color: secondaryTextColor)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(card.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: card.isFavorite ? Colors.red : (isDark ? AppColors.textHintDark : null), size: 20),
                          onPressed: () => ref.read(vocabReviewNotifierProvider.notifier).toggleFavorite(card.id),
                        ),
                        _LevelBadge(level: card.level),
                      ],
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _buildCategoriesTab() {
    final categories = ref.read(vocabRepositoryProvider).getUniqueCategories();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    if (categories.isEmpty) {
      return const EmptyState(
        illustrationAsset: AppAssets.emptyVocab,
        title: 'No categories found',
        subtitle: 'Categories will appear once vocabulary is loaded.',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, i) {
        final category = categories[i];
        final cards = ref.read(vocabRepositoryProvider).getCardsByCategory(category);

        return Card(
          elevation: 0,
          color: isDark ? AppColors.surfaceVariantDark : AppColors.primary.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryReviewScreen(category: category, cards: cards),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: primaryTextColor)),
                  const SizedBox(height: 4),
                  Text('${cards.length} words', style: TextStyle(fontSize: 14, color: secondaryTextColor)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryReviewScreen extends ConsumerStatefulWidget {
  final String category;
  final List<VocabCard> cards;

  const CategoryReviewScreen({super.key, required this.category, required this.cards});

  @override
  ConsumerState<CategoryReviewScreen> createState() => _CategoryReviewScreenState();
}

class _CategoryReviewScreenState extends ConsumerState<CategoryReviewScreen> {
  int _currentIndex = 0;
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[_currentIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / widget.cards.length,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 12),
            Text('Word ${_currentIndex + 1} of ${widget.cards.length}',
                style: TextStyle(color: secondaryTextColor)),
            const Spacer(),
            GestureDetector(
              onTap: () => setState(() => _revealed = !_revealed),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _revealed
                    ? _FlashCard(
                        key: const ValueKey('back'),
                        topLabel: 'English',
                        mainText: card.english,
                        subText: card.exampleSentence ?? '',
                        color: AppColors.secondary,
                      )
                    : _FlashCard(
                        key: const ValueKey('front'),
                        topLabel: 'Target Language · Tap to reveal',
                        mainText: card.targetText,
                        subText: 'Tap to see translation',
                        color: AppColors.primary,
                      ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _currentIndex > 0
                        ? () => setState(() {
                              _currentIndex--;
                              _revealed = false;
                            })
                        : null,
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentIndex < widget.cards.length - 1) {
                        setState(() {
                          _currentIndex++;
                          _revealed = false;
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(_currentIndex < widget.cards.length - 1 ? 'Next' : 'Finish'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FlashCard extends StatelessWidget {
  final String topLabel;
  final String mainText;
  final String subText;
  final Color color;

  const _FlashCard({
    super.key,
    required this.topLabel,
    required this.mainText,
    required this.subText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final cardColor = isDark ? AppColors.surfaceVariantDark : Theme.of(context).cardColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(topLabel, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          Text(
            mainText,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: primaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (subText.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              subText,
              style: TextStyle(
                fontSize: 15,
                color: secondaryTextColor,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _RateButton extends StatelessWidget {
  final String label;
  final String iconAsset;
  final Color color;
  final VoidCallback onTap;

  const _RateButton({
    required this.label,
    required this.iconAsset,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              AppSvg(
                asset: iconAsset,
                width: 22,
                height: 22,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String level;
  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        level,
        style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

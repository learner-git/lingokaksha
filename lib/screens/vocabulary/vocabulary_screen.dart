import 'article_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/vocab_card.dart';
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

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _rate(VocabCard card, int quality) async {
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
    final languageLabel = language[0].toUpperCase() + language.substring(1);
    final theme = Theme.of(context);

    if (dueCards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            const Text('All caught up!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Check back later for new reviews.', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(vocabReviewNotifierProvider.notifier).refreshDue(),
              child: const Text('Refresh'),
            ),
          ],
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
                _RateButton(label: 'Again', emoji: '😓', color: AppColors.error, onTap: () => _rate(card, 0)),
                const SizedBox(width: 8),
                _RateButton(label: 'Hard', emoji: '😐', color: AppColors.warning, onTap: () => _rate(card, 2)),
                const SizedBox(width: 8),
                _RateButton(label: 'Good', emoji: '🙂', color: AppColors.info, onTap: () => _rate(card, 3)),
                const SizedBox(width: 8),
                _RateButton(label: 'Easy', emoji: '😄', color: AppColors.success, onTap: () => _rate(card, 5)),
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
    final allCards = ref.watch(allVocabCardsProvider);

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: allCards.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final card = allCards[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          title: Text(card.targetText, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(card.english),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(card.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: card.isFavorite ? Colors.red : null, size: 20),
                onPressed: () => ref.read(vocabReviewNotifierProvider.notifier).toggleFavorite(card.id),
              ),
              _LevelBadge(level: card.level),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    final categories = ref.read(vocabRepositoryProvider).getUniqueCategories();

    if (categories.isEmpty) {
      return const Center(
        child: Text('No categories found', style: TextStyle(color: AppColors.textSecondary)),
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
          color: AppColors.primary.withOpacity(0.05),
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
                  Text(category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('${cards.length} words', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryReviewScreen extends StatefulWidget {
  final String category;
  final List<VocabCard> cards;

  const CategoryReviewScreen({super.key, required this.category, required this.cards});

  @override
  State<CategoryReviewScreen> createState() => _CategoryReviewScreenState();
}

class _CategoryReviewScreenState extends State<CategoryReviewScreen> {
  int _currentIndex = 0;
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[_currentIndex];
    // We don't have easy access to ref here, but we can pass it or just use a generic label
    // or better, since it's a ConsumerStatefulWidget, use ref.
    // Wait, CategoryReviewScreen is a StatefulWidget, let me change it to ConsumerStatefulWidget
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
                style: const TextStyle(color: AppColors.textSecondary)),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(topLabel, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          Text(mainText, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          if (subText.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(subText, style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

class _RateButton extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _RateButton({required this.label, required this.emoji, required this.color, required this.onTap});

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
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
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

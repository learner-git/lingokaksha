/// Central registry for image and vector asset paths.
class AppAssets {
  AppAssets._();

  static const String _branding = 'assets/images/branding';
  static const String _levels = 'assets/images/levels';
  static const String _ratings = 'assets/images/ratings';
  static const String _illustrations = 'assets/images/illustrations';

  // Branding
  static const String logoMark = '$_branding/logo_mark.svg';
  static const String logoWordmark = '$_branding/logo_wordmark.svg';
  static const String logoGoogle = '$_branding/logo_google.svg';

  // CEFR level badges
  static const String levelA1 = '$_levels/level_a1.svg';
  static const String levelA2 = '$_levels/level_a2.svg';
  static const String levelB1 = '$_levels/level_b1.svg';
  static const String levelB2 = '$_levels/level_b2.svg';

  // Flashcard rating icons
  static const String rateAgain = '$_ratings/rate_again.svg';
  static const String rateHard = '$_ratings/rate_hard.svg';
  static const String rateGood = '$_ratings/rate_good.svg';
  static const String rateEasy = '$_ratings/rate_easy.svg';

  // Empty states
  static const String emptyVocab = '$_illustrations/empty_vocab.svg';
  static const String emptySearch = '$_illustrations/empty_search.svg';
  static const String emptyNetwork = '$_illustrations/empty_network.svg';
  static const String emptySuccess = '$_illustrations/empty_success.svg';

  static String levelIcon(String code) {
    switch (code.toUpperCase()) {
      case 'A1':
        return levelA1;
      case 'A2':
        return levelA2;
      case 'B1':
        return levelB1;
      case 'B2':
        return levelB2;
      default:
        return levelA1;
    }
  }
}

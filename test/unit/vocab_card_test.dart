import 'package:flutter_test/flutter_test.dart';

import '../../lib/data/models/vocab_card.dart';

void main() {
  group('VocabCard SM-2 algorithm', () {
    late VocabCard card;

    setUp(() {
      card = VocabCard(
        id: 'test-1',
        targetText: 'der Hund',
        english: 'the dog',
        level: 'A1',
      );
    });

    test('first review with quality 5 sets interval to 1', () {
      final reviewed = card.reviewed(5);
      expect(reviewed.repetitions, 1);
      expect(reviewed.interval, 1);
    });

    test('second review (rep=1) sets interval to 6', () {
      final first = card.reviewed(5);
      final second = first.reviewed(5);
      expect(second.interval, 6);
      expect(second.repetitions, 2);
    });

    test('quality < 3 resets repetitions', () {
      final first = card.reviewed(5);
      final failed = first.reviewed(1);
      expect(failed.repetitions, 0);
      expect(failed.interval, 1);
    });

    test('ease factor increases with quality 5', () {
      final reviewed = card.reviewed(5);
      expect(reviewed.easeFactor, greaterThan(2.5));
    });

    test('ease factor decreases with quality 2', () {
      final reviewed = card.reviewed(2);
      expect(reviewed.easeFactor, lessThan(2.5));
    });

    test('ease factor never drops below 1.3', () {
      VocabCard c = card;
      for (int i = 0; i < 10; i++) {
        c = c.reviewed(0);
      }
      expect(c.easeFactor, greaterThanOrEqualTo(1.3));
    });

    test('nextReview is in future after review', () {
      final reviewed = card.reviewed(5);
      expect(reviewed.nextReview.isAfter(DateTime.now()), isTrue);
    });
  });
}

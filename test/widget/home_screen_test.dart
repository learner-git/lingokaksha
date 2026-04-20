import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/screens/home/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders greeting and quick actions', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pump();

      // Greetings (one of three)
      final greetings = ['Guten Morgen', 'Guten Tag', 'Guten Abend'];
      final found = greetings.any((g) => find.textContaining(g).evaluate().isNotEmpty);
      expect(found, isTrue);

      // Quick action labels
      expect(find.text('Chat Tutor'), findsOneWidget);
      expect(find.text('Daily Quiz'), findsOneWidget);
      expect(find.text('Vocabulary'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Project smoke: MaterialApp builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('LingoKaksha')),
        ),
      ),
    );

    expect(find.text('LingoKaksha'), findsOneWidget);
  });
}

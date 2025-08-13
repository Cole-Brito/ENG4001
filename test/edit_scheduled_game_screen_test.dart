import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/screens/edit_scheduled_game_screen.dart';

void main() {
  testWidgets('EditScheduledGameScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: EditScheduledGameScreen()));

    expect(find.byType(EditScheduledGameScreen), findsOneWidget);
  });
}

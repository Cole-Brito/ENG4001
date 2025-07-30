import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/screens/create_game_screen.dart';

void main() {
  testWidgets('CreateGameScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CreateGameScreen()));

    expect(find.byType(CreateGameScreen), findsOneWidget);
  });
}

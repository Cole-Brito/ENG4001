import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/screens/leaderboard_screen.dart';

void main() {
  testWidgets('LeaderboardScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LeaderboardScreen()));

    expect(find.byType(LeaderboardScreen), findsOneWidget);
  });
}

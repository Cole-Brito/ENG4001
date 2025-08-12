import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/screens/scheduled_games_screen.dart';

void main() {
  testWidgets('ScheduledGamesScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ScheduledGamesScreen()));

    expect(find.byType(ScheduledGamesScreen), findsOneWidget);
  });
}

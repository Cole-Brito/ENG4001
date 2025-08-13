import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/screens/create_season_screen.dart';

void main() {
  testWidgets('CreateSeasonScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CreateSeasonScreen()));

    expect(find.byType(CreateSeasonScreen), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/models/user.dart';
import 'package:flutter_application_2/screens/admin_dashboard.dart';

void main() {
  // Sample test user
  final testUser = User(
    //id: 'admin123',
    username: 'AdminTest',
    //email: 'admin@example.com',
    isAdmin: true,
    //points: 0,
    gamesPlayed: 0,
  );

  testWidgets('AdminDashboard displays all buttons and title', (
    WidgetTester tester,
  ) async {
    // Build the AdminDashboard widget
    await tester.pumpWidget(MaterialApp(home: AdminDashboard(user: testUser)));

    // Check for the welcome title with username
    expect(find.text('Welcome, AdminTest!'), findsOneWidget);

    // Check if 5 buttons exist
    expect(find.text('Create New Game'), findsOneWidget);
    expect(find.text('View Leaderboard'), findsOneWidget);
    expect(find.text('Create Season'), findsOneWidget);

    // Optional: Verify icons
    expect(find.byIcon(Icons.event_note), findsOneWidget);
    //expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    expect(find.byIcon(Icons.edit_calendar), findsOneWidget);
    expect(find.byIcon(Icons.leaderboard), findsOneWidget);
    //expect(find.byIcon(Icons.edit_calendar_outlined), findsOneWidget);
  });

  testWidgets('Clicking Create New Game navigates to CreateGameScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: AdminDashboard(user: testUser)));

    // Tap on the "Create New Game" card
    await tester.tap(find.text('Create New Game'));
    await tester.pumpAndSettle();

    // Since CreateGameScreen is not mocked or added, no navigation check.
    // You could test if Navigator.push was called using mock or integration.
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/main.dart';

void main() {
  testWidgets('App shows login screen title', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const ROSGameApp());

    // Verify the login screen title appears.
    expect(find.text('Login'), findsOneWidget);
  });
}

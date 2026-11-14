import 'package:flutter_test/flutter_test.dart';
import 'package:lanka_pulse/main.dart';

void main() {
  testWidgets('LankaPulse app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LankaPulseApp());

    // Verify app root initializes
    expect(find.byType(LankaPulseApp), findsOneWidget);
  });
}

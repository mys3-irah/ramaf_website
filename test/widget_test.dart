// This is a basic Flutter widget test for the RAMAF Foundation website.
import 'package:flutter_test/flutter_test.dart';
import 'package:ramaf_website/main.dart';

void main() {
  testWidgets('Smoke test for RAMAF Foundation branding', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RamafWebsite());

    // Verify that the brand name "RAMAF" is rendered
    expect(find.text('RAMAF'), findsWidgets);
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flow/app.dart';

void main() {
  testWidgets('Flow app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FlowApp()));

    // Verify that Flow app starts correctly
    expect(find.text('Flow'), findsOneWidget);
  });
}

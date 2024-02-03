import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/test/nav_app_for_testing.dart';

import 'bottom_sheet_dialog.dart';

void main() {
  testWidgets('Message Showing test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    const String text = 'test string';
    const IconData icon = Icons.check_circle;
    await tester.pumpWidget(NavAppForTesting(child: Container()));

    BottomSheetDialog([BottomSheetItem(text, const Icon(icon))]).show();
    await tester.pump();

    expect(find.byType(BottomSheetDialog), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text(text), findsOneWidget);
  });
}

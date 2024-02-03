import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/test/nav_app_for_testing.dart';

import 'message_dialog.dart';

void main() {
  testWidgets('Message Showing test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final String text = 'test string';
    await tester.pumpWidget(NavAppForTesting(child: Container()));
    MessageDialog(text).show();
    await tester.pump();

    expect(find.byType(MessageDialog), findsOneWidget);
    expect(find.text(text), findsOneWidget);
  });
}

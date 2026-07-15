import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/nav.dart';
import 'package:nav/setting/nav_setting.dart';
import 'package:nav/test/nav_app_for_testing.dart';

import 'message_dialog.dart';

Future<void> pumpNavApp(WidgetTester tester) async {
  await tester.pumpWidget(NavAppForTesting(child: Container()));
}

void main() {
  testWidgets('Message Showing test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    const String text = 'test string';
    await pumpNavApp(tester);
    MessageDialog(text).show();
    await tester.pump();

    expect(find.byType(MessageDialog), findsOneWidget);
    expect(find.text(text), findsOneWidget);
  });

  testWidgets('Message Showing Animations', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    const String text = 'test string';
    await pumpNavApp(tester);

    for (final animation in NavAni.values) {
      final dialog = MessageDialog(
        text,
        animation: animation,
      );
      dialog.show();
      await tester.pumpAndSettle();

      expect(find.byType(MessageDialog), findsOneWidget);
      expect(find.text(text), findsOneWidget);
      dialog.hide();
      await tester.pumpAndSettle();

      expect(find.byType(MessageDialog), findsNothing);
      expect(find.text(text), findsNothing);
    }
  });

  testWidgets('Message Showing useRootNavigator test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    const String text = 'test string';
    await pumpNavApp(tester);
    Nav.navSetting = NavSetting(useRootNavigator: true);
    MessageDialog(text).show();
    await tester.pump();

    expect(find.byType(MessageDialog), findsOneWidget);
    expect(find.text(text), findsOneWidget);
  });
}

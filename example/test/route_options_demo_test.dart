import 'package:example/route/route_options_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/testing.dart';

void main() {
  Future<void> open(WidgetTester tester, String key) async {
    await tester.pumpWidget(const NavAppForTesting(child: RouteOptionsDemo()));
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  testWidgets('NavAni.platform is a MaterialPageRoute named by settings',
      (tester) async {
    await open(tester, 'push-platform');
    expect(find.text('settings.name: /platform'), findsOneWidget);
    expect(find.text('MaterialPageRoute<dynamic>'), findsOneWidget);
  });

  testWidgets('fullscreenDialog', (tester) async {
    await open(tester, 'push-fullscreen');
    expect(find.text('fullscreenDialog: true'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget); // the modal's close
  });

  testWidgets('opaque: false keeps the list drawn', (tester) async {
    await open(tester, 'push-see-through');
    expect(find.text('opaque: false'), findsOneWidget);
    expect(find.text('Route options'), findsOneWidget);
  });

  testWidgets('reverseDurationMs closes faster than it opened', (tester) async {
    await open(tester, 'push-fast-close');
    await tester.tap(find.byKey(const Key('route-close')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 130));
    expect(find.byKey(const Key('route-name')), findsNothing);
  });
}

import 'package:example/screen/replaced_screen.dart';
import 'package:example/screen/sample_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/nav.dart';

import '../lib/main.dart';

void main() {
  testWidgets('home exist', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('Push', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    Nav.push(SampleScreen());
    await tester.pumpAndSettle();
    expect(find.byType(SampleScreen), findsOneWidget);
  });

  testWidgets('Push - Blink (No animation)', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    Nav.push(SampleScreen(), navAni: NavAni.Blink);
    await tester.pump();
    expect(find.byType(SampleScreen), findsOneWidget);
  });

  testWidgets('Push - Animations', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    for (final navAni in NavAni.values) {
      Nav.push(SampleScreen(), navAni: navAni);
      await tester.pumpAndSettle();
      expect(find.byType(SampleScreen), findsOneWidget);
    }
  });

  testWidgets('Push And Pop', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    Nav.push(SampleScreen());
    await tester.pumpAndSettle();
    expect(find.byType(SampleScreen), findsOneWidget);
    await popCurrentScreen(tester);
    expect(find.byType(SampleScreen), findsNothing);
  });

  testWidgets('Push 2 Screens and Clear all', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    Nav.push(SampleScreen());
    Nav.push(SampleScreen());
    Nav.clearAll();
    await tester.pumpAndSettle();
    expect(find.byType(SampleScreen), findsNothing);
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('Push 7 Screens Clear all and push.', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    Nav.push(SampleScreen());
    Nav.push(SampleScreen());
    Nav.push(SampleScreen());
    Nav.push(SampleScreen());
    Nav.push(SampleScreen());
    Nav.push(SampleScreen());
    Nav.push(SampleScreen());
    Nav.clearAllAndPush(ReplacedScreen());
    await tester.pumpAndSettle();
    expect(find.byType(SampleScreen), findsNothing);
    expect(find.byType(ReplacedScreen), findsOneWidget);
  });

  testWidgets('Push 2 screens and check both exist on the Stack', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    Nav.push(SampleScreen());
    Nav.push(ReplacedScreen());
    await tester.pumpAndSettle();
    expect(find.byType(ReplacedScreen), findsOneWidget);
    await popCurrentScreen(tester);

    expect(find.byType(SampleScreen), findsOneWidget);
  });

  testWidgets('Push Replaced', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    Nav.push(SampleScreen());
    Nav.pushReplacement(ReplacedScreen());
    await tester.pumpAndSettle();
    expect(find.byType(ReplacedScreen), findsOneWidget);
    await popCurrentScreen(tester);

    expect(find.byType(SampleScreen), findsNothing);
  });

  testWidgets('Can pop test', (WidgetTester tester) async {
    late bool canPop;
    await tester.pumpWidget(MyApp());
    Nav.push(SampleScreen());
    await tester.pumpAndSettle();
    canPop = await Nav.canPop();
    expect(canPop, true);


    await popCurrentScreen(tester);
    canPop = await Nav.canPop();
    expect(canPop, false);
  });
}

Future<void> popCurrentScreen(WidgetTester tester) async {
     await tester.tap(find.text('pop'));
  await tester.pumpAndSettle();
}

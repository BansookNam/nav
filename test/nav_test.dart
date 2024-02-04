import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nav/nav.dart';
import 'package:nav/test/nav_app_for_testing.dart';

import 'my_app.dart';
import 'nav_test.mocks.dart';
import 'screen/replaced_screen.dart';
import 'screen/result_request_screen.dart';
import 'screen/result_screen.dart';
import 'screen/sample_screen.dart';

@GenerateMocks([ResultController])
void main() {
  testWidgets('home exist', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await pumpApp(tester);
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('Push', (WidgetTester tester) async {
    await pumpApp(tester);
    Nav.push(const SampleScreen());
    await tester.pumpAndSettle();
    expect(find.byType(SampleScreen), findsOneWidget);
  });

  testWidgets('Push - Blink (No animation)', (WidgetTester tester) async {
    await pumpApp(tester);
    Nav.push(const SampleScreen(), navAni: NavAni.Blink);
    await tester.pump();
    expect(find.byType(SampleScreen), findsOneWidget);
  });

  testWidgets('Push - Animations', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await pumpApp(tester);
    for (final navAni in NavAni.values) {
      Nav.push(const SampleScreen(), navAni: navAni);
      await tester.pumpAndSettle();
      expect(find.byType(SampleScreen), findsOneWidget);
    }
  });

  testWidgets('Push And Pop', (WidgetTester tester) async {
    await pumpApp(tester);
    Nav.push(const SampleScreen());
    await tester.pumpAndSettle();
    expect(find.byType(SampleScreen), findsOneWidget);
    await popCurrentScreen(tester);
    expect(find.byType(SampleScreen), findsNothing);
  });

  testWidgets('Push get result from screen', (WidgetTester tester) async {
    final controller = MockResultController();

    await tester.pumpWidget(NavAppForTesting(child: ResultRequestScreen(controller)));
    await tester.pumpAndSettle();
    expect(find.byType(ResultRequestScreen), findsOneWidget);

    await tester.tap(find.text('Open Result Screen'));
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsOneWidget);

    await tester.tap(find.text('pop'));
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsNothing);

    verify(controller.onSuccess('data value'));
  });

  testWidgets('Push 2 Screens and Clear all', (WidgetTester tester) async {
    await pumpApp(tester);
    Nav.push(const SampleScreen());
    Nav.push(const SampleScreen());
    Nav.clearAll();
    await tester.pumpAndSettle();
    expect(find.byType(SampleScreen), findsNothing);
    expect(find.byType(MyHomePage), findsOneWidget);
  });

  testWidgets('Push 7 Screens Clear all and push.', (WidgetTester tester) async {
    await pumpApp(tester);
    Nav.push(const SampleScreen());
    Nav.push(const SampleScreen());
    Nav.push(const SampleScreen());
    Nav.push(const SampleScreen());
    Nav.push(const SampleScreen());
    Nav.push(const SampleScreen());
    Nav.push(const SampleScreen());
    Nav.clearAllAndPush(const ReplacedScreen());
    await tester.pumpAndSettle();
    expect(find.byType(SampleScreen), findsNothing);
    expect(find.byType(ReplacedScreen), findsOneWidget);
  });

  testWidgets('Push 2 screens and check both exist on the Stack', (WidgetTester tester) async {
    await pumpApp(tester);
    Nav.push(const SampleScreen());
    Nav.push(const ReplacedScreen());
    await tester.pumpAndSettle();
    expect(find.byType(ReplacedScreen), findsOneWidget);
    await popCurrentScreen(tester);

    expect(find.byType(SampleScreen), findsOneWidget);
  });

  testWidgets('Push Replaced', (WidgetTester tester) async {
    await pumpApp(tester);
    Nav.push(const SampleScreen());
    Nav.pushReplacement(const ReplacedScreen());
    await tester.pumpAndSettle();
    expect(find.byType(ReplacedScreen), findsOneWidget);
    await popCurrentScreen(tester);

    expect(find.byType(SampleScreen), findsNothing);
  });

  testWidgets('Can pop test', (WidgetTester tester) async {
    late bool canPop;
    await pumpApp(tester);
    Nav.push(const SampleScreen());
    await tester.pumpAndSettle();
    canPop = await Nav.canPop();
    expect(canPop, true);

    await popCurrentScreen(tester);
    canPop = await Nav.canPop();
    expect(canPop, false);
  });
}

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
}


Future<void> popCurrentScreen(WidgetTester tester) async {
  await tester.tap(find.text('pop'));
  await tester.pumpAndSettle();
}

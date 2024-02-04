import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nav/nav.dart';
<<<<<<< HEAD

import 'my_app.dart';
import 'screen/replaced_screen.dart';
=======
import 'package:nav/setting/nav_setting.dart';
import 'package:nav/test/nav_app_for_testing.dart';

import 'my_app.dart';
import 'nav_test.mocks.dart';
import 'screen/basic_test_screen.dart';
import 'screen/replaced_screen.dart';
import 'screen/result_request_screen.dart';
import 'screen/result_screen.dart';
>>>>>>> 3fd2496 (add mock controller to test pushForResult, popWithResult)
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

<<<<<<< HEAD
=======
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

>>>>>>> 3fd2496 (add mock controller to test pushForResult, popWithResult)
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

<<<<<<< HEAD
Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
=======
  testWidgets('base test', (WidgetTester tester) async {
    ///Test setGlobalKey has no error
    await tester.pumpWidget(const MaterialApp(home: BasicTestScreen()));

    ///initialize test
    Nav.initialize(NavSetting(useRootNavigator: true));

    expect(find.byType(BasicTestScreen), findsOneWidget);
  });

  testWidgets('navigatorState test - function returns global value When context is null',
      (WidgetTester tester) async {
    await pumpApp(tester);

    final state = Nav.navigatorState(null);
    expect(state!.context, Nav.globalContext);

    ///
  });

  testWidgets('navigatorState test - function returns Navigator.of value',
      (WidgetTester tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    final state = Nav.navigatorState(Nav.globalContext);
    expect(state, Navigator.of(Nav.globalContext));
  });

  testWidgets('navigatorState Exception test', (WidgetTester tester) async {
    await pumpApp(tester);
    await tester.pumpWidget(Builder(
      builder: (context) {
        final state = Nav.navigatorState(context);

        ///throw exception internally on Navigator.of
        expect(state, isNotNull);
        return const MyApp();
      },
    ));
  });
>>>>>>> 3fd2496 (add mock controller to test pushForResult, popWithResult)
}

Future<void> popCurrentScreen(WidgetTester tester) async {
  await tester.tap(find.text('pop'));
  await tester.pumpAndSettle();
}

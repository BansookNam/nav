import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/nav.dart';
import 'package:nav/testing.dart';

Route<dynamic> routeOf(WidgetTester tester, String text) =>
    ModalRoute.of(tester.element(find.text(text)))!;

// Pumps 10 ms frames until nothing is scheduled; returns the time it took.
Future<int> settleMs(WidgetTester tester) async {
  var ms = 0;
  while (tester.binding.hasScheduledFrame && ms < 3000) {
    await tester.pump(const Duration(milliseconds: 10));
    ms += 10;
  }
  return ms;
}

Future<void> pumpHome(WidgetTester tester) =>
    tester.pumpWidget(const NavAppForTesting(child: Text('home')));

void main() {
  navPageTests();

  group('maybePop and popUntil', () {
    testWidgets('maybePop pops with a result and respects PopScope',
        (tester) async {
      await pumpHome(tester);
      final result = Nav.push<String>(const Text('next'));
      await tester.pumpAndSettle();
      expect(await Nav.maybePop(tester.element(find.text('next')), result: 'r'),
          isTrue);
      await tester.pumpAndSettle();
      expect(await result, 'r');

      Nav.push(const PopScope(canPop: false, child: Text('stuck')));
      await tester.pumpAndSettle();
      await Nav.maybePop(tester.element(find.text('stuck')));
      await tester.pumpAndSettle();
      expect(find.text('stuck'), findsOneWidget);
    });

    testWidgets('maybePop on the first route does nothing', (tester) async {
      await pumpHome(tester);
      expect(await Nav.maybePop(tester.element(find.text('home'))), isFalse);
    });

    testWidgets('popUntil goes back to the first screen', (tester) async {
      await pumpHome(tester);
      Nav.push(const Text('a'));
      await tester.pumpAndSettle();
      Nav.push(const Text('b'), settings: const RouteSettings(name: '/b'));
      await tester.pumpAndSettle();
      Nav.push(const Text('c'));
      await tester.pumpAndSettle();

      Nav.popUntil((route) => route.settings.name == '/b');
      await tester.pumpAndSettle();
      expect(find.text('b'), findsOneWidget);
      expect(find.text('c'), findsNothing);

      Nav.popUntil((route) => route.isFirst);
      await tester.pumpAndSettle();
      expect(Nav.canPop(), isFalse);
      expect(find.text('home'), findsOneWidget);
    });
  });

  group('Nav.push route options', () {
    testWidgets('settings, fullscreenDialog, opaque and maintainState',
        (tester) async {
      await pumpHome(tester);
      Nav.push(
        const Text('next'),
        navAni: NavAni.Bottom,
        settings: const RouteSettings(name: '/next', arguments: 7),
        fullscreenDialog: true,
        opaque: false,
        maintainState: false,
      );
      await tester.pumpAndSettle();
      final route = routeOf(tester, 'next') as PageRoute<dynamic>;
      expect(route.settings.name, '/next');
      expect(route.settings.arguments, 7);
      expect(route.fullscreenDialog, isTrue);
      expect(route.opaque, isFalse);
      expect(route.maintainState, isFalse);
      // Not opaque: the screen below is still drawn.
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('defaults are unchanged', (tester) async {
      await pumpHome(tester);
      Nav.push(const Text('next'), navAni: NavAni.Fade);
      await tester.pumpAndSettle();
      final route = routeOf(tester, 'next') as PageRoute<dynamic>;
      expect(route, isA<FadeRouteBuilder<dynamic>>());
      expect(route.settings.name, isNull);
      expect(route.fullscreenDialog, isFalse);
      expect(route.opaque, isTrue);
      expect(route.maintainState, isTrue);
      expect(route.transitionDuration,
          const Duration(milliseconds: Nav.defaultDurationMs));
      expect(route.reverseTransitionDuration, route.transitionDuration);
    });

    testWidgets('reverseDurationMs times the pop', (tester) async {
      await pumpHome(tester);
      Nav.push(const Text('next'),
          navAni: NavAni.Bottom, durationMs: 300, reverseDurationMs: 100);
      await tester.pump();
      expect(await settleMs(tester), inInclusiveRange(280, 320));
      Nav.pop(tester.element(find.text('next')));
      await tester.pump();
      expect(await settleMs(tester), inInclusiveRange(80, 120));
      expect(find.text('next'), findsNothing);
    });

    testWidgets('curve shapes the slide', (tester) async {
      await pumpHome(tester);
      Nav.push(const Text('next'),
          navAni: NavAni.Bottom, durationMs: 200, curve: Curves.easeIn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final slide = tester.widget<SlideTransition>(find
          .ancestor(
              of: find.text('next'), matching: find.byType(SlideTransition))
          .first);
      // easeIn at t = 0.5 is ~0.32 of the way: dy ~0.68 (linear would be 0.5).
      expect(slide.position.value.dy,
          closeTo(1 - Curves.easeIn.transform(0.5), 0.02));
    });

    testWidgets('every NavAni takes the options', (tester) async {
      await pumpHome(tester);
      for (final ani in NavAni.values) {
        Nav.push(Text('to ${ani.name}'),
            navAni: ani,
            settings: RouteSettings(name: ani.name),
            fullscreenDialog: true);
        await tester.pumpAndSettle();
        final route = routeOf(tester, 'to ${ani.name}') as PageRoute<dynamic>;
        expect(route.settings.name, ani.name, reason: ani.name);
        expect(route.fullscreenDialog, isTrue, reason: ani.name);
        Nav.pop(tester.element(find.text('to ${ani.name}')));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Ripple takes reverseDurationMs and curve', (tester) async {
      await pumpHome(tester);
      Nav.push(const Text('ripple'),
          navAni: NavAni.Ripple, reverseDurationMs: 30, curve: Curves.easeIn);
      await tester.pumpAndSettle();
      final route = routeOf(tester, 'ripple') as RippleRouteBuilder<dynamic>;
      expect(route.reverseTransitionDuration, const Duration(milliseconds: 30));
      expect(route.curve, Curves.easeIn);
    });

    testWidgets('pushReplacement and clearAllAndPush pass the options',
        (tester) async {
      await pumpHome(tester);
      Nav.pushReplacement(const Text('replaced'),
          settings: const RouteSettings(name: '/replaced'),
          reverseDurationMs: 50);
      await tester.pumpAndSettle();
      final replaced = routeOf(tester, 'replaced') as PageRoute<dynamic>;
      expect(replaced.settings.name, '/replaced');
      expect(
          replaced.reverseTransitionDuration, const Duration(milliseconds: 50));

      Nav.clearAllAndPush(const Text('fresh'),
          settings: const RouteSettings(name: '/fresh'), opaque: false);
      await tester.pumpAndSettle();
      final fresh = routeOf(tester, 'fresh') as PageRoute<dynamic>;
      expect(fresh.settings.name, '/fresh');
      expect(fresh.opaque, isFalse);
      expect(Nav.canPop(), isFalse);
    });

    testWidgets('pushResult passes the options', (tester) async {
      await pumpHome(tester);
      Nav.pushResult<int>(const _ResultScreen(),
          settings: const RouteSettings(name: '/result'));
      await tester.pumpAndSettle();
      expect(routeOf(tester, 'result').settings.name, '/result');
    });
  });

  group('NavAni.platform', () {
    testWidgets('is a MaterialPageRoute', (tester) async {
      await pumpHome(tester);
      Nav.push(const Text('next'),
          navAni: NavAni.platform,
          settings: const RouteSettings(name: '/p'),
          fullscreenDialog: true,
          maintainState: false);
      await tester.pumpAndSettle();
      final route = routeOf(tester, 'next');
      expect(route, isA<MaterialPageRoute<dynamic>>());
      route as MaterialPageRoute<dynamic>;
      expect(route.settings.name, '/p');
      expect(route.fullscreenDialog, isTrue);
      expect(route.maintainState, isFalse);
    });

    testWidgets('follows the theme\'s PageTransitionsTheme', (tester) async {
      // MaterialPageRoute reads the transition from the theme.
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
        ),
        home: Builder(builder: (context) {
          return TextButton(
            onPressed: () => Nav.push(const Text('next'),
                navAni: NavAni.platform, context: context),
            child: const Text('go'),
          );
        }),
      ));
      await tester.tap(find.text('go'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(
          find.ancestor(
              of: find.text('next'),
              matching: find.byType(CupertinoPageTransition)),
          findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('a DialogWidget with NavAni.platform is Material\'s dialog',
        (tester) async {
      await pumpHome(tester);
      _Dialog(animation: NavAni.platform).show();
      await tester.pumpAndSettle();
      expect(routeOf(tester, 'dialog'), isA<DialogRoute<dynamic>>());
    });
  });

  testWidgets('iOS NavAni.Right is a Cupertino route with the options',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await pumpHome(tester);
      Nav.push(const Text('next'),
          settings: const RouteSettings(name: '/ios'), fullscreenDialog: true);
      await tester.pumpAndSettle();
      final route = routeOf(tester, 'next');
      expect(route, isA<CupertinoPageRoute<dynamic>>());
      expect(route.settings.name, '/ios');
      expect((route as PageRoute<dynamic>).fullscreenDialog, isTrue);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Nav.pushRoute pushes a route you built and returns its result',
      (tester) async {
    await pumpHome(tester);
    final result = Nav.pushRoute<String>(MaterialPageRoute<String>(
        settings: const RouteSettings(name: '/custom'),
        builder: (_) => const Text('custom')));
    await tester.pumpAndSettle();
    expect(routeOf(tester, 'custom').settings.name, '/custom');
    Nav.pop(tester.element(find.text('custom')), result: 'done');
    await tester.pumpAndSettle();
    expect(await result, 'done');
  });

  group('NavPath', () {
    final delegate = NavPathDelegate([
      NavPath('/item/:id', (p) => Text('item ${p['id']}'),
          navAni: NavAni.platform, fullscreenDialog: true),
      NavPath('/sheet', (p) => const Text('sheet'),
          navAni: NavAni.Bottom, opaque: false, reverseDurationMs: 40),
    ]);

    testWidgets('open names the route with the link and uses the options',
        (tester) async {
      await pumpHome(tester);
      delegate.open<void>(Uri.parse('/item/3?x=1'));
      await tester.pumpAndSettle();
      final item = routeOf(tester, 'item 3') as PageRoute<dynamic>;
      expect(item, isA<MaterialPageRoute<dynamic>>());
      expect(item.settings.name, '/item/3?x=1');
      expect(item.fullscreenDialog, isTrue);

      delegate.open<void>(Uri.parse('/sheet'));
      await tester.pumpAndSettle();
      final sheet = routeOf(tester, 'sheet') as PageRoute<dynamic>;
      expect(sheet.opaque, isFalse);
      expect(sheet.reverseTransitionDuration, const Duration(milliseconds: 40));
    });

    testWidgets('onGenerateRoute keeps the engine\'s settings', (tester) async {
      await pumpHome(tester);
      final route = delegate.onGenerateRoute(
          const RouteSettings(name: '/sheet', arguments: 'a'))!;
      expect(route.settings.name, '/sheet');
      expect(route.settings.arguments, 'a');
      expect((route as PageRoute<dynamic>).opaque, isFalse);
    });
  });
}

Widget _pages(List<Page<dynamic>> pages) => MaterialApp(
      home: Navigator(pages: pages, onDidRemovePage: (_) {}),
    );

void navPageTests() {
  group('NavPage options', () {
    testWidgets('NavAni.platform is a Material transition', (tester) async {
      await tester.pumpWidget(_pages(const [
        NavPage<void>(key: ValueKey('home'), child: Text('home')),
        NavPage<void>(
            key: ValueKey('p'),
            name: '/p',
            navAni: NavAni.platform,
            fullscreenDialog: true,
            child: Text('platform')),
      ]));
      await tester.pumpAndSettle();
      final route = routeOf(tester, 'platform');
      expect(route, isA<MaterialRouteTransitionMixin<dynamic>>());
      expect(route.settings.name, '/p');
      expect((route as PageRoute<dynamic>).fullscreenDialog, isTrue);
    });

    testWidgets('opaque, fullscreenDialog and reverseDurationMs',
        (tester) async {
      await tester.pumpWidget(_pages(const [
        NavPage<void>(key: ValueKey('home'), child: Text('home')),
        NavPage<void>(
            key: ValueKey('o'),
            navAni: NavAni.Bottom,
            opaque: false,
            fullscreenDialog: true,
            durationMs: 300,
            reverseDurationMs: 60,
            curve: Curves.easeIn,
            child: Text('over')),
      ]));
      await tester.pumpAndSettle();
      final route = routeOf(tester, 'over') as PageRoute<dynamic>;
      expect(route.opaque, isFalse);
      expect(route.fullscreenDialog, isTrue);
      expect(route.transitionDuration, const Duration(milliseconds: 300));
      expect(route.reverseTransitionDuration, const Duration(milliseconds: 60));
      expect(find.text('home'), findsOneWidget);
    });
  });
}

class _ResultScreen extends StatelessWidget with NavScreen<int> {
  const _ResultScreen();

  @override
  Widget build(BuildContext context) => const Text('result');
}

class _Dialog extends DialogWidget<void> {
  _Dialog({super.animation});

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends DialogState<_Dialog> {
  @override
  Widget build(BuildContext context) => const Text('dialog');
}

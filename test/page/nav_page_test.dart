import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nav/nav.dart';

/// A Navigator 2.0 app whose page stack is [pages].
class PagesApp extends StatefulWidget {
  const PagesApp(this.pages, {super.key});

  final List<Page<dynamic>> pages;

  @override
  State<PagesApp> createState() => PagesAppState();
}

class PagesAppState extends State<PagesApp> {
  late List<Page<dynamic>> pages = [...widget.pages];

  void setPages(List<Page<dynamic>> pages) =>
      setState(() => this.pages = pages);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        pages: pages,
        onDidRemovePage: (page) =>
            setState(() => pages = [...pages]..remove(page)),
      ),
    );
  }
}

const home = NavPage<void>(key: ValueKey('home'), child: Text('home'));

Route<dynamic> routeOf(WidgetTester tester, String text) =>
    ModalRoute.of(tester.element(find.text(text)))!;

void main() {
  PagesAppState stateOf(WidgetTester tester) =>
      tester.state<PagesAppState>(find.byType(PagesApp));

  group('NavPage in Navigator.pages', () {
    for (final navAni in NavAni.values) {
      testWidgets('$navAni pushes and pops', (tester) async {
        await tester.pumpWidget(const PagesApp([home]));
        stateOf(tester).setPages([
          home,
          NavPage<void>(
              key: const ValueKey('next'),
              navAni: navAni,
              child: const Text('next')),
        ]);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('next'), findsOneWidget);
        await tester.pumpAndSettle();

        final route = routeOf(tester, 'next');
        expect(route.settings, isA<NavPage<void>>());
        expect((route as PageRoute).debugLabel, contains('PageRoute'));

        Navigator.of(tester.element(find.text('next'))).pop();
        await tester.pumpAndSettle();
        expect(find.text('next'), findsNothing);
        expect(stateOf(tester).pages, [home]);
      });
    }

    testWidgets('Blink has no transition', (tester) async {
      await tester.pumpWidget(const PagesApp([home]));
      stateOf(tester).setPages([
        home,
        const NavPage<void>(navAni: NavAni.blink, child: Text('next')),
      ]);
      await tester.pump();
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
      expect(find.text('next'), findsOneWidget);
    });

    testWidgets('a page replaced with the same key shows its new child',
        (tester) async {
      await tester.pumpWidget(const PagesApp([
        NavPage<void>(key: ValueKey('a'), child: Text('first')),
      ]));
      final route = routeOf(tester, 'first');

      stateOf(tester).setPages([
        const NavPage<void>(key: ValueKey('a'), child: Text('second')),
      ]);
      await tester.pumpAndSettle();
      expect(find.text('second'), findsOneWidget);
      expect(routeOf(tester, 'second'), same(route));
    });

    testWidgets('maintainState is taken from the page', (tester) async {
      await tester.pumpWidget(const PagesApp([
        NavPage<void>(maintainState: false, child: Text('page')),
      ]));
      expect((routeOf(tester, 'page') as PageRoute).maintainState, isFalse);
    });
  });

  group('NavPage on iOS', () {
    final iOS = TargetPlatformVariant.only(TargetPlatform.iOS);

    testWidgets('Right is a Cupertino route with swipe back', (tester) async {
      await tester.pumpWidget(const PagesApp([
        NavPage<void>(name: 'swipe', maintainState: false, child: Text('page')),
      ]));
      final route = routeOf(tester, 'page') as PageRoute;
      expect(route, isA<CupertinoRouteTransitionMixin>());
      expect((route as CupertinoRouteTransitionMixin).title, isNull);
      expect(route.maintainState, isFalse);
      expect(route.debugLabel, contains('swipe'));
    }, variant: iOS);

    testWidgets('prohibitSwipeBack opts out', (tester) async {
      await tester.pumpWidget(const PagesApp([
        NavPage<void>(prohibitSwipeBack: true, child: Text('page')),
      ]));
      expect(
          routeOf(tester, 'page'), isNot(isA<CupertinoRouteTransitionMixin>()));
    }, variant: iOS);

    testWidgets('other animations ignore the platform', (tester) async {
      await tester.pumpWidget(const PagesApp([
        NavPage<void>(navAni: NavAni.fade, child: Text('page')),
      ]));
      expect(
          routeOf(tester, 'page'), isNot(isA<CupertinoRouteTransitionMixin>()));
    }, variant: iOS);
  });

  group('with go_router', () {
    late GoRouter router;
    final navigatorKey = GlobalKey<NavigatorState>();

    Future<void> pumpRouter(WidgetTester tester) async {
      router = GoRouter(
        navigatorKey: navigatorKey,
        routes: [
          GoRoute(path: '/', builder: (context, state) => const Text('home')),
          GoRoute(
            path: '/product/:id',
            pageBuilder: (context, state) => NavPage<void>(
              key: state.pageKey,
              navAni: NavAni.fade,
              child: Text('product ${state.pathParameters['id']}'),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      Nav.init(navigatorKey);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    }

    testWidgets('pageBuilder can return a NavPage', (tester) async {
      await pumpRouter(tester);
      router.push('/product/7');
      await tester.pumpAndSettle();
      expect(find.text('product 7'), findsOneWidget);
      expect(routeOf(tester, 'product 7').settings, isA<NavPage<void>>());

      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('Nav.push works on top of go_router pages', (tester) async {
      await pumpRouter(tester);
      router.go('/product/1');
      await tester.pumpAndSettle();

      final result = Nav.push<String>(const Text('pushed'), navAni: NavAni.top);
      await tester.pumpAndSettle();
      expect(find.text('pushed'), findsOneWidget);
      expect(Nav.canPop(), isTrue);

      Nav.pop(tester.element(find.text('pushed')), result: 'done');
      await tester.pumpAndSettle();
      expect(await result, 'done');
      expect(find.text('product 1'), findsOneWidget);
    });
  });
}

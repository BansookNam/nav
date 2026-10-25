import 'package:example/deep_link/deep_link_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/nav.dart';

/// The main sample's routing, without its demo home screen.
class DeepLinkHarness extends StatefulWidget {
  const DeepLinkHarness({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<DeepLinkHarness> createState() => _DeepLinkHarnessState();
}

class _DeepLinkHarnessState extends State<DeepLinkHarness> with Nav {
  @override
  GlobalKey<NavigatorState> get navigatorKey => DeepLinkHarness.navigatorKey;

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        home: const Text('home'),
        onGenerateRoute: deepLinkPaths.onGenerateRoute,
        onUnknownRoute: deepLinkPaths.onUnknownRoute,
      );
}

void main() {
  group('opensInApp', () {
    final cases = {
      'https://nav.example.com/product/42': true,
      'https://nav.example.com/nowhere': true, // claimed domain, unknown path
      'navexample://open/product/7': true,
      'http://nav.example.com/product/42': false, // App Links are https only
      'https://other.example.com/product/42': false,
      'navexample://elsewhere/product/7': false,
      'https://flutter.dev': false,
    };
    cases.forEach((link, expected) {
      test('$link → $expected', () {
        expect(opensInApp(Uri.parse(link)), expected);
      });
    });
  });

  test('routeNameOf drops scheme and host like the engine does', () {
    expect(
        routeNameOf(Uri.parse('https://nav.example.com/product/42?color=blue')),
        '/product/42?color=blue');
    expect(routeNameOf(Uri.parse('navexample://open/user/nam#top')),
        '/user/nam#top');
    expect(routeNameOf(Uri.parse('https://nav.example.com')), '/');
  });

  group('simulateOsLink', () {
    testWidgets('an App Link opens the product with its parameters',
        (tester) async {
      await tester.pumpWidget(const DeepLinkHarness());
      simulateOsLink(
          Uri.parse('https://nav.example.com/product/42?color=blue'));
      await tester.pumpAndSettle();

      expect(find.byType(ProductScreen), findsOneWidget);
      expect(find.text('Path parameters: {id: 42}'), findsOneWidget);
      expect(find.text('Query parameters: {color: blue}'), findsOneWidget);
    });

    testWidgets('a custom-scheme link opens the same way', (tester) async {
      await tester.pumpWidget(const DeepLinkHarness());
      simulateOsLink(Uri.parse('navexample://open/user/nam'));
      await tester.pumpAndSettle();
      expect(find.text('Path parameters: {name: nam}'), findsOneWidget);
    });

    testWidgets('an unmatched link opens the unknown screen', (tester) async {
      await tester.pumpWidget(const DeepLinkHarness());
      simulateOsLink(Uri.parse('https://nav.example.com/nowhere'));
      await tester.pumpAndSettle();
      expect(find.text('Path parameters: {}'), findsOneWidget);
      expect(find.text('/nowhere'), findsOneWidget); // AppBar title
    });
  });
}

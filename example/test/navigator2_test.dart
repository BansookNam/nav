import 'package:example/navigator2/go_router_app.dart';
import 'package:example/navigator2/pages_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/nav.dart';

void main() {
  group('PagesDemo (Navigator.pages)', () {
    Future<void> pumpDemo(WidgetTester tester) =>
        tester.pumpWidget(const MaterialApp(home: PagesDemo()));

    testWidgets('selecting, updating in place and popping pages',
        (tester) async {
      await pumpDemo(tester);
      await tester.tap(find.text('Tea'));
      await tester.pumpAndSettle();
      expect(find.text('Tea'), findsNWidgets(2)); // AppBar + headline
      final productRoute =
          ModalRoute.of(tester.element(find.text('Next product')));

      // Same page key: the existing route shows the next product.
      await tester.tap(find.text('Next product'));
      await tester.pumpAndSettle();
      expect(find.text('Juice'), findsNWidgets(2));
      expect(ModalRoute.of(tester.element(find.text('Next product'))),
          same(productRoute));

      await tester.tap(find.text('Reviews'));
      await tester.pumpAndSettle();
      expect(find.text('Juice reviews'), findsOneWidget);

      // AppBar back: onDidRemovePage clears the reviews flag.
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Juice reviews'), findsNothing);
      expect(find.text('Next product'), findsOneWidget);

      // System back reaches the nested Navigator through NavigatorPopHandler.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Navigator.pages'), findsOneWidget);
      expect(find.text('Next product'), findsNothing);
    });
  });

  group('GoRouterApp (go_router + NavPage)', () {
    testWidgets('router pages use NavPage', (tester) async {
      await tester.pumpWidget(const GoRouterApp());
      await tester.tap(find.text('context.push(/product/42?color=blue)'));
      await tester.pumpAndSettle();
      expect(find.text('Product 42, color: blue'), findsOneWidget);
      expect(
          ModalRoute.of(tester.element(find.text('Product 42, color: blue')))!
              .settings,
          isA<NavPage<void>>());

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('context.push(/user/nam)'));
      await tester.pumpAndSettle();
      expect(find.text('User nam'), findsOneWidget);
    });

    testWidgets('unknown locations use errorPageBuilder', (tester) async {
      await tester.pumpWidget(const GoRouterApp());
      await tester.tap(find.text('context.go(/nowhere)'));
      await tester.pumpAndSettle();
      expect(find.text('No route for /nowhere'), findsOneWidget);
    });

    testWidgets('Nav.push and Nav dialogs work on top of the router',
        (tester) async {
      await tester.pumpWidget(const GoRouterApp());
      await tester.tap(find.text('Nav.push on top of the router'));
      await tester.pumpAndSettle();
      expect(find.text('Pushed by Nav'), findsOneWidget);
      expect(Nav.canPop(), isTrue);

      await tester.tap(find.text('Pop with a result'));
      await tester.pumpAndSettle();
      expect(find.text('Nav + go_router'), findsOneWidget);

      await tester.tap(find.text('Nav dialog on top of the router'));
      await tester.pumpAndSettle();
      expect(find.text('Shown with DialogWidget'), findsOneWidget);
      await tester.tap(find.text('Shown with DialogWidget'));
      await tester.pumpAndSettle();
      expect(find.text('Shown with DialogWidget'), findsNothing);
    });

    testWidgets('a deep link from the OS is routed by go_router',
        (tester) async {
      await tester.pumpWidget(const GoRouterApp());
      // What the engine sends for navexample://open/product/42?color=blue.
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/navigation',
        const JSONMethodCodec().encodeMethodCall(const MethodCall(
            'pushRouteInformation', {'location': '/product/42?color=blue'})),
        (_) {},
      );
      await tester.pumpAndSettle();
      expect(find.text('Product 42, color: blue'), findsOneWidget);
    });
  });
}

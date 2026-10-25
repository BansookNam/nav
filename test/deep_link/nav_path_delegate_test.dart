import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/nav.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.params, {super.key});

  final NavPathParams params;

  @override
  Widget build(BuildContext context) =>
      Text('product ${params.getInt('id')} ${params['tab']}');
}

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) => const Text('products');
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen(this.uri, {super.key});

  final Uri uri;

  @override
  Widget build(BuildContext context) => Text('not found ${uri.path}');
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const Text('home');
}

final paths = NavPathDelegate([
  NavPath('/product', (params) => const ProductListScreen()),
  NavPath('/product/:id', (params) => ProductScreen(params)),
  NavPath('/ripple/:id', (params) => ProductScreen(params),
      navAni: NavAni.ripple),
]);

final pathsWithUnknown = NavPathDelegate(paths.paths,
    unknown: (params) => NotFoundScreen(params.uri));

class DeepLinkApp extends StatefulWidget {
  const DeepLinkApp(this.delegate, {super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  final NavPathDelegate delegate;

  @override
  State<DeepLinkApp> createState() => _DeepLinkAppState();
}

class _DeepLinkAppState extends State<DeepLinkApp> with Nav {
  @override
  GlobalKey<NavigatorState> get navigatorKey => DeepLinkApp.navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const HomeScreen(),
      onGenerateRoute: widget.delegate.onGenerateRoute,
      onUnknownRoute: widget.delegate.onUnknownRoute,
    );
  }
}

/// Delivers [link] the way the engine does when the OS opens the app with it.
Future<void> receiveLink(WidgetTester tester, String link) async {
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'flutter/navigation',
    const JSONMethodCodec().encodeMethodCall(
        MethodCall('pushRouteInformation', {'location': link})),
    (_) {},
  );
  await tester.pumpAndSettle();
}

void main() {
  group('NavPath.match', () {
    test('captures named segments', () {
      final path = NavPath('/user/:name/post/:id', (_) => const SizedBox());
      expect(path.match(Uri.parse('/user/nam/post/3')),
          {'name': 'nam', 'id': '3'});
    });

    test('ignores scheme, host, query, fragment and trailing slashes', () {
      final path = NavPath('/product/:id', (_) => const SizedBox());
      expect(path.match(Uri.parse('https://example.com/product/42/?a=1#top')),
          {'id': '42'});
      expect(path.match(Uri.parse('myapp://app/product/42')), {'id': '42'});
    });

    test('decodes percent-encoded segments', () {
      final path = NavPath('/tag/:name', (_) => const SizedBox());
      expect(
          path.match(Uri.parse('/tag/hello%20world')), {'name': 'hello world'});
    });

    test('rejects other lengths and literals', () {
      final path = NavPath('/product/:id', (_) => const SizedBox());
      expect(path.match(Uri.parse('/product')), isNull);
      expect(path.match(Uri.parse('/product/1/extra')), isNull);
      expect(path.match(Uri.parse('/user/1')), isNull);
    });

    test('root pattern matches only the root', () {
      final path = NavPath('/', (_) => const SizedBox());
      expect(path.match(Uri.parse('https://example.com')), isEmpty);
      expect(path.match(Uri.parse('/')), isEmpty);
      expect(path.match(Uri.parse('/a')), isNull);
    });

    test('toString names the pattern', () {
      expect(NavPath('/a', (_) => const SizedBox()).toString(), 'NavPath(/a)');
    });
  });

  group('NavPathParams', () {
    final params = NavPathParams(
      uri: Uri.parse('/p/7?id=9&ratio=0.5&on=true&off=0&bad=x&t=a&t=b'),
      pathParameters: const {'id': '7'},
    );

    test('path parameters shadow query parameters', () {
      expect(params['id'], '7');
      expect(params['ratio'], '0.5');
      expect(params['missing'], isNull);
    });

    test('typed getters', () {
      expect(params.getInt('id'), 7);
      expect(params.getInt('bad'), isNull);
      expect(params.getInt('missing'), isNull);
      expect(params.getDouble('ratio'), 0.5);
      expect(params.getDouble('missing'), isNull);
      expect(params.getBool('on'), isTrue);
      expect(params.getBool('off'), isFalse);
      expect(params.getBool('bad'), isNull);
    });

    test('repeated query keys', () {
      expect(params.queryParameters['t'], 'b');
      expect(params.queryParametersAll['t'], ['a', 'b']);
    });

    test('toString', () {
      expect(params.toString(), contains('path: {id: 7}'));
    });
  });

  group('NavPathDelegate.match', () {
    test('first matching path wins and receives arguments', () {
      final matched = paths.match(Uri.parse('/product/5'), arguments: 'extra');
      expect(matched!.path.pattern, '/product/:id');
      expect(matched.params.pathParameters, {'id': '5'});
      expect(matched.params.arguments, 'extra');
      expect(paths.canOpen(Uri.parse('/product/5')), isTrue);
      expect(paths.canOpen(Uri.parse('/nothing')), isFalse);
    });

    test('route factories ignore unparsable and unmatched names', () {
      expect(paths.onGenerateRoute(const RouteSettings()), isNull);
      expect(
          paths.onGenerateRoute(const RouteSettings(name: '/nothing')), isNull);
      expect(
          paths.onUnknownRoute(const RouteSettings(name: '/nothing')), isNull);
      expect(pathsWithUnknown.onUnknownRoute(const RouteSettings()), isNull);
    });
  });

  group('deep links', () {
    testWidgets('a link received while running opens its screen',
        (tester) async {
      await tester.pumpWidget(DeepLinkApp(paths));
      await receiveLink(tester, 'https://example.com/product/42?tab=reviews');

      expect(find.text('product 42 reviews'), findsOneWidget);
      Nav.pop(tester.element(find.byType(ProductScreen)));
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('the launch link is stacked over its matching prefixes',
        (tester) async {
      tester.platformDispatcher.defaultRouteNameTestValue =
          '/product/42?tab=info';
      addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);

      await tester.pumpWidget(DeepLinkApp(paths));
      expect(find.text('product 42 info'), findsOneWidget);

      Nav.pop(tester.element(find.byType(ProductScreen)));
      await tester.pumpAndSettle();
      expect(find.text('products'), findsOneWidget);

      Nav.pop(tester.element(find.byType(ProductListScreen)));
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('a ripple path can be the launch link', (tester) async {
      tester.platformDispatcher.defaultRouteNameTestValue = '/ripple/3';
      addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);

      await tester.pumpWidget(DeepLinkApp(paths));
      await tester.pumpAndSettle();
      expect(find.text('product 3 null'), findsOneWidget);
    });

    testWidgets('an unmatched link opens the unknown screen', (tester) async {
      await tester.pumpWidget(DeepLinkApp(pathsWithUnknown));
      await receiveLink(tester, '/nowhere');
      expect(find.text('not found /nowhere'), findsOneWidget);
    });

    testWidgets('an unmatched launch link falls back to home', (tester) async {
      tester.platformDispatcher.defaultRouteNameTestValue = '/nowhere';
      addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);

      await tester.pumpWidget(DeepLinkApp(pathsWithUnknown));
      await tester.pumpAndSettle();
      // Flutter reports the unmatched initial route in debug builds.
      expect(tester.takeException(), contains('Could not navigate'));
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('pushNamed goes through the delegate with arguments',
        (tester) async {
      await tester.pumpWidget(DeepLinkApp(paths));
      DeepLinkApp.navigatorKey.currentState!.pushNamed('/product/8');
      await tester.pumpAndSettle();
      expect(find.text('product 8 null'), findsOneWidget);
    });
  });

  group('NavPathDelegate.open', () {
    testWidgets('pushes the matched screen and returns its result',
        (tester) async {
      await tester.pumpWidget(DeepLinkApp(paths));
      final result = paths.open<String>(Uri.parse('myapp://x/product/1'));
      await tester.pumpAndSettle();
      expect(find.text('product 1 null'), findsOneWidget);

      Nav.pop(tester.element(find.byType(ProductScreen)), result: 'done');
      expect(await result, 'done');
    });

    testWidgets('falls back to unknown', (tester) async {
      await tester.pumpWidget(DeepLinkApp(pathsWithUnknown));
      pathsWithUnknown.open(Uri.parse('/missing'));
      await tester.pumpAndSettle();
      expect(find.text('not found /missing'), findsOneWidget);
    });

    testWidgets('does nothing for an unmatched link without unknown',
        (tester) async {
      await tester.pumpWidget(DeepLinkApp(paths));
      expect(await paths.open(Uri.parse('/missing')), isNull);
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
    });
  });
}

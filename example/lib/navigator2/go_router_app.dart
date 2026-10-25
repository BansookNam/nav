import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nav/nav.dart';

import '../dialog/message_dialog.dart';

/// The router's navigator key, shared with Nav so `Nav.push`, dialogs and
/// bottom sheets work on top of go_router's pages.
final goRouterNavigatorKey = GlobalKey<NavigatorState>();

/// go_router with Nav's transitions on every page.
///
/// go_router also receives App Links / Universal Links / custom-scheme links
/// on its own (with FlutterDeepLinkingEnabled / flutter_deeplinking_enabled),
/// so `navexample://open/product/42?color=blue` opens [GoProductPage] here
/// without NavPathDelegate.
GoRouter createGoRouter() => GoRouter(
      navigatorKey: goRouterNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NavPage<void>(
            key: state.pageKey,
            navAni: NavAni.fade,
            child: const GoHomePage(),
          ),
          routes: [
            GoRoute(
              path: 'product/:id',
              pageBuilder: (context, state) => NavPage<void>(
                key: state.pageKey,
                child: GoProductPage(
                  id: state.pathParameters['id']!,
                  color: state.uri.queryParameters['color'],
                ),
              ),
            ),
            GoRoute(
              path: 'user/:name',
              pageBuilder: (context, state) => NavPage<void>(
                key: state.pageKey,
                navAni: NavAni.top,
                child: GoUserPage(name: state.pathParameters['name']!),
              ),
            ),
          ],
        ),
      ],
      errorPageBuilder: (context, state) => NavPage<void>(
        key: state.pageKey,
        child: Scaffold(
          appBar: AppBar(title: const Text('Not found')),
          body: Center(child: Text('No route for ${state.uri}')),
        ),
      ),
    );

class GoRouterApp extends StatefulWidget {
  const GoRouterApp({super.key});

  @override
  State<GoRouterApp> createState() => _GoRouterAppState();
}

class _GoRouterAppState extends State<GoRouterApp> {
  late final GoRouter _router = createGoRouter();

  @override
  void initState() {
    super.initState();
    Nav.init(goRouterNavigatorKey);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nav + go_router',
      routerConfig: _router,
    );
  }
}

class GoHomePage extends StatelessWidget {
  const GoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nav + go_router')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('context.push(/product/42?color=blue)'),
            subtitle: const Text('NavPage, NavAni.right'),
            onTap: () => context.push('/product/42?color=blue'),
          ),
          ListTile(
            title: const Text('context.push(/user/nam)'),
            subtitle: const Text('NavPage, NavAni.top'),
            onTap: () => context.push('/user/nam'),
          ),
          ListTile(
            title: const Text('context.go(/nowhere)'),
            subtitle: const Text('errorPageBuilder'),
            onTap: () => context.go('/nowhere'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Nav.push on top of the router'),
            subtitle: const Text('Imperative, NavAni.bottom'),
            onTap: () =>
                Nav.push(const ImperativePage(), navAni: NavAni.bottom),
          ),
          ListTile(
            title: const Text('Nav dialog on top of the router'),
            onTap: () => MessageDialog('Shown with DialogWidget').show(),
          ),
        ],
      ),
    );
  }
}

class GoProductPage extends StatelessWidget {
  const GoProductPage({super.key, required this.id, this.color});

  final String id;
  final String? color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product $id')),
      body: Center(child: Text('Product $id, color: ${color ?? '-'}')),
    );
  }
}

class GoUserPage extends StatelessWidget {
  const GoUserPage({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(child: Text('User $name')),
    );
  }
}

/// Pushed with `Nav.push`, not by the router: it sits on top of the current
/// page and returns a result like any Nav route.
class ImperativePage extends StatelessWidget {
  const ImperativePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pushed by Nav')),
      body: Center(
        child: FilledButton(
          onPressed: () => Nav.pop(context, result: 'from ImperativePage'),
          child: const Text('Pop with a result'),
        ),
      ),
    );
  }
}

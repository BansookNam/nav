import 'package:flutter/widgets.dart';
import 'package:nav/src/deep_link/nav_path.dart';
import 'package:nav/src/enum/enum_nav_ani.dart';
import 'package:nav/src/nav_base.dart';

/// A [NavPath] that matched a link, with the parameters parsed from it.
class NavPathMatch {
  const NavPathMatch(this.path, this.params);

  final NavPath path;
  final NavPathParams params;

  Widget buildScreen() => path.builder(params);
}

/// Turns links (App Links, Universal Links, custom schemes or plain paths)
/// into screens.
///
/// Register it on your app, and Flutter's built-in deep linking will open
/// matched links — both the one that launched the app and the ones that
/// arrive while it is running:
///
/// ```dart
/// final paths = NavPathDelegate([
///   NavPath('/product/:id', (p) => ProductScreen(id: p.getInt('id')!)),
///   NavPath('/user/:name', (p) => UserScreen(name: p['name']!)),
/// ], unknown: (p) => NotFoundScreen(uri: p.uri));
///
/// MaterialApp(
///   navigatorKey: navigatorKey,
///   home: const HomeScreen(),
///   onGenerateRoute: paths.onGenerateRoute,
///   onUnknownRoute: paths.onUnknownRoute,
/// );
/// ```
///
/// Links received some other way (a push notification, a plugin such as
/// `app_links`, an in-app button) are opened with [open].
///
/// Paths are tried in the order given; the first match wins.
class NavPathDelegate {
  NavPathDelegate(List<NavPath> paths, {this.unknown})
      : paths = List.unmodifiable(paths);

  final List<NavPath> paths;

  /// Builds the screen for a link that matches no path. When null, unmatched
  /// links are ignored.
  final NavPathBuilder? unknown;

  /// The first path matching [uri], with its parsed parameters.
  NavPathMatch? match(Uri uri, {Object? arguments}) {
    for (final path in paths) {
      final parameters = path.match(uri);
      if (parameters != null) {
        return NavPathMatch(
          path,
          NavPathParams(
            uri: uri,
            pathParameters: parameters,
            arguments: arguments,
          ),
        );
      }
    }
    return null;
  }

  /// Whether [uri] matches one of [paths].
  bool canOpen(Uri uri) => match(uri) != null;

  /// Pushes the screen for [uri].
  ///
  /// Falls back to [unknown] when no path matches. Returns null without
  /// navigating when neither applies — check [canOpen] first if you need to
  /// tell that apart from a screen that popped without a result.
  ///
  /// If you provide context, you can nest navigate in your specific context
  Future<T?> open<T>(Uri uri, {BuildContext? context}) async {
    final matched = match(uri);
    if (matched != null) {
      final navigator = Nav.navigatorState(context);
      if (navigator == null) return null;
      return navigator.push(matched.path.createRoute<T>(
          matched.buildScreen(), RouteSettings(name: uri.toString()),
          context: navigator.context));
    }
    final unknown = this.unknown;
    if (unknown != null) {
      return Nav.push<T>(unknown(NavPathParams(uri: uri)),
          context: context, settings: RouteSettings(name: uri.toString()));
    }
    return null;
  }

  /// For `MaterialApp.onGenerateRoute`.
  ///
  /// Flutter passes every incoming deep link here as a route name such as
  /// `/product/42?tab=reviews`, and `Navigator.pushNamed` does the same.
  ///
  /// For the link that launched the app, Flutter also asks for each prefix of
  /// the path (`/`, `/product`, `/product/42`) and stacks every one that
  /// matches, so back from a launch link lands on the screens above it — or on
  /// `home` when none match.
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final uri = _parse(settings.name);
    if (uri == null) {
      return null;
    }
    final matched = match(uri, arguments: settings.arguments);
    if (matched == null) {
      return null;
    }
    return matched.path.createRoute<dynamic>(matched.buildScreen(), settings);
  }

  /// For `MaterialApp.onUnknownRoute`: builds [unknown] for a link that no
  /// path matched.
  Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    final unknown = this.unknown;
    final uri = _parse(settings.name);
    if (unknown == null || uri == null) {
      return null;
    }
    return NavAni.Right.createRoute<dynamic>(
        unknown(NavPathParams(uri: uri, arguments: settings.arguments)),
        null,
        Nav.defaultDurationMs,
        settings: settings);
  }

  static Uri? _parse(String? name) => name == null ? null : Uri.tryParse(name);
}

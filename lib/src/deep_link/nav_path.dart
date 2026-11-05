import 'package:flutter/widgets.dart';
import 'package:nav/src/enum/enum_nav_ani.dart';
import 'package:nav/src/nav_base.dart';

/// Builds the screen for a matched [NavPath].
typedef NavPathBuilder = Widget Function(NavPathParams params);

/// The values parsed out of a link that matched a [NavPath].
///
/// ```dart
/// // NavPath('/product/:id', ...) matched by
/// // https://example.com/product/42?tab=reviews
/// params.pathParameters;  // {id: 42}
/// params.queryParameters; // {tab: reviews}
/// params['id'];           // '42'
/// params.getInt('id');    // 42
/// ```
class NavPathParams {
  const NavPathParams({
    required this.uri,
    this.pathParameters = const {},
    this.arguments,
  });

  /// The link that was opened.
  final Uri uri;

  /// Values captured by the `:name` segments of the pattern.
  final Map<String, String> pathParameters;

  /// Arguments passed with `Navigator.pushNamed`, if any.
  ///
  /// Always null for links opened from outside the app.
  final Object? arguments;

  /// Query string values of [uri]. For repeated keys, the last value wins.
  Map<String, String> get queryParameters => uri.queryParameters;

  /// Query string values of [uri], keeping every value of a repeated key.
  Map<String, List<String>> get queryParametersAll => uri.queryParametersAll;

  /// A path parameter, or a query parameter when no path parameter has
  /// that name.
  String? operator [](String key) =>
      pathParameters[key] ?? queryParameters[key];

  /// [this[key]] parsed as an int, or null when absent or not an int.
  int? getInt(String key) {
    final value = this[key];
    return value == null ? null : int.tryParse(value);
  }

  /// [this[key]] parsed as a double, or null when absent or not a number.
  double? getDouble(String key) {
    final value = this[key];
    return value == null ? null : double.tryParse(value);
  }

  /// [this[key]] parsed as a bool (`true`/`false`, `1`/`0`), or null.
  bool? getBool(String key) {
    switch (this[key]?.toLowerCase()) {
      case 'true' || '1':
        return true;
      case 'false' || '0':
        return false;
      default:
        return null;
    }
  }

  @override
  String toString() =>
      'NavPathParams($uri, path: $pathParameters, query: $queryParameters)';
}

/// A link pattern and the screen it opens.
///
/// A pattern is a `/`-separated path. A segment starting with `:` captures
/// that part of the link into [NavPathParams.pathParameters]; every other
/// segment must match exactly.
///
/// ```dart
/// NavPath('/product/:id', (params) => ProductScreen(id: params.getInt('id')!))
/// ```
class NavPath {
  NavPath(
    this.pattern,
    this.builder, {
    this.navAni = NavAni.Right,
    this.durationMs = Nav.defaultDurationMs,
    this.reverseDurationMs,
    this.curve = Curves.linear,
    this.fullscreenDialog = false,
    this.opaque = true,
    this.maintainState = true,
  })  : assert(pattern.startsWith('/'), 'NavPath pattern must start with "/"'),
        _segments = _split(pattern);

  /// The pattern this path matches, e.g. `/product/:id`.
  final String pattern;

  /// Builds the screen from the parsed link.
  final NavPathBuilder builder;

  /// The transition used when this path is pushed.
  final NavAni navAni;

  final int durationMs;

  /// Closing time; null: [durationMs]. These and the options below are the
  /// same as [Nav.push]'s.
  final int? reverseDurationMs;

  final Curve curve;

  final bool fullscreenDialog;

  final bool opaque;

  final bool maintainState;

  /// The route [screen] is shown with, named by [settings].
  Route<T> createRoute<T>(Widget screen, RouteSettings? settings,
          {BuildContext? context}) =>
      navAni.createRoute<T>(screen, context, durationMs,
          reverseDurationMs: reverseDurationMs,
          curve: curve,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
          opaque: opaque,
          maintainState: maintainState);

  final List<String> _segments;

  static List<String> _split(String path) =>
      path.split('/').where((segment) => segment.isNotEmpty).toList();

  /// The path parameters captured from [uri], or null when [uri] does not
  /// match this pattern.
  ///
  /// Only the path of [uri] is compared. Scheme, host, query and fragment are
  /// ignored, so `https://example.com/product/42` and `/product/42` match
  /// alike.
  Map<String, String>? match(Uri uri) {
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.length != _segments.length) {
      return null;
    }
    final parameters = <String, String>{};
    for (var i = 0; i < _segments.length; i++) {
      final expected = _segments[i];
      if (expected.startsWith(':')) {
        parameters[expected.substring(1)] = segments[i];
      } else if (expected != segments[i]) {
        return null;
      }
    }
    return parameters;
  }

  @override
  String toString() => 'NavPath($pattern)';
}

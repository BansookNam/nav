import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nav/src/enum/enum_nav_ani.dart';
import 'package:nav/src/nav_base.dart';
import 'package:nav/src/route/clipper_circle.dart';
import 'package:nav/src/route/nav_transitions.dart';

/// A [Page] that shows [child] with one of Nav's [NavAni] transitions.
///
/// Use it wherever Navigator 2.0 takes pages: `Navigator.pages`, or the
/// `pageBuilder` of a router such as go_router.
///
/// ```dart
/// GoRoute(
///   path: '/product/:id',
///   pageBuilder: (context, state) => NavPage(
///     key: state.pageKey,
///     navAni: NavAni.fade,
///     child: ProductScreen(id: state.pathParameters['id']!),
///   ),
/// )
/// ```
///
/// [NavAni.Right] behaves like [Nav.pushFromRight]: on iOS it is a Cupertino
/// route with the swipe-back gesture, unless [prohibitSwipeBack] is true.
class NavPage<T> extends Page<T> {
  const NavPage({
    required this.child,
    this.navAni = NavAni.Right,
    this.durationMs = Nav.defaultDurationMs,
    this.prohibitSwipeBack = false,
    this.maintainState = true,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  /// The screen this page shows.
  final Widget child;

  /// The transition used when this page enters and leaves.
  final NavAni navAni;

  final int durationMs;

  /// Whether to disable the iOS swipe-back gesture for [NavAni.Right].
  final bool prohibitSwipeBack;

  final bool maintainState;

  @override
  Route<T> createRoute(BuildContext context) {
    if (navAni == NavAni.Right &&
        defaultTargetPlatform == TargetPlatform.iOS &&
        !prohibitSwipeBack) {
      return _NavCupertinoPageRoute<T>(this);
    }
    return _NavPageRoute<T>(this);
  }
}

/// Reads everything from its page on each build, so a page replaced with
/// the same key shows the new [NavPage.child].
class _NavPageRoute<T> extends PageRoute<T> {
  _NavPageRoute(NavPage<T> page) : super(settings: page);

  NavPage<T> get _page => settings as NavPage<T>;

  @override
  Duration get transitionDuration => _page.navAni == NavAni.Blink
      ? Duration.zero
      : Duration(milliseconds: _page.durationMs);

  @override
  bool get maintainState => _page.maintainState;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      _page.child;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    switch (_page.navAni) {
      case NavAni.Left:
        return slideTransitionBuilder(const Offset(-1.0, 0.0))(
            context, animation, secondaryAnimation, child);
      case NavAni.Right:
        return slideTransitionBuilder(const Offset(1.0, 0.0))(
            context, animation, secondaryAnimation, child);
      case NavAni.Top:
        return slideTransitionBuilder(const Offset(0.0, -1.0))(
            context, animation, secondaryAnimation, child);
      case NavAni.Bottom:
        return slideTransitionBuilder(const Offset(0.0, 1.0))(
            context, animation, secondaryAnimation, child);
      case NavAni.Fade:
        return fadeTransitionBuilder(
            context, animation, secondaryAnimation, child);
      case NavAni.Blink:
        return child;
      case NavAni.Ripple:
        // Same reveal as NavAni.Ripple.createRoute.
        final size = MediaQuery.sizeOf(context);
        return ClipPath(
          clipper: CircularRevealClipper(
            fraction: animation.value,
            centerAlignment: Alignment.bottomRight,
            centerOffset: Offset.zero,
            minRadius: 10,
            maxRadius: size.height + size.width / 2,
          ),
          child: child,
        );
    }
  }

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

class _NavCupertinoPageRoute<T> extends PageRoute<T>
    with CupertinoRouteTransitionMixin<T> {
  _NavCupertinoPageRoute(NavPage<T> page) : super(settings: page);

  NavPage<T> get _page => settings as NavPage<T>;

  @override
  Widget buildContent(BuildContext context) => _page.child;

  @override
  String? get title => null;

  @override
  bool get maintainState => _page.maintainState;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';
}

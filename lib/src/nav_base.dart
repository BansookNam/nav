import 'package:flutter/cupertino.dart';
import 'package:nav/src/enum/enum_nav_ani.dart';
import 'package:nav/src/route/ripple_route_builder.dart';
import 'package:nav/src/screen/nav_screen.dart';
import 'package:nav/src/setting/nav_setting.dart';

mixin Nav<T extends StatefulWidget> on State<T> {
  static const int defaultDurationMs = 200;
  static const int defaultDialogDurationMs = 500;

  GlobalKey<NavigatorState> get navigatorKey;

  static GlobalKey<NavigatorState>? _globalKeyHolder;
  static NavSetting? navSetting;

  static GlobalKey<NavigatorState> get _globalKey {
    final key = _globalKeyHolder;
    if (key == null) {
      throw StateError(
          'Nav is not initialized. Call Nav.init(navigatorKey) — or mix Nav '
          'into your root State and pass the same key to '
          'MaterialApp.navigatorKey — before using Nav methods.');
    }
    return key;
  }

  @override
  void initState() {
    super.initState();
    Nav.init(navigatorKey);
  }

  /// Initialize Nav with the key you pass to `MaterialApp.navigatorKey`.
  ///
  /// Mixing [Nav] into your root [State] calls this automatically; call it
  /// yourself if you prefer not to use the mixin.
  static void init(GlobalKey<NavigatorState> navigatorKey,
      {NavSetting? setting}) {
    _globalKeyHolder = navigatorKey;
    if (setting != null) {
      navSetting = setting;
    }
  }

  ///some library package need to change global key for some purpose.
  ///It is not recommended to change globalKey because it will reset all the navigation states.
  void setGlobalKey(GlobalKey<NavigatorState> key) {
    _globalKeyHolder = key;
  }

  static void initialize(NavSetting navSetting) {
    Nav.navSetting = navSetting;
  }

  /// Get navigator state
  static NavigatorState? navigatorState(BuildContext? context) {
    if (context != null) {
      try {
        return Navigator.of(context);
      } on FlutterError {
        // No Navigator above [context] — fall back to the global navigator.
        return _globalKey.currentState;
      }
    }
    return _globalKey.currentState;
  }

  static BuildContext get globalContext => _globalKey.currentContext!;

  /// Push screen from right to left
  ///
  /// On ios "Swipe back gesture" is default
  /// Set prohibitSwipeBack true if you don't want allow swipe back.
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> pushFromRight<T>(
    Widget screen, {
    bool prohibitSwipeBack = false,
    BuildContext? context,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) async {
    return navigatorState(context)?.push(
      getPushRightRoute<T>(screen,
          prohibitSwipeBack: prohibitSwipeBack,
          context: context,
          settings: settings,
          fullscreenDialog: fullscreenDialog),
    );
  }

  static Route<T> getPushRightRoute<T>(Widget screen,
      {bool prohibitSwipeBack = false,
      BuildContext? context,
      int durationMs = Nav.defaultDurationMs,
      RouteSettings? settings,
      bool fullscreenDialog = false}) {
    return NavAni.Right.createRoute<T>(screen, context, durationMs,
        prohibitSwipeBack: prohibitSwipeBack,
        settings: settings,
        fullscreenDialog: fullscreenDialog);
  }

  /// Push screen with Ripple Effect (Default: bottomRight to topLeft, You can change the alignment and offset)
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> pushWithRippleEffect<T>(
    Widget screen, {
    BuildContext? context,
    AlignmentGeometry? alignment,
    Offset offset = const Offset(0, 0),
    int durationMs = Nav.defaultDurationMs,
  }) async {
    final height = MediaQuery.of(navigatorState(context)!.context).size.height;
    final width = MediaQuery.of(navigatorState(context)!.context).size.width;

    return navigatorState(context)?.push(
      RippleRouteBuilder(screen,
          maxRadius: height + width / 2,
          centerAlignment: (alignment == null && offset == const Offset(0, 0))
              ? Alignment.bottomRight
              : alignment,
          centerOffset: offset,
          minRadius: 10,
          durationMs: durationMs),
    );
  }

  /// Push screen with NavAni param
  ///
  /// If you provide context, you can nest navigate in your specific context.
  ///
  /// [reverseDurationMs] (closing) defaults to [durationMs]; [curve] defaults
  /// to linear. [settings] names the route (observers, `ModalRoute.of`),
  /// [fullscreenDialog] makes it a full-screen modal (an iOS close button,
  /// no swipe back), [opaque] false keeps the screen below drawn, and
  /// [maintainState] false lets the route drop its state when covered.
  /// [NavAni.platform] and the iOS [NavAni.Right] use the platform's timing:
  /// the durations, [curve] and [opaque] do not apply to them.
  static Future<T?> push<T>(
    Widget screen, {
    NavAni navAni = NavAni.Right,
    BuildContext? context,
    int durationMs = defaultDurationMs,
    int? reverseDurationMs,
    Curve curve = Curves.linear,
    RouteSettings? settings,
    bool fullscreenDialog = false,
    bool opaque = true,
    bool maintainState = true,
  }) async {
    final navigator = navigatorState(context);
    if (navigator == null) return null;
    return navigator.push(navAni.createRoute<T>(
        screen, navigator.context, durationMs,
        reverseDurationMs: reverseDurationMs,
        curve: curve,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
        opaque: opaque,
        maintainState: maintainState));
  }

  /// Push a [route] you built yourself (a `MaterialPageRoute` subclass, a
  /// `PageRouteBuilder`, …) on the same navigator [push] uses.
  static Future<T?> pushRoute<T>(Route<T> route,
      {BuildContext? context}) async {
    return navigatorState(context)?.push(route);
  }

  /// Push Replacement screen
  ///
  /// If you provide context, you can nest navigate in your specific context.
  /// The route options are the same as [push]'s.
  static Future<T?> pushReplacement<T, TO extends Object>(
    Widget screen, {
    BuildContext? context,
    NavAni navAni = NavAni.Fade,
    TO? result,
    int durationMs = defaultDurationMs,
    int? reverseDurationMs,
    Curve curve = Curves.linear,
    RouteSettings? settings,
    bool fullscreenDialog = false,
    bool opaque = true,
    bool maintainState = true,
  }) async {
    final navigator = navigatorState(context);
    if (navigator == null) return null;
    return navigator.pushReplacement(
        navAni.createRoute<T>(screen, navigator.context, durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState),
        result: result);
  }

  /// Clear All screen on navigator state and push the new one.
  ///
  /// If you provide context, you can nest navigate in your specific context.
  /// The route options are the same as [push]'s.
  static Future<T?> clearAllAndPush<T>(
    Widget screen, {
    BuildContext? context,
    NavAni navAni = NavAni.Fade,
    int durationMs = defaultDurationMs,
    int? reverseDurationMs,
    Curve curve = Curves.linear,
    RouteSettings? settings,
    bool fullscreenDialog = false,
    bool opaque = true,
    bool maintainState = true,
  }) async {
    final navigator = navigatorState(context);
    if (navigator == null) return null;
    return navigator.pushAndRemoveUntil(
        navAni.createRoute<T>(screen, navigator.context, durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState),
        (Route<dynamic> route) => false);
  }

  static Future<Result?> pushResult<Result>(
    NavScreen<Result> screen, {
    NavAni navAni = NavAni.Right,
    BuildContext? context,
    int durationMs = defaultDurationMs,
    int? reverseDurationMs,
    Curve curve = Curves.linear,
    RouteSettings? settings,
    bool fullscreenDialog = false,
    bool opaque = true,
    bool maintainState = true,
  }) async {
    return push<Result>(screen,
        navAni: navAni,
        context: context,
        durationMs: durationMs,
        reverseDurationMs: reverseDurationMs,
        curve: curve,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
        opaque: opaque,
        maintainState: maintainState);
  }

  /// pop screen with result
  static void pop<T>(BuildContext context, {T? result}) {
    if (result == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(result);
    }
  }

  /// Pops the top route if it agrees to (`PopScope`, `Route.popDisposition`),
  /// like `Navigator.maybePop` on [context]'s navigator. Returns whether a
  /// route handled the pop.
  static Future<bool> maybePop<T extends Object?>(BuildContext context,
      {T? result}) {
    return Navigator.of(context).maybePop<T>(result);
  }

  /// Pops routes until [predicate] is true for the top one, like
  /// `Navigator.popUntil`. `Nav.popUntil((route) => route.isFirst)` goes back
  /// to the first screen. Without [context], Nav's navigator.
  static void popUntil(RoutePredicate predicate, {BuildContext? context}) {
    navigatorState(context)?.popUntil(predicate);
  }

  /// Whether the navigator can pop.
  static bool canPop({BuildContext? context}) {
    return navigatorState(context)?.canPop() == true;
  }

  static void clearAll({BuildContext? context}) {
    final state = navigatorState(context);
    while (state?.canPop() == true) {
      state?.pop();
    }
  }
}

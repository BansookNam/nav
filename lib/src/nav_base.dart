import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nav/src/enum/enum_nav_ani.dart';
import 'package:nav/src/route/ripple_route_builder.dart';
import 'package:nav/src/route/slide_route_builder.dart';
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
  }) async {
    return navigatorState(context)?.push(
      getPushRightRoute(screen,
          prohibitSwipeBack: prohibitSwipeBack, context: context) as Route<T>,
    );
  }

  static Route<T> getPushRightRoute<T>(Widget screen,
      {bool prohibitSwipeBack = false,
      BuildContext? context,
      int durationMs = Nav.defaultDurationMs}) {
    return TargetPlatform.iOS == defaultTargetPlatform && !prohibitSwipeBack
        ? CupertinoPageRoute<T>(builder: (context) => screen)
        : SlideRouteBuilder<T>.fromRight(screen, durationMs: durationMs);
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
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> push<T>(Widget screen,
      {NavAni navAni = NavAni.Right,
      BuildContext? context,
      int durationMs = defaultDurationMs}) async {
    return navigatorState(context)?.push(navAni.createRoute(
        screen, navigatorState(context)!.context, durationMs));
  }

  /// Push Replacement screen
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> pushReplacement<T, TO extends Object>(Widget screen,
      {BuildContext? context,
      NavAni navAni = NavAni.Fade,
      TO? result,
      int durationMs = defaultDurationMs}) async {
    return navigatorState(context)?.pushReplacement(
        navAni.createRoute(
            screen, navigatorState(context)!.context, durationMs),
        result: result);
  }

  /// Clear All screen on navigator state and push the new one.
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> clearAllAndPush<T>(Widget screen,
      {BuildContext? context,
      NavAni navAni = NavAni.Fade,
      int durationMs = defaultDurationMs}) async {
    return navigatorState(context)?.pushAndRemoveUntil(
        navAni.createRoute(
            screen, navigatorState(context)!.context, durationMs),
        (Route<dynamic> route) => false);
  }

  static Future<Result?> pushResult<Result>(NavScreen<Result> screen,
      {NavAni navAni = NavAni.Right,
      BuildContext? context,
      int durationMs = defaultDurationMs}) async {
    return push<Result>(screen,
        navAni: navAni, context: context, durationMs: durationMs);
  }

  /// pop screen with result
  static void pop<T>(BuildContext context, {T? result}) {
    if (result == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(result);
    }
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

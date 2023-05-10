library nav;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nav/enum/enum_nav_ani.dart';
import 'package:nav/route/r_ripple.dart';
import 'package:nav/route/r_slide.dart';

mixin Nav<T extends StatefulWidget> on State<T> {
  static const int defaultDurationMs = 200;

  static const RESULT = "result";
  static const SUCCESS = "success";
  static const FAIL = "fail";
  static const CANCEL = "cancel";
  static const DELETED = "deleted";
  static const REFRESH = "refresh";

  GlobalKey<NavigatorState> get navigatorKey;
  static late GlobalKey<NavigatorState> _globalKey;
  static double? height;
  static late double width;

  @override
  void initState() {
    super.initState();
    _globalKey = navigatorKey;
  }

  ///some library package need to change global key for some purpose.
  ///It is not recommended to change globalKey because it will reset all the navigation states.
  void setGlobalKey(GlobalKey<NavigatorState> key) {
    _globalKey = key;
  }

  static void initDeviceSize(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }

  /// Get navigator state
  static NavigatorState? navigatorState(BuildContext? context) {
    NavigatorState? state;
    try {
      if (context != null) {
        state = Navigator.of(context);
        return state;
      } else {
        return _globalKey.currentState;
      }
    } catch (e) {
      return _globalKey.currentState;
    }
  }

  static BuildContext get globalContext => _globalKey.currentContext!;

  /// Push screen from right to left
  ///
  /// On ios "Swipe back gesture" is default
  /// Set prohibitSwipeBack true if you don't want allow swipe back.
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> pushFromRight<T>(
    Widget? screen, {
    bool prohibitSwipeBack = false,
    BuildContext? context,
  }) async {
    if (screen == null) {
      return null;
    }
    return navigatorState(context)?.push(
      getPushRightRoute(screen, prohibitSwipeBack: prohibitSwipeBack, context: context) as Route<T>,
    );
  }

  static Route<T> getPushRightRoute<T>(Widget screen,
      {bool prohibitSwipeBack = false, BuildContext? context, int durationMs = Nav.defaultDurationMs}) {
    return TargetPlatform.iOS == defaultTargetPlatform && !prohibitSwipeBack
        ? CupertinoPageRoute<T>(builder: (context) => screen)
        : SlideFromRightRoute<T>(screen, durationMs: durationMs);
  }

  /// Push screen from left to right
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> pushFromLeft<T>(Widget? screen, {BuildContext? context}) async {
    if (screen == null) {
      return null;
    }
    return navigatorState(context)?.push(
      SlideFromLeftRoute(screen),
    );
  }

  /// Push screen from bottom to top
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> pushFromBottom<T>(Widget screen, {BuildContext? context}) async => navigatorState(context)?.push(
        SlideFromBottomRoute(screen),
      );

  /// Push screen from top to bottom
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> pushFromTop<T>(Widget screen, {BuildContext? context}) async => navigatorState(context)?.push(
        SlideFromTopRoute(screen),
      );

  /// Push screen with Ripple Effect (Default: bottomRight to topLeft, You can change the alignment and offset)
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> pushWithRippleEffect<T>(Widget? screen,
      {BuildContext? context,
      AlignmentGeometry centerAlignment = Alignment.bottomRight,
      Offset centerOffset = const Offset(10, 10)}) async {
    if (screen == null) {
      return null;
    }
    if (height == null && navigatorState(context) != null) {
      initDeviceSize(navigatorState(context)!.context);
    }

    return navigatorState(context)?.push(
      RoundRevealRoute(
        screen,
        maxRadius: height! + width / 2,
        centerAlignment: centerAlignment,
        centerOffset: centerOffset,
        minRadius: 10,
      ),
    );
  }

  /// Push screen with NavAni param
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> push<T>(Widget? screen,
      {NavAni navAni = NavAni.Right, BuildContext? context, int durationMs = defaultDurationMs}) async {
    if (screen == null) {
      return null;
    }
    return navigatorState(context)?.push(navAni.createRoute(screen, navigatorState(context)?.context, durationMs));
  }

  /// Push Replacement screen
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> pushReplacement<T, TO extends Object>(Widget? screen,
      {BuildContext? context, NavAni navAni = NavAni.Fade, TO? result, int durationMs = defaultDurationMs}) async {
    if (screen == null) {
      return null;
    }
    return navigatorState(context)?.pushReplacement(navAni.createRoute(screen, context, durationMs), result: result);
  }

  /// Clear All screen on navigator state and push the new one.
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T?> clearAllAndPush<T>(Widget? screen,
      {BuildContext? context, NavAni navAni = NavAni.Fade, int durationMs = defaultDurationMs}) async {
    if (screen == null) {
      return null;
    }
    return navigatorState(context)
        ?.pushAndRemoveUntil(navAni.createRoute(screen, context, durationMs), (Route<dynamic> route) => false);
  }

  /// Check result is success
  static bool isSuccess(result) {
    return result != null && result[RESULT] == SUCCESS;
  }

  /// Check result is fail
  static bool isFail(result) {
    return result != null && result[RESULT] == FAIL;
  }

  /// Check result is cancel
  static bool isCancel(result) {
    return result != null && result[RESULT] == CANCEL;
  }

  /// Check result is deleted
  static bool isDeleted(result) {
    return result != null && result[RESULT] == DELETED;
  }

  /// Check result is refresh
  static bool isRefresh(result) {
    return result != null && result[RESULT] == REFRESH;
  }

  /// pop screen with result
  static void pop<T>(BuildContext context, {T? result}) {
    if (result == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(result);
    }
  }

  /// simple pop with success result
  static void popResultSuccess(BuildContext context) {
    pop(context, result: {RESULT: SUCCESS});
  }

  /// simple pop with fail result
  static void popResultFail(BuildContext context) {
    pop(context, result: {RESULT: FAIL});
  }

  /// simple pop with cancel result
  static void popResultCancel(BuildContext context) {
    pop(context, result: {RESULT: CANCEL});
  }

  /// simple pop with delete result
  static void popResultDelete(BuildContext context) {
    pop(context, result: {RESULT: DELETED});
  }

  /// simple pop with refresh result
  static void popResultRefresh(BuildContext context) {
    pop(context, result: {RESULT: REFRESH});
  }

  /// Check if can pop
  static Future<bool> canPop({BuildContext? context}) async {
    return navigatorState(context)?.canPop() == true;
  }

  static void clearAll({BuildContext? context}) {
    final state = navigatorState(context);
    while (state?.canPop() == true) {
      state?.pop();
    }
  }
}

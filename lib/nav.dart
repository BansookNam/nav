library nav;

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nav/route/r_round.dart';
import 'package:nav/route/r_slide.dart';

mixin Nav<T extends StatefulWidget> on State<T> {
  static const RESULT = "result";
  static const SUCCESS = "success";
  static const FAIL = "fail";
  static const CANCEL = "cancel";
  static const DELETED = "deleted";
  static const REFRESH = "refresh";

  GlobalKey<NavigatorState> get navigatorKey;
  static GlobalKey<NavigatorState> _globalKey;
  static double _height;
  static double _width;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _globalKey = navigatorKey;
    });
  }

  /// Initializing method for nav.
  ///
  /// You should call this method for using pushRoundFromBottomRight method.
  /// Call this method on your first screen widget which is below [MaterialApp] or [CupertinoApp]
  static void initInsideOfApp() {
    if (_height != null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _height = MediaQuery.of(context).size.height;
      _width = MediaQuery.of(context).size.width;
    });
  }

  /// Get navigator state
  static NavigatorState navigatorState(BuildContext context) =>
      context != null ? Navigator.of(context) : _globalKey.currentState;

  /// Push screen from right to left
  ///
  /// On ios "Swipe back gesture" is default
  /// Set prohibitSwipeBack true if you don't want allow swipe back.
  /// If you provide context, you can nest navigate in your specific context
  static Future<T> pushFromRight<T>(
    Widget screen, {
    bool prohibitSwipeBack = false,
    BuildContext context,
  }) {
    return navigatorState(context).push(
      Platform.isIOS && !prohibitSwipeBack
          ? CupertinoPageRoute(builder: (context) => screen)
          : SlideRightRoute(widget: screen),
    );
  }

  /// Push screen from left to right
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T> pushFromLeft<T>(Widget screen, {BuildContext context}) {
    return navigatorState(context).push(
      SlideLeftRoute(widget: screen),
    );
  }

  /// Push screen from bottom to top
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T> pushFromBottom<T>(Widget screen, {BuildContext context}) =>
      navigatorState(context).push(
        SlideTopRoute(widget: screen),
      );

  /// Push screen from top to bottom
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T> pushFromTop<T>(Widget screen, {BuildContext context}) =>
      navigatorState(context).push(
        SlideBottomRoute(widget: screen),
      );

  /// Push screen from bottomRight to topLeft with Ripple Effect
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T> pushRoundFromBottomRight<T>(Widget screen,
      {BuildContext context}) {
    return navigatorState(context).push(
      RoundRevealRoute(
        widget: screen,
        maxRadius: _height + _width / 2,
        centerAlignment: Alignment.bottomRight,
        centerOffset: Offset(10, 10),
        minRadius: 10,
      ),
    );
  }

  /// Push Replacement screen
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T> pushReplacement<T, TO extends Object>(Widget screen,
          {BuildContext context, TO result}) =>
      navigatorState(context)
          .pushReplacement(SlideTopRoute(widget: screen), result: result);

  /// Clear All screen on navigator state and push the new one.
  ///
  /// If you provide context, you can nest navigate in your specific context
  static Future<T> clearAllAndPush<T>(Widget screen, {BuildContext context}) {
    if (screen == null) {
      return null;
    }
    return navigatorState(context).pushAndRemoveUntil(
        SlideTopRoute(widget: screen), (Route<dynamic> route) => false);
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
  static void pop<T extends Object>(BuildContext context, {T result}) {
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
  static Future<bool> canPop({BuildContext context}) async {
    return navigatorState(context).canPop();
  }
}

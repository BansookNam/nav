library nav;

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nav/route/r_round.dart';
import 'package:nav/route/r_slide.dart';

class Nav {
  static const RESULT = "result";
  static const DELETED = "deleted";
  static const SUCCESS = "success";
  static const FAIL = "fail";
  static const CANCEL = "cancel";

  static GlobalKey<NavigatorState> _globalKey;
  static double _height;
  static double _width;

  static void setGlobalKey(GlobalKey<NavigatorState> key) {
    _globalKey = key;
    MediaQueryData data = MediaQuery.of(_globalKey.currentContext);
    _height = data.size.height;
    _width = data.size.width;
  }

  static NavigatorState navigatorState(BuildContext context) =>
      context == null ? Navigator.of(context) : _globalKey.currentState;

  static void popResultSuccess(BuildContext context) =>
      pop(context, result: {RESULT: SUCCESS});

  static void pop(BuildContext context, {dynamic result}) {
    if (result == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(result);
    }
  }

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

  static Future<T> pushFromLeft<T>(
    Widget screen,
    BuildContext context,
  ) {
    return navigatorState(context).push(
      SlideLeftRoute(widget: screen),
    );
  }

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

  static Future<T> pushFromBottom<T>(Widget screen, {BuildContext context}) =>
      navigatorState(context).push(
        SlideTopRoute(widget: screen),
      );

  static Future<T> pushReplacement<T>(Widget screen, {BuildContext context}) =>
      navigatorState(context).pushReplacement(SlideTopRoute(widget: screen));

  static Future<T> clearAllAndPush<T>(Widget screen, {BuildContext context}) {
    if (screen == null) {
      return null;
    }
    return navigatorState(context).pushAndRemoveUntil(
        SlideTopRoute(widget: screen), (Route<dynamic> route) => false);
  }

  static bool isSuccess(result) {
    return result != null && result[RESULT] == SUCCESS;
  }

  static bool isDeleted(result) {
    return result != null && result[RESULT] == DELETED;
  }
}

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

  static void setGlobalKey(GlobalKey<NavigatorState> key, BuildContext context) {
    _globalKey = key;
  }

  static void popResultSuccess(BuildContext context) => pop(context, result: {RESULT: SUCCESS});

  static void pop(BuildContext context, {dynamic result}) {
    if (result == null) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop(result);
    }
  }

  static Future<T> pushFromRight<T>(Widget screen, {bool prohibitSwipeBack = false}) {
    if (Platform.isIOS && !prohibitSwipeBack) {
      return _globalKey.currentState.push(
        CupertinoPageRoute(builder: (context) => screen),
      );
    } else {
      return _globalKey.currentState.push(
        SlideRightRoute(widget: screen),
      );
    }
  }

  static Future<T> pushFromLeft<T>(Widget screen) {
    return _globalKey.currentState.push(
      SlideLeftRoute(widget: screen),
    );
  }

  static Future<T> pushRoundFromBottomRight<T>(Widget screen, {BuildContext context}) {
    MediaQueryData data = MediaQuery.of(context);
    return _globalKey.currentState.push(
      RoundRevealRoute(
        widget: screen,
        maxRadius: data.size.height + data.size.width / 2,
        centerAlignment: Alignment.bottomRight,
        centerOffset: Offset(10, 10),
        minRadius: 10,
      ),
    );
  }

  static Future<T> pushContextRight<T>(BuildContext context, Widget screen) {
    if (Platform.isIOS) {
      return Navigator.of(context).push(
        CupertinoPageRoute(builder: (context) => screen),
      );
    } else {
      return Navigator.of(context).push(
        SlideRightRoute(widget: screen),
      );
    }
  }

  static Future<T> globalPushFromBottom<T>(Widget screen) => _globalKey.currentState.push(
        SlideTopRoute(widget: screen),
      );

  static Future<T> pushReplacement<T>(Widget screen) => _globalKey.currentState.pushReplacement(SlideTopRoute(widget: screen));

  static Future<T> clearAllAndPush<T>(Widget screen) {
    if (screen == null) {
      return null;
    }
    return _globalKey.currentState.pushAndRemoveUntil(SlideTopRoute(widget: screen), (Route<dynamic> route) => false);
  }

  static bool isSuccess(result) {
    return result != null && result[RESULT] == SUCCESS;
  }

  static bool isDeleted(result) {
    return result != null && result[RESULT] == DELETED;
  }
}

// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nav/src/nav_base.dart';
import 'package:nav/src/route/blink_route_builder.dart';
import 'package:nav/src/route/fade_route_builder.dart';
import 'package:nav/src/route/ripple_route_builder.dart';
import 'package:nav/src/route/slide_route_builder.dart';

/// Navigation animations.
///
/// The UpperCamelCase values predate Dart's lowerCamelCase convention and
/// will be removed in 3.0 — prefer the lowercase aliases ([left], [right],
/// [top], [bottom], [fade], [ripple], [blink]).
enum NavAni {
  Left,
  Right,
  Top,
  Bottom,
  Fade,
  Ripple,
  Blink,

  /// The platform's own page transition: a [MaterialPageRoute], which follows
  /// the app's `PageTransitionsTheme` (Android's predictive back and system
  /// transitions, the iOS slide with swipe back). Durations and curves are
  /// the theme's, so `durationMs`, `reverseDurationMs`, `curve` and `opaque`
  /// are ignored. For a dialog it is Material's `showDialog`.
  platform;

  static const NavAni left = Left;
  static const NavAni right = Right;
  static const NavAni top = Top;
  static const NavAni bottom = Bottom;
  static const NavAni fade = Fade;
  static const NavAni ripple = Ripple;
  static const NavAni blink = Blink;
}

extension NavAniExt on NavAni {
  /// The route this animation pushes [screen] with. [context] is only read by
  /// [NavAni.Ripple] (the screen size; null: Nav's navigator).
  ///
  /// [reverseDurationMs] defaults to [durationMs], [curve] to linear. On iOS
  /// [NavAni.Right] is a [CupertinoPageRoute] (swipe back) unless
  /// [prohibitSwipeBack]; that route and [NavAni.platform] use the platform's
  /// own timing, so the durations, [curve] and [opaque] do not apply to them.
  Route<T> createRoute<T>(
    Widget screen,
    BuildContext? context,
    int durationMs, {
    int? reverseDurationMs,
    Curve curve = Curves.linear,
    RouteSettings? settings,
    bool fullscreenDialog = false,
    bool opaque = true,
    bool maintainState = true,
    bool prohibitSwipeBack = false,
  }) {
    switch (this) {
      case NavAni.Left:
        return SlideRouteBuilder<T>.fromLeft(screen,
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);
      case NavAni.Right:
        if (defaultTargetPlatform == TargetPlatform.iOS && !prohibitSwipeBack) {
          return CupertinoPageRoute<T>(
              builder: (context) => screen,
              settings: settings,
              fullscreenDialog: fullscreenDialog,
              maintainState: maintainState);
        }
        return SlideRouteBuilder<T>.fromRight(screen,
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);
      case NavAni.Top:
        return SlideRouteBuilder<T>.fromTop(screen,
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);
      case NavAni.Bottom:
        return SlideRouteBuilder<T>.fromBottom(screen,
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);
      case NavAni.Fade:
        return FadeRouteBuilder<T>(screen,
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);
      case NavAni.Blink:
        return BlinkRouteBuilder<T>(screen,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);
      case NavAni.Ripple:
        final size = MediaQuery.sizeOf(context ?? Nav.globalContext);
        return RippleRouteBuilder<T>(screen,
            maxRadius: size.height + size.width / 2,
            centerAlignment: Alignment.bottomRight,
            centerOffset: const Offset(0, 0),
            minRadius: 10,
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);
      case NavAni.platform:
        return MaterialPageRoute<T>(
            builder: (context) => screen,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            maintainState: maintainState);
    }
  }
}

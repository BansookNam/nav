// ignore_for_file: constant_identifier_names

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
  Blink;

  static const NavAni left = Left;
  static const NavAni right = Right;
  static const NavAni top = Top;
  static const NavAni bottom = Bottom;
  static const NavAni fade = Fade;
  static const NavAni ripple = Ripple;
  static const NavAni blink = Blink;
}

extension NavAniExt on NavAni {
  Route<T> createRoute<T>(Widget screen, BuildContext context, int durationMs) {
    switch (this) {
      case NavAni.Left:
        return SlideRouteBuilder<T>.fromLeft(screen, durationMs: durationMs);
      case NavAni.Right:
        return Nav.getPushRightRoute<T>(screen,
            context: context, prohibitSwipeBack: false, durationMs: durationMs);
      case NavAni.Top:
        return SlideRouteBuilder<T>.fromTop(screen, durationMs: durationMs);
      case NavAni.Bottom:
        return SlideRouteBuilder<T>.fromBottom(screen, durationMs: durationMs);
      case NavAni.Fade:
        return FadeRouteBuilder<T>(screen, durationMs: durationMs);
      case NavAni.Blink:
        return BlinkRouteBuilder<T>(screen);
      case NavAni.Ripple:
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;

        return RippleRouteBuilder<T>(screen,
            maxRadius: height + width / 2,
            centerAlignment: Alignment.bottomRight,
            centerOffset: const Offset(0, 0),
            minRadius: 10,
            durationMs: durationMs);
    }
  }
}

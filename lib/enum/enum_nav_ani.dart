import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:nav/route/r_blink.dart';
import 'package:nav/route/r_fade.dart';
import 'package:nav/route/r_ripple.dart';
import 'package:nav/route/r_slide.dart';

enum NavAni { Left, Right, Top, Bottom, Fade, Ripple, Blink }

extension NavAniExt on NavAni {
  PageRoute<T> createRoute<T>(
      Widget screen, BuildContext? context, int durationMs) {
    switch (this) {
      case NavAni.Left:
        return SlideFromLeftRoute(screen, durationMs: durationMs);
      case NavAni.Right:
        return Nav.getPushRightRoute(screen,
            context: context,
            prohibitSwipeBack: false,
            durationMs: durationMs) as PageRoute<T>;
      case NavAni.Top:
        return SlideFromTopRoute(screen, durationMs: durationMs);
      case NavAni.Bottom:
        return SlideFromBottomRoute(screen, durationMs: durationMs);
      case NavAni.Fade:
        return FadeRoute(screen, durationMs: durationMs);
      case NavAni.Blink:
        return BlinkRoute(screen);
      case NavAni.Ripple:
        if (Nav.height == null) {
          Nav.initDeviceSize(context!);
        }
        return RoundRevealRoute(screen,
            maxRadius: Nav.height! + Nav.width / 2,
            centerAlignment: Alignment.bottomRight,
            centerOffset: Offset(10, 10),
            minRadius: 10,
            durationMs: durationMs);
      default:
        return SlideFromRightRoute(screen);
    }
  }
}

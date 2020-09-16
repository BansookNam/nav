import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:nav/route/r_blink.dart';
import 'package:nav/route/r_fade.dart';
import 'package:nav/route/r_round.dart';
import 'package:nav/route/r_slide.dart';

enum NavAni { Left, Right, Top, Bottom, Fade, Ripple, Blink }

extension NavAniExt on NavAni {
  PageRoute<T> createRoute<T>(Widget screen, BuildContext context) {
    switch (this) {
      case NavAni.Left:
        return SlideFromLeftRoute(widget: screen);
      case NavAni.Right:
        return SlideFromRightRoute(widget: screen);
      case NavAni.Top:
        return SlideFromTopRoute(widget: screen);
      case NavAni.Bottom:
        return SlideFromBottomRoute(widget: screen);
      case NavAni.Fade:
        return FadeRoute(widget: screen);
      case NavAni.Blink:
        return BlinkRoute(widget: screen);
      case NavAni.Ripple:
        if (Nav.height == null) {
          Nav.initDeviceSize(context);
        }
        return RoundRevealRoute(
          widget: screen,
          maxRadius: Nav.height + Nav.width / 2,
          centerAlignment: Alignment.bottomRight,
          centerOffset: Offset(10, 10),
          minRadius: 10,
        );
      default:
        return SlideFromRightRoute(widget: screen);
    }
  }
}

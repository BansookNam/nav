import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:nav/route/r_blink.dart';
import 'package:nav/route/r_fade.dart';
import 'package:nav/route/r_ripple.dart';
import 'package:nav/route/r_slide.dart';

// ignore: constant_identifier_names
enum NavAni { Left, Right, Top, Bottom, Fade, Ripple, Blink }

extension NavAniExt on NavAni {
  Route<T> createRoute<T>(Widget screen, BuildContext context, int durationMs) {
    switch (this) {
      case NavAni.Left:
        return SlideFromLeftRoute<T>(screen, durationMs: durationMs);
      case NavAni.Right:
        return Nav.getPushRightRoute<T>(screen,
            context: context, prohibitSwipeBack: false, durationMs: durationMs);
      case NavAni.Top:
        return SlideFromTopRoute<T>(screen, durationMs: durationMs);
      case NavAni.Bottom:
        return SlideFromBottomRoute<T>(screen, durationMs: durationMs);
      case NavAni.Fade:
        return FadeRoute<T>(screen, durationMs: durationMs);
      case NavAni.Blink:
        return BlinkRoute<T>(screen);
      case NavAni.Ripple:
        final height = MediaQuery.of(context).size.height;
        final width = MediaQuery.of(context).size.width;

        return RoundRevealRoute<T>(screen,
            maxRadius: height + width / 2,
            centerAlignment: Alignment.bottomRight,
            centerOffset: const Offset(10, 10),
            minRadius: 10,
            durationMs: durationMs);
    }
  }
}

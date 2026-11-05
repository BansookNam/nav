import 'package:flutter/material.dart';
import 'package:nav/src/nav_base.dart';
import 'package:nav/src/route/custom_page_route_builder.dart';
import 'package:nav/src/route/nav_transitions.dart';

/// Fades [widget] in. [reverseDurationMs] defaults to [durationMs]; [curve]
/// defaults to linear.
class FadeRouteBuilder<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  FadeRouteBuilder(
    this.widget, {
    int durationMs = Nav.defaultDurationMs,
    int? reverseDurationMs,
    Curve curve = Curves.linear,
    super.settings,
    super.fullscreenDialog,
    super.opaque,
    super.maintainState,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: Duration(milliseconds: durationMs),
          reverseTransitionDuration: reverseDurationMs == null
              ? null
              : Duration(milliseconds: reverseDurationMs),
          transitionsBuilder: curvedFadeTransitionBuilder(curve),
        );
}

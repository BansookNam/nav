import 'package:flutter/material.dart';
import 'package:nav/src/nav_base.dart';
import 'package:nav/src/route/custom_page_route_builder.dart';
import 'package:nav/src/route/nav_transitions.dart';

class FadeRouteBuilder<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  FadeRouteBuilder(this.widget, {int durationMs = Nav.defaultDurationMs})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: Duration(milliseconds: durationMs),
          transitionsBuilder: fadeTransitionBuilder,
        );
}

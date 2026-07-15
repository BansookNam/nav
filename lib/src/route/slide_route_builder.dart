import 'package:flutter/material.dart';
import 'package:nav/src/nav_base.dart';
import 'package:nav/src/route/custom_page_route_builder.dart';
import 'package:nav/src/route/nav_transitions.dart';

/// Slides [widget] in from [begin] (in viewport-normalized units).
///
/// Use the named constructors for the four common directions:
/// [SlideRouteBuilder.fromLeft], [SlideRouteBuilder.fromRight],
/// [SlideRouteBuilder.fromTop] and [SlideRouteBuilder.fromBottom].
class SlideRouteBuilder<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  SlideRouteBuilder(
    this.widget, {
    required Offset begin,
    int durationMs = Nav.defaultDurationMs,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: Duration(milliseconds: durationMs),
          transitionsBuilder: slideTransitionBuilder(begin),
        );

  SlideRouteBuilder.fromLeft(Widget widget,
      {int durationMs = Nav.defaultDurationMs})
      : this(widget, begin: const Offset(-1.0, 0.0), durationMs: durationMs);

  SlideRouteBuilder.fromRight(Widget widget,
      {int durationMs = Nav.defaultDurationMs})
      : this(widget, begin: const Offset(1.0, 0.0), durationMs: durationMs);

  SlideRouteBuilder.fromTop(Widget widget,
      {int durationMs = Nav.defaultDurationMs})
      : this(widget, begin: const Offset(0.0, -1.0), durationMs: durationMs);

  SlideRouteBuilder.fromBottom(Widget widget,
      {int durationMs = Nav.defaultDurationMs})
      : this(widget, begin: const Offset(0.0, 1.0), durationMs: durationMs);
}

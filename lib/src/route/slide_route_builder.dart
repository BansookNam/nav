import 'package:flutter/material.dart';
import 'package:nav/src/nav_base.dart';
import 'package:nav/src/route/custom_page_route_builder.dart';
import 'package:nav/src/route/nav_transitions.dart';

/// Slides [widget] in from [begin] (in viewport-normalized units).
///
/// Use the named constructors for the four common directions:
/// [SlideRouteBuilder.fromLeft], [SlideRouteBuilder.fromRight],
/// [SlideRouteBuilder.fromTop] and [SlideRouteBuilder.fromBottom].
///
/// [reverseDurationMs] defaults to [durationMs]; [curve] defaults to linear.
class SlideRouteBuilder<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  SlideRouteBuilder(
    this.widget, {
    required Offset begin,
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
          transitionsBuilder: slideTransitionBuilder(begin, curve: curve),
        );

  SlideRouteBuilder.fromLeft(Widget widget,
      {int durationMs = Nav.defaultDurationMs,
      int? reverseDurationMs,
      Curve curve = Curves.linear,
      RouteSettings? settings,
      bool fullscreenDialog = false,
      bool opaque = true,
      bool maintainState = true})
      : this(widget,
            begin: const Offset(-1.0, 0.0),
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);

  SlideRouteBuilder.fromRight(Widget widget,
      {int durationMs = Nav.defaultDurationMs,
      int? reverseDurationMs,
      Curve curve = Curves.linear,
      RouteSettings? settings,
      bool fullscreenDialog = false,
      bool opaque = true,
      bool maintainState = true})
      : this(widget,
            begin: const Offset(1.0, 0.0),
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);

  SlideRouteBuilder.fromTop(Widget widget,
      {int durationMs = Nav.defaultDurationMs,
      int? reverseDurationMs,
      Curve curve = Curves.linear,
      RouteSettings? settings,
      bool fullscreenDialog = false,
      bool opaque = true,
      bool maintainState = true})
      : this(widget,
            begin: const Offset(0.0, -1.0),
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);

  SlideRouteBuilder.fromBottom(Widget widget,
      {int durationMs = Nav.defaultDurationMs,
      int? reverseDurationMs,
      Curve curve = Curves.linear,
      RouteSettings? settings,
      bool fullscreenDialog = false,
      bool opaque = true,
      bool maintainState = true})
      : this(widget,
            begin: const Offset(0.0, 1.0),
            durationMs: durationMs,
            reverseDurationMs: reverseDurationMs,
            curve: curve,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            opaque: opaque,
            maintainState: maintainState);
}

import 'package:flutter/material.dart';
import 'package:nav/src/nav_base.dart';
import 'package:nav/src/route/custom_page_route_builder.dart';
import 'package:nav/src/route/clipper_circle.dart';

class RippleRouteBuilder<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;
  final AlignmentGeometry? centerAlignment;
  final Offset centerOffset;
  final double minRadius;
  final double maxRadius;

  /// Easing of the reveal's radius. Linear by default.
  final Curve curve;

  /// Reveals the next item pushed to the navigation using circle shape.
  ///
  /// You can provide [centerAlignment] for the reveal center or if you want a
  /// more precise use only [centerOffset] and leave other blank. When both
  /// are given, [centerAlignment] wins.
  ///
  /// The transition doesn't affect the entry screen so we will only touch
  /// the target screen. [reverseDurationMs] defaults to [durationMs].
  RippleRouteBuilder(
    this.widget, {
    this.minRadius = 0,
    required this.maxRadius,
    this.centerAlignment,
    this.centerOffset = Offset.zero,
    int durationMs = Nav.defaultDurationMs,
    int? reverseDurationMs,
    this.curve = Curves.linear,
    super.settings,
    super.fullscreenDialog,
    super.opaque,
    super.maintainState,
  }) : super(
          transitionDuration: Duration(milliseconds: durationMs),
          reverseTransitionDuration: reverseDurationMs == null
              ? null
              : Duration(milliseconds: reverseDurationMs),

          /// We could override pageBuilder but it's a required parameter of
          /// [PageRouteBuilder] and it won't build unless it's provided.
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return widget;
          },
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ClipPath(
      clipper: CircularRevealClipper(
        fraction: curve.transform(animation.value),
        centerAlignment:
            centerAlignment?.resolve(Directionality.maybeOf(context)),
        centerOffset: centerOffset,
        minRadius: minRadius,
        maxRadius: maxRadius,
      ),
      child: child,
    );
  }
}

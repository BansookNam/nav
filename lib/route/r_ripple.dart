import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:nav/route/CustomPageRouteBuilder.dart';
import 'package:nav/route/clipper_circle.dart';

class RoundRevealRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;
  final AlignmentGeometry centerAlignment;
  final Offset centerOffset;
  final double minRadius;
  final double maxRadius;

  /// Reveals the next item pushed to the navigation using circle shape.
  ///
  /// You can provide [centerAlignment] for the reveal center or if you want a
  /// more precise use only [centerOffset] and leave other blank.
  ///
  /// The transition doesn't affect the entry screen so we will only touch
  /// the target screen.
  RoundRevealRoute({
    @required this.widget,
    this.minRadius = 0,
    @required this.maxRadius,
    this.centerAlignment,
    this.centerOffset,
    int durationMs = Nav.defaultDurationMs,
  })  : assert(centerOffset != null || centerAlignment != null),
        super(
          transitionDuration: Duration(milliseconds: durationMs),

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
        fraction: animation.value,
        centerAlignment: centerAlignment,
        centerOffset: centerOffset,
        minRadius: minRadius,
        maxRadius: maxRadius,
      ),
      child: child,
    );
  }
}

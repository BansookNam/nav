import 'dart:ui';

import 'package:flutter/material.dart';

@immutable
class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Alignment? centerAlignment;
  final Offset centerOffset;
  final double? minRadius;
  final double maxRadius;

  const CircularRevealClipper({
    required this.fraction,
    required this.centerOffset,
    this.centerAlignment,
    this.minRadius,
    required this.maxRadius,
  });

  @override
  Path getClip(Size size) {
    final Offset center = centerAlignment?.alongSize(size) ?? centerOffset;
    final minRadius = this.minRadius ?? 0;
    final maxRadius = this.maxRadius;

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: lerpDouble(minRadius, maxRadius, fraction)!,
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

import 'package:flutter/material.dart';

/// Easing used by dialog transitions (see `DialogWidget.show`).
const Curve dialogTransitionCurve = Cubic(0.4, 0, 0.2, 1);

/// A [SlideTransition] entering from [begin] toward [Offset.zero].
///
/// Route builders use the default linear curve; dialogs pass
/// [dialogTransitionCurve] to keep their original easing.
RouteTransitionsBuilder slideTransitionBuilder(Offset begin,
    {Curve curve = Curves.linear}) {
  return (BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: begin, end: Offset.zero)
          .chain(CurveTween(curve: curve))
          .animate(animation),
      child: child,
    );
  };
}

/// A simple 0 → 1 [FadeTransition].
Widget fadeTransitionBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
    child: child,
  );
}

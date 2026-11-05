import 'package:flutter/material.dart';
import 'package:nav/src/route/custom_page_route_builder.dart';

/// Shows [widget] at once, with no transition.
class BlinkRouteBuilder<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  BlinkRouteBuilder(
    this.widget, {
    super.settings,
    super.fullscreenDialog,
    super.opaque,
    super.maintainState,
  }) : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionDuration: Duration.zero,
        );
}

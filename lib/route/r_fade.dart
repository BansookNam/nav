import 'package:flutter/material.dart';
import '../nav.dart';
import 'custom_page_route_builder.dart';

class FadeRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  FadeRoute(this.widget, {int durationMs = Nav.defaultDurationMs})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: Duration(milliseconds: durationMs),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              );
            });
}

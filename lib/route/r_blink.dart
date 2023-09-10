import 'package:flutter/material.dart';
import 'package:nav/route/custom_page_route_builder.dart';

class BlinkRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  BlinkRoute(this.widget)
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: const Duration(microseconds: 0),
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

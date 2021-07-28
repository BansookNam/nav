import 'package:flutter/material.dart';
import 'package:nav/route/CustomPageRouteBuilder.dart';

class BlinkRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  BlinkRoute(this.widget)
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: Duration(microseconds: 0),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return new FadeTransition(
                opacity:
                    new Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              );
            });
}

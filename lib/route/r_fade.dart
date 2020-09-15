import 'package:flutter/material.dart';
import 'package:nav/route/CustomPageRouteBuilder.dart';

const durationMs = 200;

class FadeRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  FadeRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new FadeTransition(
            opacity: new Tween<double>(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          );
        });
}

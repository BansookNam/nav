import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:nav/route/CustomPageRouteBuilder.dart';

class SlideFromLeftRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  SlideFromLeftRoute(this.widget, {int durationMs = Nav.defaultDurationMs})
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
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}

class SlideFromRightRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  SlideFromRightRoute(this.widget, {int durationMs = Nav.defaultDurationMs})
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
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}

class SlideFromBottomRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  SlideFromBottomRoute(this.widget, {int durationMs = Nav.defaultDurationMs})
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
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}

class SlideFromTopRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  SlideFromTopRoute(this.widget, {int durationMs = Nav.defaultDurationMs})
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
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(0.0, -1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}

import 'package:flutter/material.dart';
import 'package:nav/route/CustomPageRouteBuilder.dart';

const durationMs = 200;

class SlideLeftRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  SlideLeftRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
}

class SlideRightRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  SlideRightRoute({this.widget})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: Duration(milliseconds: durationMs),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}

class SlideTopRoute<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  SlideTopRoute({this.widget})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return widget;
            },
            transitionDuration: Duration(milliseconds: durationMs),
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}

import 'package:flutter/material.dart';
import 'package:nav/route/custom_page_route_builder.dart';

class BlinkRouteBuilder<T> extends CustomPageRouteBuilder<T> {
  final Widget widget;

  BlinkRouteBuilder(this.widget)
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionDuration: const Duration(microseconds: 0),
        );
}

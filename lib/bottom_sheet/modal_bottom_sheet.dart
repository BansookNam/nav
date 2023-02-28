import 'package:flutter/material.dart';

abstract class ModalBottomSheet<T> extends StatelessWidget {
  ModalBottomSheet(
    this.context, {
    this.enableDrag = true,
    this.isDismissible = true,
    this.useSafeArea = false,
    this.handleColor = const Color(0xffdddddd),
    this.backgroundColor = Colors.white,
    this.verticalBorderRadius = 20.0,
    this.handlerWidth = 30.0,
    this.handlerHeight = 4.0,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.barrierColor,
    this.routeSettings,
    this.transitionAnimationController,
    this.anchorPoint,
    this.isScrollControlled = false,
    this.useRootNavigator = false,
  });

  final BuildContext context;
  final bool enableDrag;
  final bool useSafeArea;
  final Color handleColor;
  final Color backgroundColor;
  final double verticalBorderRadius;
  final double handlerWidth;
  final double handlerHeight;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final Color? barrierColor;
  final bool isScrollControlled;
  final bool useRootNavigator;
  final bool isDismissible;
  final RouteSettings? routeSettings;
  final AnimationController? transitionAnimationController;
  final Offset? anchorPoint;

  Widget _buildSheet(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(verticalBorderRadius)),
        color: backgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          // Drawer handler
          if (!enableDrag || handleColor != Colors.transparent)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: handlerWidth,
                  height: handlerHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(handlerHeight / 2),
                    color: handleColor,
                  ),
                ),
              ],
            ),
          SizedBox(height: 25),
          this.build(context),
        ],
      ),
    );
  }

  Future<T?> show() async {
    if (context is StatefulElement && !context.mounted) {
      return null;
    }

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      useSafeArea: useSafeArea,
      backgroundColor: Colors.transparent,
      builder: _buildSheet,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
    );
  }
}

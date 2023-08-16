import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nav_hooks/dialog/dialog_mixin.dart';

import '../enum/enum_nav_ani.dart';
import '../nav.dart';

export 'dialog_state.dart';

abstract class HookDialogWidget<ResultType> extends HookWidget
    with DialogMixin<ResultType> {
  HookDialogWidget({
    Key? key,
    this.animation = NavAni.Fade,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    bool? useRootNavigator,
    bool? useSafeArea,
    this.anchorPoint,
    this.routeSettings,
    this.context,
  })  : useRootNavigator =
            useRootNavigator ?? Nav.navSetting?.useRootNavigator ?? true,
        useSafeArea = useRootNavigator ?? Nav.navSetting?.useSafeArea ?? false,
        super(key: key);

  @override
  final BuildContext? context;
  @override
  final NavAni animation;
  @override
  final bool barrierDismissible;
  @override
  final Color barrierColor;
  @override
  final String? barrierLabel;
  @override
  final Offset? anchorPoint;
  @override
  final RouteSettings? routeSettings;
  @override
  final bool useSafeArea;
  @override
  final bool useRootNavigator;
}

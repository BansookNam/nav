import 'package:flutter/material.dart';
import 'package:nav/src/enum/enum_nav_ani.dart';
import 'package:nav/src/nav_base.dart';
import 'package:nav/src/route/clipper_circle.dart';
import 'package:nav/src/route/nav_transitions.dart';

abstract class DialogWidget<ResultType> extends StatefulWidget {
  DialogWidget({
    super.key,
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
        useSafeArea = useSafeArea ?? Nav.navSetting?.useSafeArea ?? false;

  final BuildContext? context;
  final NavAni animation;
  final bool barrierDismissible;
  final Color barrierColor;
  final String? barrierLabel;
  final Offset? anchorPoint;
  final RouteSettings? routeSettings;
  final bool useSafeArea;
  final bool useRootNavigator;

  /// Per-instance visibility state. A [DialogWidget] instance represents a
  /// single dialog session; this state lives on the widget (not in [State])
  /// because [hide] must work before the dialog is built and after it is
  /// disposed.
  final _DialogVisibility _visibility = _DialogVisibility();

  /// Whether this dialog is currently shown.
  bool get isShown => _visibility.isShowing;

  void onHide() {
    _visibility.isShowing = false;
  }

  Future<ResultType?> show({bool? useRootNavigator}) async {
    final context = this.context ?? Nav.globalContext;
    if (context is StatefulElement && !context.mounted) {
      return null;
    }
    assert(
        !_visibility.isShowing,
        'This DialogWidget instance is already shown. '
        'Create a new instance to show it again.');

    _visibility.isShowing = true;

    if (animation == NavAni.Fade) {
      return showDialog<ResultType>(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator ?? this.useRootNavigator,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
        builder: _rememberContextAndBuild,
      );
    }

    return _showDialogWith<ResultType>(
      animation,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useRootNavigator: useRootNavigator ?? this.useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      context: context,
      builder: _rememberContextAndBuild,
      durationMs: animation == NavAni.Blink ? 0 : Nav.defaultDialogDurationMs,
    );
  }

  Widget _rememberContextAndBuild(BuildContext context) {
    _visibility.builderContext = context;
    return this;
  }

  void hide([ResultType? result]) {
    if (!_visibility.isShowing) {
      return;
    }
    final context =
        _visibility.builderContext ?? this.context ?? Nav.globalContext;
    Nav.pop<ResultType>(context, result: result);
  }
}

/// Mutable visibility state for a single [DialogWidget] instance.
class _DialogVisibility {
  BuildContext? builderContext;
  bool isShowing = false;
}

///build ripple animation transition from right bottom
Widget _buildRippleTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;

  return ClipPath(
    clipper: CircularRevealClipper(
      fraction: animation.value,
      centerAlignment: Alignment.bottomRight,
      centerOffset: const Offset(10, 10),
      minRadius: height + width / 2,
      maxRadius: 10,
    ),
    child: child,
  );
}

Future<T?> _showDialogWith<T>(
  NavAni ani, {
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  String? barrierLabel,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  Color? barrierColor,
  bool useRootNavigator = true,
  int durationMs = Nav.defaultDialogDurationMs,
}) {
  assert(debugCheckHasMaterialLocalizations(context));

  final ThemeData theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return Builder(builder: (BuildContext context) {
        return Theme(data: theme, child: pageChild);
      });
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel ??
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    barrierColor: barrierColor ?? Colors.black54,
    transitionDuration: Duration(milliseconds: durationMs),
    transitionBuilder: _getTransition(ani),
  );
}

RouteTransitionsBuilder _getTransition(NavAni ani) {
  switch (ani) {
    case NavAni.Left:
      return slideTransitionBuilder(const Offset(-1.0, 0.0),
          curve: dialogTransitionCurve);
    case NavAni.Right:
      return slideTransitionBuilder(const Offset(1.0, 0.0),
          curve: dialogTransitionCurve);
    case NavAni.Top:
      return slideTransitionBuilder(const Offset(0.0, -1.0),
          curve: dialogTransitionCurve);
    case NavAni.Bottom:
      return slideTransitionBuilder(const Offset(0.0, 1.0),
          curve: dialogTransitionCurve);
    case NavAni.Ripple:
      return _buildRippleTransition;
    case NavAni.Blink:
    case NavAni.Fade:
      return fadeTransitionBuilder;
  }
}

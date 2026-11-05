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
    this.animationDuration,
    this.animationCurve,
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

  /// How long [animation] runs, opening and closing. Null:
  /// [Nav.defaultDialogDurationMs] (0 for [NavAni.Blink]). [NavAni.Fade] is
  /// Material's own `showDialog` fade while this and [animationCurve] are both
  /// null; once either is set (here or in [show]) Nav draws the fade instead.
  final Duration? animationDuration;

  /// Easing of the slides and of [NavAni.Fade]. Null: [dialogTransitionCurve].
  /// Not used by [NavAni.Ripple] (its own reveal) or [NavAni.Blink].
  final Curve? animationCurve;

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

  /// Shows the dialog. [animationDuration] / [animationCurve] override the
  /// ones given to the constructor for this one showing.
  Future<ResultType?> show({
    bool? useRootNavigator,
    Duration? animationDuration,
    Curve? animationCurve,
  }) async {
    final duration = animationDuration ?? this.animationDuration;
    final curve = animationCurve ?? this.animationCurve;
    final context = this.context ?? Nav.globalContext;
    if (context is StatefulElement && !context.mounted) {
      return null;
    }
    assert(
        !_visibility.isShowing,
        'This DialogWidget instance is already shown. '
        'Create a new instance to show it again.');

    _visibility.isShowing = true;

    if (animation == NavAni.Fade && duration == null && curve == null) {
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
      duration: duration ??
          Duration(
              milliseconds:
                  animation == NavAni.Blink ? 0 : Nav.defaultDialogDurationMs),
      curve: curve,
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
  required Duration duration,
  Curve? curve,
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
    transitionDuration: duration,
    transitionBuilder: _getTransition(ani, curve ?? dialogTransitionCurve),
  );
}

RouteTransitionsBuilder _getTransition(NavAni ani, Curve curve) {
  return switch (ani) {
    NavAni.Left =>
      slideTransitionBuilder(const Offset(-1.0, 0.0), curve: curve),
    NavAni.Right =>
      slideTransitionBuilder(const Offset(1.0, 0.0), curve: curve),
    NavAni.Top => slideTransitionBuilder(const Offset(0.0, -1.0), curve: curve),
    NavAni.Bottom =>
      slideTransitionBuilder(const Offset(0.0, 1.0), curve: curve),
    NavAni.Ripple => _buildRippleTransition,
    // NavAni.Fade goes through showDialog unless a duration / curve is given
    // (see show()); it is grouped with Blink so the switch stays exhaustive.
    NavAni.Blink => fadeTransitionBuilder,
    NavAni.Fade => _fadeWithCurve(curve),
  };
}

RouteTransitionsBuilder _fadeWithCurve(Curve curve) {
  return (BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: curve),
      child: child,
    );
  };
}

import 'package:flutter/material.dart';
import 'package:nav/dialog/mutable_value.dart';
import 'package:nav/enum/enum_nav_ani.dart';
import 'package:nav/nav.dart';
import 'package:nav/route/clipper_circle.dart';

export 'package:nav/dialog/dialog_state.dart';

abstract class DialogWidget<ResultType> extends StatefulWidget {
  DialogWidget(this.context, {Key? key}) : super(key: key);

  final BuildContext context;
  NavAni get ani => NavAni.Fade;
  bool get barrierDismissible => true;
  Color get barrierColor => Colors.black54;
  final MutableValue<BuildContext?> _context = MutableValue(null); //context when dialog is actually use on navigator
  final MutableValue<bool> isShown =
      MutableValue(false); //use final reference wrapper to ingnore must_be_immutable lint

  void onHide() {
    isShown.value = false;
  }

  Future<ResultType?> show() async {
    if (context is StatefulElement && !context.mounted) {
      return null;
    }

    isShown.value = true;
    switch (ani) {
      case NavAni.Left:
      case NavAni.Right:
      case NavAni.Top:
      case NavAni.Bottom:
        return _showDialogWith<ResultType>(
          ani,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          context: context,
          builder: (context) {
            _context.value = context;
            return this;
          },
        );
      case NavAni.Blink:
        return _showDialogWith<ResultType>(
          ani,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          context: context,
          builder: (context) {
            _context.value = context;
            return this;
          },
          durationMs: 0,
        );
      case NavAni.Ripple:
        return _showDialogWith<ResultType>(
          ani,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          context: context,
          builder: (context) {
            _context.value = context;
            return this;
          },
        );
      case NavAni.Fade:
      default:
        return showDialog<ResultType>(
          context: context,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          builder: (context) {
            _context.value = context;
            return this;
          },
        );
    }
  }

  void hide([ResultType? result]) {
    if (!isShown.value) {
      return;
    }
    Nav.pop<ResultType>(_context.value ?? context, result: result);
  }
}

///build fade animation transition
Widget _buildFromFadeTransition(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
    child: child,
  );
}

///build moving from top to bottom animation transition
Widget _buildFromTopTransition(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Cubic(0.4, 0, 0.2, 1))).animate(animation),
    child: child,
  );
}

///build moving from bottom to top animation transition
Widget _buildFromBottomTransition(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Cubic(0.4, 0, 0.2, 1))).animate(animation),
    child: child,
  );
}

///build moving from right to left animation transition
Widget _buildFromRightTransition(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Cubic(0.4, 0, 0.2, 1))).animate(animation),
    child: child,
  );
}

///build moving from left to right animation transition
Widget _buildFromLeftTransition(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: Cubic(0.4, 0, 0.2, 1))).animate(animation),
    child: child,
  );
}

///build ripple animation transition from right bottom
Widget _buildRippleTransition(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  if (Nav.height == null) {
    Nav.initDeviceSize(context);
  }
  return ClipPath(
    clipper: CircularRevealClipper(
      fraction: animation.value,
      centerAlignment: Alignment.bottomRight,
      centerOffset: const Offset(10, 10),
      minRadius: Nav.height! + Nav.width / 2,
      maxRadius: 10,
    ),
    child: child,
  );
}

Future<T?> _showDialogWith<T>(
  NavAni ani, {
  required BuildContext context,
  bool barrierDismissible = true,
  @Deprecated('Instead of using the "child" argument, return the child from a closure '
      'provided to the "builder" argument. This will ensure that the BuildContext '
      'is appropriate for widgets built in the dialog. '
      'This feature was deprecated after v0.2.3.')
      Widget? child,
  WidgetBuilder? builder,
  Color? barrierColor,
  bool useRootNavigator = true,
  int durationMs = 500,
}) {
  assert(child == null || builder == null);
  assert(debugCheckHasMaterialLocalizations(context));

  final ThemeData theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
      final Widget pageChild = child ?? Builder(builder: builder!);
      return Builder(builder: (BuildContext context) {
        return Theme(data: theme, child: pageChild);
      });
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor ?? Colors.black54,
    transitionDuration: Duration(milliseconds: durationMs),
    transitionBuilder: _getTransition(ani),
  );
}

Widget Function(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child)
    _getTransition(NavAni ani) {
  switch (ani) {
    case NavAni.Left:
      return _buildFromLeftTransition;
    case NavAni.Right:
      return _buildFromRightTransition;
    case NavAni.Top:
      return _buildFromTopTransition;
    case NavAni.Bottom:
      return _buildFromBottomTransition;
    case NavAni.Ripple:
      return _buildRippleTransition;
    case NavAni.Blink:
    case NavAni.Fade:
    default:
      return _buildFromFadeTransition;
  }
}

import 'package:flutter/material.dart';

class PressedChangeButton extends StatefulWidget {
  PressedChangeButton({
    Key? key,
    this.child,
    this.pressedColor = const Color(0xffDCDEEA),
    this.bgColor = Colors.white,
    this.onTap,
    this.roundTop = false,
    this.paddingBottom = 0,
    this.paddingTop = 0,
    this.forcePressedColor = false,
  }) : super(key: key);

  final Widget? child;
  final Color pressedColor;
  final Color bgColor;
  final Function()? onTap;
  final bool roundTop;
  final bool forcePressedColor;
  final double paddingBottom;
  final double paddingTop;

  @override
  _PressedChangeButtonState createState() => _PressedChangeButtonState();
}

class _PressedChangeButtonState extends State<PressedChangeButton> {
  bool isPressed = false;
  final duration = const Duration(milliseconds: 100);
  final radius = const Radius.circular(14);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (datail) {
        setState(() {
          isPressed = true;
        });
      },
      onTap: () {
        Function()? onTap = widget.onTap;
        if (onTap != null) {
          onTap();
        }
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTapUp: (datail) {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        padding: EdgeInsets.only(
            bottom: widget.paddingBottom, top: widget.paddingTop),
        duration: duration,
        curve: Curves.linear,
        color: widget.roundTop
            ? null
            : (isPressed || widget.forcePressedColor)
                ? widget.pressedColor
                : widget.bgColor,
        decoration: !widget.roundTop
            ? null
            : new BoxDecoration(
                color: (isPressed || widget.forcePressedColor)
                    ? widget.pressedColor
                    : widget.bgColor,
                borderRadius:
                    BorderRadius.only(topLeft: radius, topRight: radius)),
        child: widget.child,
      ),
    );
  }
}

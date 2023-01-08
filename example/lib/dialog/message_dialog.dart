import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nav/dialog/dialog.dart';
import 'package:nav/enum/enum_nav_ani.dart';

class MessgaeDialog extends DialogWidget {
  final NavAni ani = NavAni.Fade;
  final Color barrierColor = Colors.white.withOpacity(0.3);
  final bool barrierDismissible = false;
  final bool isCancelOnBack = false;

  MessgaeDialog(BuildContext context) : super(context);

  @override
  State<StatefulWidget> createState() {
    return _DialogState(onHide);
  }
}

class _DialogState extends DialogState<MessgaeDialog> {
  _DialogState(Function() onHide) : super(onHide);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Platform.isIOS
          ? null
          : () async {
              return widget.isCancelOnBack;
            },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            child: Center(
              child: Container(
                color: Colors.white,
                width: 300,
                height: 300,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      widget.hide();
                    },
                    child: Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text("Test Dialog",
                          style: TextStyle(color: Colors.white)),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nav/dialog/dialog.dart';
import 'package:nav/enum/enum_nav_ani.dart';

class MessageDialog extends DialogWidget {
  final bool isCancelOnBack = false;

  MessageDialog({BuildContext? context})
      : super(
          context: context,
          animation: NavAni.Fade,
          barrierColor: Colors.black.withOpacity(0.5),
          barrierDismissible: false,
        );

  @override
  State<StatefulWidget> createState() {
    return _DialogState();
  }
}

class _DialogState extends DialogState<MessageDialog> {
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
            color: Colors.transparent,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nav/dialog/dialog.dart';
import 'package:nav/enum/enum_nav_ani.dart';

class MessageDialog extends DialogWidget {
  final bool isCancelOnBack = false;
  final String text;

  MessageDialog(this.text, {super.key, super.context})
      : super(
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
    return PopScope(
      canPop: Platform.isIOS ? true : widget.isCancelOnBack,
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
                      alignment: Alignment.center,
                      child: Text(widget.text,
                          style: const TextStyle(color: Colors.white)),
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

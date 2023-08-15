import 'package:flutter/material.dart';

import 'dialog.dart';

abstract class DialogState<T extends DialogWidget> extends State<T> {
  Function()? onHide;

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    onHide = widget.onHide;
  }

  @override
  void dispose() {
    if (onHide != null) {
      onHide!();
    }
    super.dispose();
  }
}

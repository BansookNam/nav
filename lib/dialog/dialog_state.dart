import 'package:flutter/material.dart';

abstract class DialogState<T extends StatefulWidget> extends State<T> {
  final Function() onHide;

  DialogState(this.onHide);

  @override
  void dispose() {
    onHide();
    super.dispose();
  }
}

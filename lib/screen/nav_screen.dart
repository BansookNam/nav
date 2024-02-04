import 'package:flutter/material.dart';

import '../nav.dart';

abstract mixin class NavScreen<Result> implements Widget {
  void popResult(BuildContext context, Result result) {
    Nav.pop<Result>(context, result: result);
  }
}

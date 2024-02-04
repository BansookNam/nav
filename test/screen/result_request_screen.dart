import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:nav/screen/nav_screen.dart';

import 'result_screen.dart';
import 'simple_result.dart';

abstract class ResultController {
  void onSuccess(String data) {}

  void onFail() {}

  ResultController();
}

class ResultRequestScreen extends StatelessWidget with NavScreen<SimpleResult<String, void>> {
  final ResultController controller;

  const ResultRequestScreen(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Result Request Screen'),
          GestureDetector(
            child: const Text('Open Result Screen'),
            onTap: () async {
              final result = await Nav.pushResult(const ResultScreen());
              result?.runIfSuccess((data) {
                controller.onSuccess(data);
              });
              result?.runIfFailure((data) {
                controller.onFail();
              });
            },
          )
        ],
      ),
    );
  }
}

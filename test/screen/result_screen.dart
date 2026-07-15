import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

import 'simple_result.dart';

class ResultScreen extends StatelessWidget
    with NavScreen<SimpleResult<String, void>> {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Result Screen'),
          GestureDetector(
            onTap: () {
              popResult(context, SimpleResult.success('data value'));
            },
            child: const Text('pop'),
          )
        ],
      ),
    );
  }
}

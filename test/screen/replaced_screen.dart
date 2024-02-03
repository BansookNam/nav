import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

class ReplacedScreen extends StatelessWidget {
  const ReplacedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('ReplacedScreen'),
          GestureDetector(
            onTap: () {
              Nav.pop(context);
            },
            child: const Text('pop'),
          )
        ],
      ),
    );
  }
}

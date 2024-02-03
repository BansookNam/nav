import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

class SampleScreen extends StatelessWidget {
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Sample Screen'),
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

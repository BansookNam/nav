import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

class ReplacedScreen extends StatelessWidget {
  ReplacedScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('ReplacedScreen'),
          GestureDetector(
            onTap: () {
              Nav.pop(context);
            },
            child: Text('pop'),
          )
        ],
      ),
    );
  }
}

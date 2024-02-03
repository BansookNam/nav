import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

class SampleScreen extends StatelessWidget {
  SampleScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Sample Screen'),
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

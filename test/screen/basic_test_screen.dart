import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

class BasicTestScreen extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const BasicTestScreen({super.key});

  @override
  State<BasicTestScreen> createState() => _BasicTestScreenState();
}

class _BasicTestScreenState extends State<BasicTestScreen> with Nav {
  final changedKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    setGlobalKey(changedKey);
    super.initState();
  }

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

  @override
  GlobalKey<NavigatorState> get navigatorKey => BasicTestScreen.navigatorKey;
}

import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

class NavAppForTesting extends StatefulWidget {
  final Widget child;
  static final globalNavigatorKey = GlobalKey<NavigatorState>();

  const NavAppForTesting({super.key, required this.child});

  @override
  State<NavAppForTesting> createState() => _NavAppForTestingState();
}

class _NavAppForTestingState extends State<NavAppForTesting> with Nav {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey =>
      NavAppForTesting.globalNavigatorKey;
}

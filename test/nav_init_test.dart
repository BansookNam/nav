import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/nav.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Nav throws a helpful StateError before initialization', () {
    // This file runs in its own isolate, so Nav has not been initialized.
    expect(() => Nav.globalContext, throwsStateError);
    expect(() => Nav.canPop(), throwsStateError);
  });

  test('Nav.init initializes the global navigator key', () {
    final key = GlobalKey<NavigatorState>();
    Nav.init(key, setting: NavSetting(useRootNavigator: true));

    // Initialized: no StateError anymore (currentState is null — no widget
    // tree — but the key lookup itself succeeds).
    expect(Nav.navigatorState(null), isNull);
    expect(Nav.navSetting?.useRootNavigator, true);
  });

  test('NavAni lowercase aliases point to the same values', () {
    expect(NavAni.left, NavAni.Left);
    expect(NavAni.right, NavAni.Right);
    expect(NavAni.top, NavAni.Top);
    expect(NavAni.bottom, NavAni.Bottom);
    expect(NavAni.fade, NavAni.Fade);
    expect(NavAni.ripple, NavAni.Ripple);
    expect(NavAni.blink, NavAni.Blink);
  });
}

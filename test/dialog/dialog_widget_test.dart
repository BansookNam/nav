import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/dialog/dialog.dart';

class _ProbeDialog extends DialogWidget<void> {
  _ProbeDialog({super.useSafeArea, super.useRootNavigator});

  @override
  State<_ProbeDialog> createState() => _ProbeDialogState();
}

class _ProbeDialogState extends DialogState<_ProbeDialog> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  test('useSafeArea parameter is honored', () {
    expect(_ProbeDialog(useSafeArea: true).useSafeArea, true);
    expect(_ProbeDialog(useSafeArea: false).useSafeArea, false);
  });

  test('useSafeArea is independent of useRootNavigator', () {
    // Regression: useSafeArea was initialized from the useRootNavigator
    // parameter, so passing useRootNavigator: true silently turned
    // useSafeArea on and the useSafeArea parameter was ignored.
    final dialog = _ProbeDialog(useSafeArea: false, useRootNavigator: true);
    expect(dialog.useSafeArea, false);
    expect(dialog.useRootNavigator, true);

    final dialog2 = _ProbeDialog(useSafeArea: true, useRootNavigator: false);
    expect(dialog2.useSafeArea, true);
    expect(dialog2.useRootNavigator, false);
  });

  test('useSafeArea defaults to false when not provided', () {
    expect(_ProbeDialog().useSafeArea, false);
    expect(_ProbeDialog(useRootNavigator: true).useSafeArea, false);
  });
}

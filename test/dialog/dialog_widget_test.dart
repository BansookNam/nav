import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/nav.dart';
import 'package:nav/testing.dart';

class _ProbeDialog extends DialogWidget<void> {
  _ProbeDialog({
    super.useSafeArea,
    super.useRootNavigator,
    super.animation,
    super.animationDuration,
    super.animationCurve,
  });

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

  testWidgets('isShown reflects the dialog lifecycle',
      (WidgetTester tester) async {
    await tester.pumpWidget(NavAppForTesting(child: Container()));

    final dialog = _ProbeDialog();
    expect(dialog.isShown, false);

    dialog.show();
    await tester.pump();
    expect(dialog.isShown, true);

    dialog.hide();
    await tester.pumpAndSettle();
    expect(dialog.isShown, false);
  });

  // Time until the dialog's route has finished its transition.
  Future<int> settleMs(WidgetTester tester) async {
    var ms = 0;
    while (tester.binding.hasScheduledFrame && ms < 2000) {
      await tester.pump(const Duration(milliseconds: 10));
      ms += 10;
    }
    return ms;
  }

  group('animation props', () {
    testWidgets('default slide takes Nav.defaultDialogDurationMs',
        (tester) async {
      await tester.pumpWidget(NavAppForTesting(child: Container()));
      _ProbeDialog(animation: NavAni.Bottom).show();
      await tester.pump();
      final ms = await settleMs(tester);
      expect(
          ms,
          inInclusiveRange(Nav.defaultDialogDurationMs - 20,
              Nav.defaultDialogDurationMs + 20));
    });

    testWidgets('animationDuration in the constructor', (tester) async {
      await tester.pumpWidget(NavAppForTesting(child: Container()));
      _ProbeDialog(
              animation: NavAni.Bottom,
              animationDuration: const Duration(milliseconds: 250))
          .show();
      await tester.pump();
      expect(await settleMs(tester), inInclusiveRange(230, 270));
    });

    testWidgets('show() overrides the constructor', (tester) async {
      await tester.pumpWidget(NavAppForTesting(child: Container()));
      _ProbeDialog(
              animation: NavAni.Bottom,
              animationDuration: const Duration(milliseconds: 250))
          .show(animationDuration: const Duration(milliseconds: 100));
      await tester.pump();
      expect(await settleMs(tester), inInclusiveRange(80, 120));
    });

    testWidgets('show() duration applies to NavAni.Ripple', (tester) async {
      await tester.pumpWidget(NavAppForTesting(child: Container()));
      _ProbeDialog(animation: NavAni.Ripple)
          .show(animationDuration: const Duration(milliseconds: 700));
      await tester.pump();
      expect(await settleMs(tester), inInclusiveRange(680, 720));
    });

    testWidgets('animationCurve shapes the slide', (tester) async {
      await tester.pumpWidget(NavAppForTesting(child: Container()));
      _ProbeDialog(
        animation: NavAni.Bottom,
        animationDuration: const Duration(milliseconds: 200),
        animationCurve: Curves.linear,
      ).show();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final slide = tester.widget<SlideTransition>(find
          .ancestor(
              of: find.byType(_ProbeDialog),
              matching: find.byType(SlideTransition))
          .first);
      // Half way through, linear: half the sheet is still below the screen.
      expect(slide.position.value.dy, closeTo(0.5, 0.05));
    });

    testWidgets('a duration also applies to NavAni.Fade', (tester) async {
      await tester.pumpWidget(NavAppForTesting(child: Container()));
      _ProbeDialog(animationDuration: const Duration(milliseconds: 300)).show();
      await tester.pump();
      expect(await settleMs(tester), inInclusiveRange(280, 320));
    });
  });
}

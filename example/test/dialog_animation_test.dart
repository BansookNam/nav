import 'package:example/dialog/dialog_animation_demo.dart';
import 'package:example/dialog/panel_dialog.dart';
import 'package:example/dialog/show_override_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Pumps 10 ms frames until the open dialog's route has finished its
// transition (the tap's ink splash keeps frames coming longer than that);
// returns the time it took.
Future<int> settleMs(WidgetTester tester) async {
  var ms = 0;
  await tester.pump();
  final route = ModalRoute.of(tester.element(find.byType(PanelDialog)))!;
  while (route.animation!.status != AnimationStatus.completed && ms < 3000) {
    await tester.pump(const Duration(milliseconds: 10));
    ms += 10;
  }
  return ms;
}

void main() {
  group('DialogAnimationDemo', () {
    testWidgets('the chosen duration and result reach the dialog',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DialogAnimationDemo()));
      // Default: Bottom, 250 ms.
      await tester.tap(find.byKey(const Key('show')));
      await tester.pump();
      expect(await settleMs(tester), inInclusiveRange(230, 270));
      expect(find.text('Bottom · 250 ms · default'), findsOneWidget);

      await tester.tap(find.byKey(const Key('panel-ok')));
      await tester.pumpAndSettle();
      expect(find.text('Last result: ok'), findsOneWidget);
    });

    testWidgets('another animation, curve and duration', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DialogAnimationDemo()));
      await tester.tap(find.byKey(const Key('ani-Fade')));
      await tester.tap(find.byKey(const Key('curve-linear')));
      await tester.drag(
          find.byKey(const Key('duration')), const Offset(-1000, 0));
      await tester.pump();
      await tester.tap(find.byKey(const Key('show')));
      await tester.pump();
      // Duration slid to 0: the dialog is there at once.
      expect(await settleMs(tester), lessThanOrEqualTo(20));
      expect(find.byType(PanelDialog), findsOneWidget);
      await tester.tap(find.byKey(const Key('panel-later')));
      await tester.pumpAndSettle();
      expect(find.text('Last result: later'), findsOneWidget);
    });
  });

  group('ShowOverrideDemo', () {
    testWidgets('show() overrides the constructor for one showing',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ShowOverrideDemo()));

      await tester.tap(find.byKey(const Key('default-show')));
      await tester.pump();
      expect(await settleMs(tester), inInclusiveRange(230, 270));
      await tester.tap(find.byKey(const Key('panel-ok')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('slow-show')));
      await tester.pump();
      expect(await settleMs(tester), inInclusiveRange(980, 1020));
      await tester.tap(find.byKey(const Key('panel-later')));
      await tester.pumpAndSettle();
      expect(find.textContaining('show() 1 s bounce → later'), findsOneWidget);
    });
  });
}

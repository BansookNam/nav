import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nav/nav.dart';
import 'package:nav/testing.dart';

class _TestSheet extends ModalBottomSheet<String> {
  _TestSheet({
    super.enableDrag,
    super.handleColor,
    super.isScrollControlled,
  });

  @override
  Widget build(BuildContext context) => const Text('sheet content');
}

Future<void> pumpNavApp(WidgetTester tester) async {
  await tester.pumpWidget(NavAppForTesting(child: Container()));
}

void main() {
  testWidgets('show displays the sheet with a drag handle',
      (WidgetTester tester) async {
    await pumpNavApp(tester);

    _TestSheet().show();
    await tester.pumpAndSettle();

    expect(find.text('sheet content'), findsOneWidget);

    // Default handle: a small rounded Container with the handle color.
    final handle = tester.widgetList<Container>(find.byType(Container)).where(
        (c) =>
            (c.decoration as BoxDecoration?)?.color == const Color(0xffdddddd));
    expect(handle, isNotEmpty);
  });

  testWidgets('hide pops the sheet and resolves show() with the result',
      (WidgetTester tester) async {
    await pumpNavApp(tester);

    final sheet = _TestSheet();
    final result = sheet.show();
    await tester.pumpAndSettle();
    expect(find.text('sheet content'), findsOneWidget);

    sheet.hide('picked');
    await tester.pumpAndSettle();

    expect(find.text('sheet content'), findsNothing);
    expect(await result, 'picked');
  });

  testWidgets('hide without result resolves show() with null',
      (WidgetTester tester) async {
    await pumpNavApp(tester);

    final sheet = _TestSheet();
    final result = sheet.show();
    await tester.pumpAndSettle();

    sheet.hide();
    await tester.pumpAndSettle();

    expect(await result, isNull);
  });

  testWidgets('transparent handle color hides the drag handle',
      (WidgetTester tester) async {
    await pumpNavApp(tester);

    _TestSheet(enableDrag: true, handleColor: Colors.transparent).show();
    await tester.pumpAndSettle();

    expect(find.text('sheet content'), findsOneWidget);
    final handle = tester.widgetList<Container>(find.byType(Container)).where(
        (c) => (c.decoration as BoxDecoration?)?.color == Colors.transparent);
    expect(handle, isEmpty);
  });

  testWidgets('isScrollControlled parameter is honored',
      (WidgetTester tester) async {
    await pumpNavApp(tester);

    // Regression: show() hardcoded isScrollControlled: true and ignored the
    // constructor parameter.
    _TestSheet(isScrollControlled: false).show();
    await tester.pumpAndSettle();
    expect(find.text('sheet content'), findsOneWidget);
  });
}

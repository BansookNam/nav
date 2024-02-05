import 'package:flutter/material.dart';
import 'package:nav/bottom_sheet/modal_bottom_sheet.dart';
import 'package:nav/screen/nav_screen.dart';

import '../dialog/bottom_sheet_dialog.dart';
import '../screen/simple_result.dart';
import '../widget/pressed_change_button.dart';

class BottomSheetExample extends ModalBottomSheet
    with NavScreen<SimpleResult<String, void>> {
  final List<BottomSheetItem> bottomSheetItemList;

  BottomSheetExample(
    this.bottomSheetItemList, {
    super.key,
    super.context,
  });

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(10);
    final mediaQuery = MediaQuery.of(context);
    final viewPaddingBottom = mediaQuery.viewPadding.bottom;
    final width = mediaQuery.size.width;
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: viewPaddingBottom + 10, top: 10),
              width: width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: radius, topRight: radius)),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text("This is modal bottom sheet",
                        style: TextStyle(
                            color: Color(0xff777777),
                            fontWeight: FontWeight.bold)),
                  ),
                  ...getItemList(context),
                  PressedChangeButton(
                    onTap: () {
                      popResult(context, SimpleResult.failure());
                    },
                    forcePressedColor: false,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("Cancel",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getItemList(BuildContext context) {
    List<Widget> list = [];
    for (var item in bottomSheetItemList) {
      list.add(PressedChangeButton(
        onTap: () {
          popResult(context, SimpleResult.success(item.title));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: item.icon,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(item.title),
            )
          ],
        ),
      ));
    }
    return list;
  }
}

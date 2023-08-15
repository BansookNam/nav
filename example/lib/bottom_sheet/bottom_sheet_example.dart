import 'package:example/widget/w_pressed_change_button.dart';
import 'package:flutter/material.dart';
import 'package:nav_hooks/bottom_sheet/modal_bottom_sheet.dart';

import '../dialog/bottom_sheet_dialog.dart';

class BottomSheetExample extends ModalBottomSheet<String> {
  final List<BottomSheetItem> bottomSheetItemList;

  BottomSheetExample(
    this.bottomSheetItemList, {
    BuildContext? context,
  }) : super(context: context);

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(10);
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
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: radius, topRight: radius)),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Text("This is modal bottom sheet",
                        style: TextStyle(
                            color: Color(0xff777777),
                            fontWeight: FontWeight.bold)),
                  ),
                  ...getItemList(context),
                  PressedChangeButton(
                    onTap: () {
                      hide("Cancel");
                    },
                    forcePressedColor: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20.0),
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
    bottomSheetItemList.forEach((item) {
      list.add(PressedChangeButton(
        onTap: () {
          hide(item.title);
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
    });
    return list;
  }
}

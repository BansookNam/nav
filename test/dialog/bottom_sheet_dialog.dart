import 'package:flutter/material.dart';
import 'package:nav/dialog/dialog.dart';
import 'package:nav/enum/enum_nav_ani.dart';
import 'package:nav/nav.dart';
import 'package:nav/screen/nav_screen.dart';

import '../screen/simple_result.dart';
import '../widget/pressed_change_button.dart';

class BottomSheetItem {
  final String title;
  final Icon icon;

  BottomSheetItem(this.title, this.icon);
}

class BottomSheetDialog extends DialogWidget with NavScreen<SimpleResult<String,void>> {
  final List<BottomSheetItem> bottomSheetItemList;
  final String? title;
  final bool showCancel;
  final MainAxisAlignment mainAxisAlignment;

  BottomSheetDialog(
    this.bottomSheetItemList, {super.key,
    super.context,
    this.showCancel = false,
    this.title,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(
          barrierDismissible: false,
          animation: NavAni.Bottom,
        );

  @override
  State<StatefulWidget> createState() {
    return _DialogState();
  }
}

class _DialogState extends DialogState<BottomSheetDialog> {
  var isChecked = false;
  String? selectedTitle;

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(10);
    final mediaQuery = MediaQuery.of(context);
    final viewPaddingBottom = mediaQuery.viewPadding.bottom;
    final width = mediaQuery.size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Material(
          child: Container(
            padding: EdgeInsets.only(bottom: viewPaddingBottom + 10, top: 10),
            width: width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(topLeft: radius, topRight: radius)),
            child: Column(
              children: <Widget>[
                if (widget.title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(widget.title ?? "",
                        style: const TextStyle(
                            color: Color(0xff777777),
                            fontWeight: FontWeight.bold)),
                  ),
                ...getItemList(context),
                if (widget.showCancel)
                  PressedChangeButton(
                    onTap: () {
                      setState(() {
                        selectedTitle = "Cancel";
                      });
                      widget.popWithResult(context, SimpleResult.failure());
                    },
                    forcePressedColor: selectedTitle == "Cancel",
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
        ),
      ],
    );
  }

  getItemList(BuildContext context) {
    List<Widget> list = [];
    for (var item in widget.bottomSheetItemList) {
      list.add(PressedChangeButton(
        onTap: () {
          setState(() {
            selectedTitle = item.title;
          });
          widget.popWithResult(context, SimpleResult.success(item.title));
        },
        forcePressedColor: selectedTitle == item.title,
        child: Row(
          mainAxisAlignment: widget.mainAxisAlignment,
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

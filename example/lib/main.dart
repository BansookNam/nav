import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:example/enum_direction.dart';
import 'package:example/util/u_color_generator.dart';
import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with Nav {
  @override
  GlobalKey<NavigatorState> get navigatorKey => MyApp.navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Nav Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.navType}) : super(key: key);

  final NavType navType;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AfterLayoutMixin {
  bool showBackButton = false;
  Color bgColor;

  bool get isHome => !showBackButton;

  @override
  void initState() {
    bgColor = getRandomColor();
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    //to pushRoundFromBottomRight method you should init once
    Nav.initInsideOfApp(context);
    checkCanPop();
  }

  void checkCanPop() async {
    if (await Nav.canPop()) {
      setState(() {
        this.showBackButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async => onResult(
              context,
              await Nav.pushRoundFromBottomRight(MyHomePage(
                navType: NavType.Float,
              ))),
          tooltip: 'Ripple',
          child: Icon(Icons.open_in_new),
        ),
      ),
      body: Builder(
          builder: (context) => SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async => onResult(context, await Nav.pushFromTop(MyHomePage(navType: NavType.Top))),
                              icon: icon(Icons.vertical_align_bottom),
                            )
                          ],
                        ),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      onResult(context, await Nav.pushFromLeft(MyHomePage(navType: NavType.Left)));
                                    },
                                    icon: icon(Icons.keyboard_arrow_right),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        child: icon(iconData),
                                        onTap: () {
                                          //Nav.pop(context, result: {Nav.RESULT: Nav.SUCCESS, "extraParam": 123});
                                          //If there is no extra param you want, just call simple method below.
                                          Nav.popResultSuccess(context);
                                        },
                                      ),
                                      isHome ? Text("Click an Arrow", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)) : Container(),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () async => onResult(context, await Nav.pushFromRight(MyHomePage(navType: NavType.Right))),
                                    icon: icon(Icons.keyboard_arrow_left),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async => onResult(context, await Nav.pushFromBottom(MyHomePage(navType: NavType.Bottom))),
                              icon: icon(Icons.vertical_align_top),
                            )
                          ],
                        ),
                      ],
                    ),
                    !showBackButton
                        ? Container()
                        : IconButton(
                            onPressed: () => Nav.pop(context),
                            icon: icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                          )
                  ],
                ),
              )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Icon icon(IconData data) {
    return Icon(
      data,
      size: 30,
      color: Colors.white,
    );
  }

  IconData get iconData {
    switch (widget.navType) {
      case NavType.Top:
        return Icons.vertical_align_top;
      case NavType.Bottom:
        return Icons.vertical_align_bottom;
      case NavType.Left:
        return Icons.keyboard_arrow_left;
      case NavType.Right:
        return Icons.keyboard_arrow_right;
      case NavType.Float:
        return Icons.archive;
        break;
      default:
        return Icons.home;
    }
  }

  SnackBar createSnackBar(BuildContext context, String message) {
    return SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.transparent,
        content: GestureDetector(
          onTap: () {
            //Scaffold.of(context).hideCurrentSnackBar();
          },
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                      child: Center(
                        child: Text(message,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                            )),
                      ),
                      decoration: new BoxDecoration(color: Color(0xff5a8fee), borderRadius: BorderRadius.circular(5))),
                ),
              ],
            ),
          ),
        ));
  }

  void onResult(BuildContext context, dynamic result) {
    if (Nav.isSuccess(result)) {
      final snackbar = createSnackBar(context, "Result is Success: ${result.toString()}");
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }
}

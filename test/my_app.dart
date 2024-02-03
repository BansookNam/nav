import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

import 'dialog/message_dialog.dart';

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with Nav {
  @override
  GlobalKey<NavigatorState> get navigatorKey => MyApp.navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      textStyle: const TextStyle(color: Colors.black),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Nav Demo',
        theme: ThemeData(
          // Define the default font family.
            fontFamily: 'DMSans',
            scaffoldBackgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.blue),
            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: const TextTheme(),
            bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.transparent)),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  bool showBackButton = false;
  Color? bgColor;

  bool get isHome => !showBackButton;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () async {
            final result = await MessageDialog('Test String').show();
            if (kDebugMode) {
              print(result);
            }

            // ignore: unused_local_variable
            // final result = await BottomSheetDialog(
            //   [
            //     BottomSheetItem("Share", Icon(Icons.share)),
            //     BottomSheetItem("Download", Icon(Icons.download)),
            //     BottomSheetItem("Close", Icon(Icons.close)),
            //   ],
            // ).show();
            // final result = await BottomSheetExample(context, [
            //   BottomSheetItem("Share", Icon(Icons.share)),
            //   BottomSheetItem("Download", Icon(Icons.download)),
            //   BottomSheetItem("Close", Icon(Icons.close)),
            // ]).show();
          },
          // onPressed: () async => onResult(
          //     context,
          //     await Nav.pushWithRippleEffect(MyHomePage(
          //       navType: NavType.Ripple,
          //     ))),
          tooltip: 'Ripple',
          child: const Icon(Icons.open_in_new),
        ),
      ),
      body: Builder(
          builder: (context) => SafeArea(
            child: Container(),
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
}

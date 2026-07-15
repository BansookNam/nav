# Welcome to Nav 👋
[![Version](https://img.shields.io/pub/v/nav.svg?style=flat-square)](https://pub.dev/packages/nav)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache2.0-yellow.svg)](https://github.com/BansookNam/nav/blob/master/LICENSE)

<img src="https://raw.githubusercontent.com/BansookNam/nav/master/img/nav-tag.png" align="left" width="500">


  Provide an easy way to navigate. Includes lots of routers. Available On Android & iOS


<img src="https://raw.githubusercontent.com/BansookNam/nav/master/img/sample.gif" width="300" />

## Install

Add nav dependency on your pubspec.yaml file

```yaml
nav: ^{latest version}
```

## Usage

1. Add the `Nav` mixin on your App State

```dart
import 'package:nav/nav.dart';

class MyAppState extends State<MyApp> with Nav
```

2. Override `navigatorKey` and provide the same key you pass to `MaterialApp.navigatorKey`

```dart
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with Nav {
  @override
  GlobalKey<NavigatorState> get navigatorKey => MyApp.navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const MyHomePage(),
    );
  }
}
```

Because the navigator key is held globally, every `Nav` call works without a
`BuildContext`. Pass an optional `context:` argument when you need to navigate
inside a nested `Navigator`.

3. Push with a built-in animation

```dart
// Pick any animation with the NavAni enum
Nav.push(const NextScreen(), navAni: NavAni.Blink);

enum NavAni { Left, Right, Top, Bottom, Fade, Ripple, Blink }

// Convenience methods
Nav.pushFromRight(const NextScreen());              // iOS swipe-back by default
Nav.pushReplacement(const NextScreen());            // replace the current route
Nav.clearAllAndPush(const NextScreen());            // clear the stack, then push
Nav.pushWithRippleEffect(
  const NextScreen(),
  alignment: Alignment.bottomRight,
  offset: const Offset(10, 10),
);

// Pop helpers
Nav.pop(context);                                   // simple pop
await Nav.canPop();                                 // whether a route can be popped
Nav.clearAll();                                     // pop everything
```

4. Any push can return a value

```dart
// from the pushing screen
final result = await Nav.pushFromRight(const TopScreen());

// from the pushed screen
Nav.pop(context, result: {"key": "value", "key2": 2});
```

5. Get a **type-safe** result with the `NavScreen<Result>` mixin & `pushResult`

Add the `NavScreen<Result>` mixin to the destination screen. It fixes the
result type and exposes a typed `popResult(context, result)` method.

```dart
// A screen that returns a String result
class TopScreen extends StatelessWidget with NavScreen<String> {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // result is positional; its type is enforced by NavScreen<String>
      onTap: () => popResult(context, 'Data to return'),
      child: const Text('return'),
    );
  }
}

// Push it and await the typed result (String? here)
final String? result = await Nav.pushResult(const TopScreen());
```

From a `StatefulWidget`'s `State`, call it through `widget`:

```dart
widget.popResult(context, 'Data to return');
```

### Global settings (optional)

```dart
Nav.initialize(NavSetting(useRootNavigator: true, useSafeArea: false));
```



## Author

👤 **Bansook Nam**

* Website: https://github.com/bansooknam
* Github: [@bansooknam](https://github.com/bansooknam)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check [issues page](https://github.com/bansooknam/nav/issues). You can also take a look at the [contributing guide](Contributions, issues and feature requests are welcome.).

## Show your support

Give a ⭐️ if this project helped you!


## 📝 License

Copyright © 2020 [Bansook Nam](https://github.com/bansooknam).

This project is [Apache 2.0](https://github.com/BansookNam/nav/blob/master/LICENSE) licensed.

***
_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_

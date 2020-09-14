# Welcome to Nav 👋
![Version](https://img.shields.io/pub/v/nav.svg?style=flat-square)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache 2.0-yellow.svg)](https://github.com/BansookNam/nav/blob/master/LICENSE)

> Provide easy way to navigate. Includes lots of routers. You can use this library on Android & iOS.



<img src="https://raw.githubusercontent.com/BansookNam/nav/master/img/sample.gif" width="300" />

### 🏠 [Homepage](https://github.com/bansooknam/nav)

## Install

```sh
nav: ^{latest version}
```

## Usage

1. Add mixin "Nav" on your App State

```dart
import 'package:nav/nav.dart';

class _MyAppState extends State<MyApp> with Nav 
```

2. Use push methods

```dart
Nav.pushFromRight(Widget)
Nav.pushFromLeft(Widget)
Nav.pushFromTop(Widget)
Nav.pushFromBottom(Widget)
```

3. All methods can return value

```dart
//from bottom screen
final result = await Nav.pushFromRight( TopScreen ) //you can get result from TopWidget

//from top screen
Nav.pop(context, result: {"key": "value", "key2": 2})
```



4. If you want to use ripple push please initialize Nav before use.

```dart
 //This should be called inside layer of Material App Widget
@override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Nav.initInsideOfApp(context));
  }
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
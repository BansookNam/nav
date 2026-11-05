# Nav example

```bash
flutter run                           # the main sample (Navigator 1.0 + deep links)
flutter run -t lib/main_go_router.dart  # Nav with go_router (Navigator 2.0)
flutter test                          # tests for every sample below
```

On the main sample's home screen, the arrows push with each `NavAni`, and the
**Samples** button (top right) opens the demos below.

## Imperative navigation (`lib/main.dart`)

```dart
Nav.push(MyHomePage(navType: NavType.Top), navAni: NavAni.Top);
Nav.pushFromRight(MyHomePage(navType: NavType.Right));
Nav.clearAllAndPush(MyHomePage(navType: NavType.ClearAll));
final result = await MessageDialog('Test String').show();
```

## Deep links: App Links, Universal Links, custom schemes

| File | What it is |
| --- | --- |
| `lib/deep_link/deep_link_paths.dart` | The `NavPathDelegate`, which links the app claims (`opensInApp`), and `simulateOsLink` |
| `lib/deep_link/link_test_page.dart` | **Deep link tester**: a WebView on the mock site; claimed links are handed to the app |
| `tool/link_server/server.dart` | A mock website (`dart:io` only) serving a test page and the `.well-known` files |
| `tool/open_link.sh` | Opens a link through the OS (`adb` / `simctl`), like tapping it in another app |

The app is wired in `lib/main.dart`:

```dart
MaterialApp(
  navigatorKey: navigatorKey,
  home: MyHomePage(),
  onGenerateRoute: deepLinkPaths.onGenerateRoute,
  onUnknownRoute: deepLinkPaths.onUnknownRoute,
);
```

### Three ways to try a link

**1. In the app, no setup.** Start the mock site, then open *Samples → Deep
link tester*:

```bash
dart run tool/link_server/server.dart
```

The WebView loads `http://10.0.2.2:8080` (Android emulator) or
`http://localhost:8080` (iOS simulator). Tapping
`https://nav.example.com/product/42?color=blue` is stopped in the WebView and
delivered by `simulateOsLink`, which pushes the same route name the engine
pushes for a real link. The field at the top delivers any typed link without the
server.

**2. Through the OS, custom scheme.** Works on any emulator or device:

```bash
tool/open_link.sh android "navexample://open/product/42?color=blue"
tool/open_link.sh ios     "navexample://open/product/42?color=blue"
```

**3. Through the OS, verified https.** The OS only opens
`https://nav.example.com/...` in the app after verifying the domain over HTTPS,
which a placeholder domain cannot pass. To verify a real one:

1. Expose the mock site over HTTPS: `cloudflared tunnel --url http://localhost:8080`
   (or `ngrok http 8080`).
2. Replace `nav.example.com` with the tunnel's host name in
   `android/app/src/main/AndroidManifest.xml` and `appLinkHost` in
   `deep_link_paths.dart`.
3. Fill in `tool/link_server/public/.well-known/`:
   * `assetlinks.json`: your signing certificate's SHA-256
     (`keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android`).
   * `apple-app-site-association`: your Team ID in `TEAMID.com.example.example`.
4. iOS only: in Xcode, *Runner → Signing & Capabilities → + Associated
   Domains*, add `applinks:<tunnel host>`.
5. `tool/open_link.sh android "https://<tunnel host>/product/42"`. On Android,
   `adb shell pm get-app-links com.example.example` shows whether the domain
   verified.

## Navigator 2.0

### `Navigator.pages` (`lib/navigator2/pages_demo.dart`)

*Samples → Navigator 2.0: Navigator.pages*. The page stack is built from
state, each page with its own transition:

```dart
Navigator(
  pages: [
    NavPage(key: _listKey, navAni: NavAni.fade, child: ProductListPage(...)),
    if (selected != null)
      NavPage(key: _productKey, navAni: NavAni.bottom, child: ProductPage(...)),
    if (selected != null && showReviews)
      NavPage(key: _reviewsKey, navAni: NavAni.ripple, child: ReviewsPage(...)),
  ],
  onDidRemovePage: _onDidRemovePage, // back → state
);
```

"Next product" keeps the page key, so the existing page is updated in place
with no new transition.

### go_router (`lib/navigator2/go_router_app.dart`)

`flutter run -t lib/main_go_router.dart`. Every route returns a `NavPage`, and
the router's navigator key is shared with Nav:

```dart
GoRoute(
  path: 'product/:id',
  pageBuilder: (context, state) => NavPage(
    key: state.pageKey,
    child: GoProductPage(id: state.pathParameters['id']!),
  ),
);

Nav.init(goRouterNavigatorKey); // Nav.push and dialogs on top of router pages
```

go_router handles incoming deep links itself, so
`tool/open_link.sh android "navexample://open/product/42?color=blue"` opens
the product page in this app too.

## Dialog animation

### Constructor props (`lib/dialog/dialog_animation_demo.dart`)

*Samples → Dialog animation*. Pick a `NavAni`, a duration and a curve, then
`show()`: the dialog (`lib/dialog/panel_dialog.dart`) gets them as constructor
arguments.

```dart
PanelDialog(
  title: 'Bottom sheet',
  animation: NavAni.Bottom,
  animationDuration: const Duration(milliseconds: 250), // default 500 ms
  animationCurve: Curves.easeOutBack,                   // default dialogTransitionCurve
).show();
```

The curve applies to the slides and to `NavAni.Fade` (once a duration or a
curve is given, Fade is drawn by Nav instead of Material's `showDialog`);
`NavAni.Ripple` has its own reveal. The duration is used both ways.

### Per `show()` (`lib/dialog/show_override_demo.dart`)

*Samples → Per-show animation*. The arguments of `show()` win over the
constructor's for that one showing, e.g. a 250 ms sheet that opens slowly once:

```dart
final sheet = PanelDialog(title: 'Sheet', animation: NavAni.Bottom,
    animationDuration: const Duration(milliseconds: 250));
await sheet.show();                                  // 250 ms
await PanelDialog(title: 'Sheet', animation: NavAni.Bottom).show(
  animationDuration: const Duration(seconds: 1),     // this time 1 s
  animationCurve: Curves.bounceOut,
);
```

A `DialogWidget` instance is one showing: build a new one for the next
`show()`.

## Route options (`lib/route/route_options_demo.dart`)

*Samples → Route options*. The same screen pushed four ways; it reads its own
route back (`settings.name`, route type, `fullscreenDialog`, `opaque`).

```dart
Nav.push(screen, navAni: NavAni.platform,               // the theme's transition
    settings: const RouteSettings(name: '/platform'));
Nav.push(screen, navAni: NavAni.platform, fullscreenDialog: true);
Nav.push(screen, navAni: NavAni.bottom, opaque: false,  // the list stays drawn
    durationMs: 350, curve: Curves.easeOutCubic);
Nav.push(screen, durationMs: 600, reverseDurationMs: 120); // fast close
```

## Known limitation

`android/` still uses the pre-Flutter-3.16 Gradle setup
(`apply from: flutter.gradle`, Gradle 7.4), which current Flutter no longer
builds. Run `flutter create --platforms=android .` in this directory to
regenerate it, then copy the `<intent-filter>`s and the `flutter_deeplinking_enabled`
meta-data back into `AndroidManifest.xml`.

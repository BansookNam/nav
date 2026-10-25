import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

import 'link_test_page.dart';

/// The domain the app claims for App Links / Universal Links. It must match
/// AndroidManifest.xml and the iOS Associated Domains entitlement.
const appLinkHost = 'nav.example.com';

/// The custom scheme and fixed host registered in AndroidManifest.xml and
/// Info.plist. The host is fixed because Flutter passes only the path on:
/// `navexample://open/product/7` arrives as `/product/7`.
const customScheme = 'navexample';
const customSchemeHost = 'open';

/// Every link this app can open.
///
/// Try it on a device with tool/open_link.sh, or in the in-app
/// [LinkTestPage] against tool/link_server/server.dart:
///
///   tool/open_link.sh android "navexample://open/product/42?color=blue"
///   tool/open_link.sh ios     "navexample://open/product/42?color=blue"
///
/// `https://nav.example.com/product/42` works the same way once the domain
/// serves assetlinks.json / apple-app-site-association (see the README).
final deepLinkPaths = NavPathDelegate([
  NavPath('/product/:id', (params) => ProductScreen(params)),
  NavPath('/user/:name', (params) => ProductScreen(params),
      navAni: NavAni.Fade),
], unknown: (params) => ProductScreen(params));

/// Whether the OS would hand [link] to this app rather than to a browser.
///
/// The claim is per domain (or scheme), not per path: a claimed link that no
/// NavPath matches still opens the app, on the unknown screen.
bool opensInApp(Uri link) =>
    (link.scheme == 'https' && link.host == appLinkHost) ||
    (link.scheme == customScheme && link.host == customSchemeHost);

/// The route name Flutter pushes when the OS opens the app with [link] —
/// the same conversion as `WidgetsApp.didPushRouteInformation`: scheme and
/// host are dropped, path, query and fragment are kept.
String routeNameOf(Uri link) => Uri.decodeComponent(Uri(
      path: link.path.isEmpty ? '/' : link.path,
      queryParameters:
          link.queryParametersAll.isEmpty ? null : link.queryParametersAll,
      fragment: link.fragment.isEmpty ? null : link.fragment,
    ).toString());

/// Delivers [link] to the running app the way the OS + engine would, so the
/// whole path (route name → onGenerateRoute → NavPathDelegate) runs without a
/// verified domain or a device.
Future<T?> simulateOsLink<T>(Uri link) =>
    Nav.navigatorState(null)!.pushNamed<T>(routeNameOf(link));

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.params, {super.key});

  final NavPathParams params;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(params.uri.path)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Link: ${params.uri}'),
          Text('Path parameters: ${params.pathParameters}'),
          Text('Query parameters: ${params.queryParameters}'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

/// Every link this app can open.
///
/// Try it on a device:
///
///   Android: adb shell am start -a android.intent.action.VIEW \
///              -d "navexample://open/product/42?color=blue"
///   iOS:     xcrun simctl openurl booted \
///              "navexample://open/product/42?color=blue"
///
/// `https://nav.example.com/product/42` works the same way once the domain
/// serves assetlinks.json / apple-app-site-association (see the README).
final deepLinkPaths = NavPathDelegate([
  NavPath('/product/:id', (params) => ProductScreen(params)),
  NavPath('/user/:name', (params) => ProductScreen(params),
      navAni: NavAni.Fade),
], unknown: (params) => ProductScreen(params));

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

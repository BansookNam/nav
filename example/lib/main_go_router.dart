import 'package:flutter/material.dart';

import 'navigator2/go_router_app.dart';

/// The go_router sample as its own app, because MaterialApp.router replaces
/// the Navigator that the main sample's Nav calls are bound to.
///
///   flutter run -t lib/main_go_router.dart
void main() {
  runApp(const GoRouterApp());
}

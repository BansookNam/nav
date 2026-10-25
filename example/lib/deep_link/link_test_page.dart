import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'deep_link_paths.dart';

/// A WebView on the mock site from tool/link_server/server.dart.
///
/// Tapping a link the app claims ([opensInApp]) is stopped in the WebView and
/// delivered with [simulateOsLink] — what the OS does once the domain is
/// verified. Other links load in the WebView.
///
/// The field at the top delivers any typed link the same way, without the
/// server.
class LinkTestPage extends StatefulWidget {
  const LinkTestPage({super.key, Uri? server}) : _server = server;

  final Uri? _server;

  /// The host machine as seen from an Android emulator or iOS simulator.
  static Uri get defaultServer => Uri.parse(
      Platform.isAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080');

  @override
  State<LinkTestPage> createState() => _LinkTestPageState();
}

class _LinkTestPageState extends State<LinkTestPage> {
  final _link =
      TextEditingController(text: 'https://$appLinkHost/product/42?color=blue');

  late final WebViewController _web = WebViewController()
    ..setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (request) {
        final link = Uri.tryParse(request.url);
        if (link != null && opensInApp(link)) {
          simulateOsLink(link);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
      onWebResourceError: (error) =>
          _showSnack('Could not load the link server (${error.description}). '
              'Run: dart run tool/link_server/server.dart'),
    ))
    ..loadRequest(widget._server ?? LinkTestPage.defaultServer);

  void _showSnack(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _openTyped() {
    final link = Uri.tryParse(_link.text.trim());
    if (link == null || !opensInApp(link)) {
      _showSnack('Not a link this app claims: ${_link.text}');
      return;
    }
    simulateOsLink(link);
  }

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep link tester'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: _web.reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _link,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: 'Link to deliver as the OS would',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _openTyped(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _openTyped, child: const Text('Open')),
              ],
            ),
          ),
          Expanded(child: WebViewWidget(controller: _web)),
        ],
      ),
    );
  }
}

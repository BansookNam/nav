import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

import 'deep_link/link_test_page.dart';
import 'navigator2/pages_demo.dart';

class DemoListScreen extends StatelessWidget {
  const DemoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Samples')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text('Deep link tester'),
            subtitle: const Text(
                'WebView on tool/link_server/server.dart; claimed links go '
                'to NavPathDelegate'),
            onTap: () => Nav.push(const LinkTestPage()),
          ),
          ListTile(
            leading: const Icon(Icons.layers),
            title: const Text('Navigator 2.0: Navigator.pages'),
            subtitle: const Text('NavPage stack driven by state'),
            onTap: () => Nav.push(const PagesDemo(), navAni: NavAni.fade),
          ),
          const ListTile(
            leading: Icon(Icons.alt_route),
            title: Text('Navigator 2.0: go_router'),
            subtitle:
                Text('A separate app: flutter run -t lib/main_go_router.dart'),
          ),
        ],
      ),
    );
  }
}

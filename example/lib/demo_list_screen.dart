import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

import 'deep_link/link_test_page.dart';
import 'dialog/dialog_animation_demo.dart';
import 'dialog/show_override_demo.dart';
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
          ListTile(
            leading: const Icon(Icons.animation),
            title: const Text('Dialog animation'),
            subtitle: const Text(
                'DialogWidget(animation:, animationDuration:, animationCurve:)'),
            onTap: () => Nav.push(const DialogAnimationDemo()),
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Per-show animation'),
            subtitle: const Text(
                'show(animationDuration:, animationCurve:) wins over the '
                'constructor'),
            onTap: () => Nav.push(const ShowOverrideDemo()),
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

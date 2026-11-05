import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

/// *Samples → Route options*: the same screen pushed with `NavAni.platform`
/// (the theme's page transition), as a full-screen modal, see-through
/// (`opaque: false`) and with a fast close (`reverseDurationMs`). Each push
/// is named with `settings`, which the pushed screen reads back.
class RouteOptionsDemo extends StatelessWidget {
  const RouteOptionsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route options')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PushButton(
            key: const Key('push-platform'),
            label: 'navAni: NavAni.platform',
            onPressed: () => Nav.push(const _OptionsPage(),
                navAni: NavAni.platform,
                settings: const RouteSettings(name: '/platform')),
          ),
          _PushButton(
            key: const Key('push-fullscreen'),
            label: 'fullscreenDialog: true',
            onPressed: () => Nav.push(const _OptionsPage(),
                navAni: NavAni.platform,
                fullscreenDialog: true,
                settings: const RouteSettings(name: '/fullscreen')),
          ),
          _PushButton(
            key: const Key('push-see-through'),
            label: 'opaque: false (bottom, easeOutCubic)',
            onPressed: () => Nav.push(const _OptionsPage(seeThrough: true),
                navAni: NavAni.bottom,
                durationMs: 350,
                curve: Curves.easeOutCubic,
                opaque: false,
                settings: const RouteSettings(name: '/see-through')),
          ),
          _PushButton(
            key: const Key('push-fast-close'),
            label: 'durationMs: 600, reverseDurationMs: 120',
            onPressed: () => Nav.push(const _OptionsPage(),
                navAni: NavAni.right,
                durationMs: 600,
                reverseDurationMs: 120,
                settings: const RouteSettings(name: '/fast-close')),
          ),
        ],
      ),
    );
  }
}

class _PushButton extends StatelessWidget {
  const _PushButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FilledButton.tonal(onPressed: onPressed, child: Text(label)),
      );
}

class _OptionsPage extends StatelessWidget {
  const _OptionsPage({this.seeThrough = false});

  final bool seeThrough;

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)!;
    final page = route is PageRoute ? route : null;
    final body = Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('settings.name: ${route.settings.name}',
                  key: const Key('route-name')),
              Text('${route.runtimeType}'),
              Text('fullscreenDialog: ${page?.fullscreenDialog}'),
              Text('opaque: ${route.opaque}'),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('route-close'),
                onPressed: () => Nav.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
    if (seeThrough) {
      return Material(color: Colors.black38, child: body);
    }
    return Scaffold(appBar: AppBar(title: const Text('Pushed')), body: body);
  }
}

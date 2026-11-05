import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

import 'panel_dialog.dart';

/// *Samples → Per-show animation*: one dialog class with a default animation
/// (a 250 ms bottom sheet) and `show(animationDuration:, animationCurve:)`,
/// which wins over the constructor for that one showing:
///
/// ```dart
/// final sheet = PanelDialog(title: 'Sheet', animation: NavAni.Bottom,
///     animationDuration: const Duration(milliseconds: 250));
/// await sheet.show();                                   // 250 ms
/// await PanelDialog(...).show(
///     animationDuration: const Duration(seconds: 1),    // this time 1 s
///     animationCurve: Curves.bounceOut);
/// ```
class ShowOverrideDemo extends StatefulWidget {
  const ShowOverrideDemo({super.key});

  @override
  State<ShowOverrideDemo> createState() => _ShowOverrideDemoState();
}

class _ShowOverrideDemoState extends State<ShowOverrideDemo> {
  String _log = '-';

  // A DialogWidget instance is one showing: build a new one each time.
  PanelDialog _sheet(String title) => PanelDialog(
        title: title,
        context: context,
        animation: NavAni.Bottom,
        animationDuration: const Duration(milliseconds: 250),
      );

  Future<void> _run(String what, Future<String?> Function() show) async {
    final watch = Stopwatch()..start();
    final result = await show();
    if (mounted) {
      setState(() => _log = '$what → ${result ?? 'dismissed'} '
          '(open for ${watch.elapsedMilliseconds} ms)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Per-show animation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton(
            key: const Key('default-show'),
            onPressed: () =>
                _run('constructor 250 ms', _sheet('Constructor: 250 ms').show),
            child: const Text('show()  — the constructor\'s 250 ms'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            key: const Key('slow-show'),
            onPressed: () => _run(
              'show() 1 s bounce',
              () => _sheet('show(): 1 s, bounceOut').show(
                animationDuration: const Duration(seconds: 1),
                animationCurve: Curves.bounceOut,
              ),
            ),
            child: const Text('show(animationDuration: 1 s, bounceOut)'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            key: const Key('instant-show'),
            onPressed: () => _run(
              'show() 0 ms',
              () => _sheet('show(): no animation')
                  .show(animationDuration: Duration.zero),
            ),
            child: const Text('show(animationDuration: Duration.zero)'),
          ),
          const SizedBox(height: 24),
          Text(_log, key: const Key('log')),
        ],
      ),
    );
  }
}

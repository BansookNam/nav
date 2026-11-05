import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

import 'panel_dialog.dart';

/// *Samples → Dialog animation*: pick a `NavAni`, a duration and a curve, then
/// show a [PanelDialog] that gets them as constructor arguments:
///
/// ```dart
/// PanelDialog(
///   title: '…',
///   animation: NavAni.Bottom,
///   animationDuration: const Duration(milliseconds: 250),
///   animationCurve: Curves.easeOutBack,
/// ).show();
/// ```
class DialogAnimationDemo extends StatefulWidget {
  const DialogAnimationDemo({super.key});

  @override
  State<DialogAnimationDemo> createState() => _DialogAnimationDemoState();
}

class _DialogAnimationDemoState extends State<DialogAnimationDemo> {
  static const _curves = <String, Curve?>{
    'default': null,
    'linear': Curves.linear,
    'easeOutBack': Curves.easeOutBack,
    'bounceOut': Curves.bounceOut,
  };

  NavAni _ani = NavAni.Bottom;
  double _ms = 250;
  String _curve = 'default';
  String _result = '-';

  Future<void> _show() async {
    final result = await PanelDialog(
      title: '${_ani.name} · ${_ms.round()} ms · $_curve',
      context: context,
      animation: _ani,
      animationDuration: Duration(milliseconds: _ms.round()),
      animationCurve: _curves[_curve],
    ).show();
    if (mounted) setState(() => _result = result ?? 'dismissed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialog animation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('animation'),
          Wrap(
            spacing: 8,
            children: [
              for (final a in NavAni.values)
                ChoiceChip(
                  key: Key('ani-${a.name}'),
                  label: Text(a.name),
                  selected: _ani == a,
                  onSelected: (_) => setState(() => _ani = a),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('animationDuration: ${_ms.round()} ms'),
          Slider(
            key: const Key('duration'),
            value: _ms,
            min: 0,
            max: 1500,
            divisions: 30,
            onChanged: (v) => setState(() => _ms = v),
          ),
          const Text('animationCurve (slides and Fade)'),
          Wrap(
            spacing: 8,
            children: [
              for (final c in _curves.keys)
                ChoiceChip(
                  key: Key('curve-$c'),
                  label: Text(c),
                  selected: _curve == c,
                  onSelected: (_) => setState(() => _curve = c),
                ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('show'),
            onPressed: _show,
            child: const Text('show()'),
          ),
          const SizedBox(height: 12),
          Text('Last result: $_result'),
        ],
      ),
    );
  }
}

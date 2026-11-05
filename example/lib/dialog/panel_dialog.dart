import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

/// A small centered card used by the animation demos. It returns the label
/// of the button that closed it ('ok' / 'later'), or null for the barrier.
class PanelDialog extends DialogWidget<String> {
  PanelDialog({
    required this.title,
    super.key,
    super.context,
    super.animation,
    super.animationDuration,
    super.animationCurve,
  });

  final String title;

  @override
  State<PanelDialog> createState() => _PanelDialogState();
}

class _PanelDialogState extends DialogState<PanelDialog> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.animation == NavAni.Bottom
          ? Alignment.bottomCenter
          : Alignment.center,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 300,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    key: const Key('panel-later'),
                    onPressed: () => widget.hide('later'),
                    child: const Text('Later'),
                  ),
                  FilledButton(
                    key: const Key('panel-ok'),
                    onPressed: () => widget.hide('ok'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:js' as js;

import 'package:flutter/material.dart';

import 'eye_dropper_layer.dart';

/// an eyeDropper standalone button
/// in browser the eyedrop feature is enabled only with canvasKit renderer
class EyedropperButton extends StatelessWidget {
  /// customisable icon ( default : [Icons.colorize] )
  final IconData icon;

  /// icon color, default : [Colors.blueGrey]
  final Color iconColor;

  /// color selection callback
  final ValueChanged<Color> onColor;

  /// hover, and the color changed callback
  final ValueChanged<Color>? onColorChanged;

  /// verify if the button is in a CanvasKit context
  bool get eyedropEnabled => js.context['flutterCanvasKit'] != null;

  const EyedropperButton({
    required this.onColor,
    this.onColorChanged,
    this.icon = Icons.colorize,
    this.iconColor = Colors.blueGrey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration:
            const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
        child: IconButton(
          icon: const Icon(Icons.colorize),
          color: iconColor,
          tooltip: 'test',
          onPressed:
              eyedropEnabled ? () => _onEyeDropperRequest(context) : null,
        ),
      );

  void _onEyeDropperRequest(BuildContext context) {
    try {
      EyeDrop.of(context).capture(context, onColor, onColorChanged);
    } catch (err) {
      throw Exception('EyeDrop capture error : $err');
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';
import 'hex_textfield.dart';

/// toolbar with :
/// - a color preview
/// - a hex color field
/// - an optional eyeDropper button
class ColorSelector extends StatelessWidget {
  final Color color;

  final bool withAlpha;

  final double thumbWidth;

  final FocusNode focus;

  final ValueChanged<Color> onColorChanged;

  final VoidCallback? onEyePick;

  const ColorSelector({
    required this.color,
    required this.onColorChanged,
    required this.focus,
    this.onEyePick,
    this.withAlpha = false,
    this.thumbWidth = 96,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildColorThumb(),
          HexColorField(
            hexFocus: focus,
            color: color,
            withAlpha: withAlpha,
            onColorChanged: (value) {
              onColorChanged(value);
            },
          ),
          if (onEyePick != null) // null if eyeDrop is disabled
            IconButton(icon: const Icon(Icons.colorize), onPressed: onEyePick),
        ],
      ),
    );
  }

  Widget _buildColorThumb() => Material(
        color: Colors.white,
        elevation: 3,
        borderRadius: defaultBorderRadius,
        child: Container(
          width: thumbWidth,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: defaultBorderRadius,
          ),
        ),
      );
}

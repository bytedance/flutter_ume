import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils.dart';

class HexColorField extends StatefulWidget {
  final bool withAlpha;

  final Color color;

  final FocusNode hexFocus;

  final ValueChanged<Color> onColorChanged;

  const HexColorField({
    required this.withAlpha,
    required this.color,
    required this.onColorChanged,
    required this.hexFocus,
    Key? key,
  }) : super(key: key);

  @override
  _HexColorFieldState createState() => _HexColorFieldState();
}

class _HexColorFieldState extends State<HexColorField> {
  static const _width = 106.0;

  late Color color;

  late TextEditingController _controller;

  late String prefix;

  int valueLength = 8;

  @override
  void initState() {
    super.initState();
    prefix = '#${widget.withAlpha ? '' : 'ff'}';

    valueLength = widget.withAlpha ? 8 : 6;

    final colorHexValue =
        widget.withAlpha ? widget.color.hexARGB : widget.color.hexRGB;
    _controller = TextEditingController(text: colorHexValue);
  }

  @override
  void didUpdateWidget(HexColorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      final colorHexValue =
          widget.withAlpha ? widget.color.hexARGB : widget.color.hexRGB;
      _controller.text = colorHexValue;

      if (widget.hexFocus.hasFocus) widget.hexFocus.nextFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        width: _width,
        child: TextField(
          controller: _controller,
          focusNode: widget.hexFocus,
          style: textTheme.bodyText1?.copyWith(fontSize: 15),
          maxLines: 1,
          autocorrect: false,
          enableInteractiveSelection: false,
          enableSuggestions: false,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Fa-f0-9]')),
          ],
          maxLength: valueLength,
          onSubmitted: (value) => widget.onColorChanged(
            value.padRight(valueLength, '0').toColor(argb: widget.withAlpha),
          ),
          decoration: InputDecoration(
            prefixText: prefix,
            counterText: '',
          ),
        ),
      ),
    );
  }
}

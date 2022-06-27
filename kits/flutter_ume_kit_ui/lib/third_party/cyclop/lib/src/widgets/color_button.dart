import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_ume_kit_ui/util/binding_ambiguate.dart';
import '../theme.dart';
import '../utils.dart';
import 'color_picker.dart';
import 'eyedrop/eye_dropper_layer.dart';
import 'picker_config.dart' if (dart.library.js) 'picker_config_web.dart';

const _buttonSize = 48.0;

class ColorButton extends StatefulWidget {
  final Color color;
  final double size;
  final BoxDecoration? decoration;
  final BoxShape boxShape;
  final ColorPickerConfig config;
  final Set<Color> swatches;

  final ValueChanged<Color> onColorChanged;

  final ValueChanged<Set<Color>>? onSwatchesChanged;

  final double elevation;

  final bool darkMode;

  const ColorButton({
    required this.color,
    required this.onColorChanged,
    this.onSwatchesChanged,
    this.elevation = 3,
    this.decoration,
    this.config = const ColorPickerConfig(),
    this.darkMode = false,
    this.size = _buttonSize,
    this.boxShape = BoxShape.circle,
    this.swatches = const {},
    Key? key,
  }) : super(key: key);

  @override
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> with WidgetsBindingObserver {
  OverlayEntry? pickerOverlay;

  late Color color;

  // hide the palette during eyedropping
  bool hidden = false;

  bool keyboardOn = false;

  double bottom = 30;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    bindingAmbiguate(WidgetsBinding.instance)!.addObserver(this);
  }

  @override
  void didUpdateWidget(ColorButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) color = widget.color;
  }

  @override
  void dispose() {
    bindingAmbiguate(WidgetsBinding.instance)!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (details) => _colorPick(context, details),
        child: Material(
          elevation: widget.elevation,
          shape: widget.boxShape == BoxShape.circle
              ? const CircleBorder()
              : const RoundedRectangleBorder(),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: widget.decoration ??
                BoxDecoration(
                  shape: widget.boxShape,
                  color: widget.color,
                  border: Border.all(width: 4, color: Colors.white),
                ),
          ),
        ),
      );

  void _colorPick(BuildContext context, TapDownDetails details) async {
    final selectedColor =
        await showColorPicker(context, details.globalPosition);
    widget.onColorChanged(selectedColor);
  }

  Future<Color> showColorPicker(BuildContext rootContext, Offset offset) async {
    if (pickerOverlay != null) return Future.value(widget.color);

    pickerOverlay = _buildPickerOverlay(offset, rootContext);

    Overlay.of(rootContext)?.insert(pickerOverlay!);

    return Future.value(widget.color);
  }

  OverlayEntry _buildPickerOverlay(Offset offset, BuildContext context) {
    final mq = MediaQuery.of(context);
    final onLandscape =
        mq.size.shortestSide < 600 && mq.orientation == Orientation.landscape;
    final pickerPosition =
        onLandscape ? offset : calculatePickerPosition(offset, mq.size);

    return OverlayEntry(
      maintainState: true,
      builder: (c) {
        return _DraggablePicker(
          initialOffset: pickerPosition,
          bottom: bottom,
          keyboardOn: keyboardOn,
          child: IgnorePointer(
            ignoring: hidden,
            child: Opacity(
              opacity: hidden ? 0 : 1,
              child: Material(
                borderRadius: defaultBorderRadius,
                child: ColorPicker(
                  darkMode: widget.darkMode,
                  config: widget.config,
                  selectedColor: color,
                  swatches: widget.swatches,
                  onClose: () {
                    pickerOverlay?.remove();
                    pickerOverlay = null;
                  },
                  onColorSelected: (c) {
                    color = c;
                    pickerOverlay?.markNeedsBuild();
                    widget.onColorChanged(c);
                  },
                  onSwatchesUpdate: widget.onSwatchesChanged,
                  onEyeDropper: () => _showEyeDropperOverlay(context),
                  onKeyboard: _onKeyboardOn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Offset calculatePickerPosition(Offset offset, Size size) =>
      offset +
      Offset(
        _buttonSize,
        min(-pickerHeight / 2, size.height - pickerHeight - 50),
      );

  void _showEyeDropperOverlay(BuildContext context) {
    hidden = true;
    try {
      EyeDrop.of(context).capture(context, (value) {
        hidden = false;
        _onEyePick(value);
      }, null);
    } catch (err) {
      print('ERROR !!! _buildPickerOverlay $err');
    }
  }

  void _onEyePick(Color value) {
    color = value;
    widget.onColorChanged(value);
    pickerOverlay?.markNeedsBuild();
  }

  void _onKeyboardOn() {
    keyboardOn = true;
    pickerOverlay?.markNeedsBuild();
    setState(() {});
  }

  @override
  void didChangeMetrics() {
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;

    final newBottom = (window.physicalSize.height - keyboardTopPixels) /
        window.devicePixelRatio;

    setState(() => bottom = newBottom);
    pickerOverlay?.markNeedsBuild();
  }
}

class _DraggablePicker extends StatefulWidget {
  final Offset initialOffset;

  final Widget child;

  final double bottom;

  final bool keyboardOn;

  const _DraggablePicker({
    Key? key,
    required this.child,
    required this.initialOffset,
    required this.bottom,
    required this.keyboardOn,
  }) : super(key: key);

  @override
  State<_DraggablePicker> createState() => _DraggablePickerState();
}

class _DraggablePickerState extends State<_DraggablePicker> {
  late Offset offset;

  @override
  void initState() {
    super.initState();
    offset = widget.initialOffset;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;

    final onLandscape =
        mq.size.shortestSide < 600 && mq.orientation == Orientation.landscape;

    return Positioned(
      left: mq.isPhone
          ? (size.width - pickerWidth) / 2
          : offset.dx.clamp(0.0, size.width - pickerWidth),
      top: mq.isPhone
          ? onLandscape
              ? 0
              : (widget.keyboardOn ? 20 : (size.height - pickerHeight) / 2)
          : offset.dy.clamp(0.0, size.height - pickerHeight),
      bottom: mq.isPhone ? 20 + widget.bottom : null,
      child: GestureDetector(onPanUpdate: _onDrag, child: widget.child),
    );
  }

  void _onDrag(DragUpdateDetails details) =>
      setState(() => offset = offset + details.delta);
}

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_ume/flutter_ume.dart';
import 'icon.dart' as icon;
import 'dart:math' as math;

class ColorPicker extends StatefulWidget implements Pluggable {
  final double scale;
  final Size size;

  const ColorPicker({
    Key? key,
    this.scale = 10.0,
    this.size = const Size(100, 100),
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  String get name => 'ColorPicker';

  @override
  String get displayName => 'ColorPicker';

  @override
  void onTrigger() {}

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));
}

class _ColorPickerState extends State<ColorPicker> {
  late Size _magnifierSize;
  late Size _handlerSize;
  double? _scale;
  BorderRadius? _radius;
  Color _currentColor = Colors.white;
  img.Image? _snapshot;
  Offset _magnifierPosition = Offset.zero;
  Offset _handlerPosition = Offset.zero;
  double _toolBarY = 60.0;
  Matrix4 _matrix = Matrix4.identity();
  late Size _windowSize;
  bool _excuting = false;

  @override
  void initState() {
    _windowSize = ui.window.physicalSize / ui.window.devicePixelRatio;
    _magnifierSize = widget.size;
    _handlerSize = Size(_magnifierSize.width / 2.5, _magnifierSize.height / 2);
    _scale = widget.scale;
    _radius = BorderRadius.circular(_magnifierSize.longestSide);
    _matrix = Matrix4.identity()..scale(widget.scale);
    _magnifierPosition =
        _windowSize.center(Offset.zero) - _magnifierSize.center(Offset.zero);
    _handlerPosition = _windowSize.center(Offset.zero) -
        _handlerSize.center(Offset(-_handlerSize.width, -_handlerSize.height));
    super.initState();
  }

  @override
  void didUpdateWidget(ColorPicker oldWidget) {
    if (oldWidget.size != widget.size) {
      _magnifierSize = widget.size;
      _radius = BorderRadius.circular(_magnifierSize.longestSide);
    }
    if (oldWidget.scale != widget.scale) {
      _scale = widget.scale;
      _matrix = Matrix4.identity()..scale(_scale);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onPanUpdate(DragUpdateDetails dragDetails) {
    _magnifierPosition = dragDetails.globalPosition -
        _magnifierSize.center(Offset(_handlerSize.width, _handlerSize.height));
    _handlerPosition =
        dragDetails.globalPosition - _handlerSize.center(Offset.zero);
    double newX = dragDetails.globalPosition.dx - _magnifierSize.width / 2;
    double newY = dragDetails.globalPosition.dy - _magnifierSize.height / 2;
    final Matrix4 newMatrix = Matrix4.identity()
      ..translate(newX, newY)
      ..scale(_scale, _scale)
      ..translate(-newX, -newY);
    _matrix = newMatrix;
    _searchPixel(Offset(newX, newY));
    setState(() {});
  }

  void _toolBarPanUpdate(DragUpdateDetails dragDetails) {
    _toolBarY = dragDetails.globalPosition.dy - 40;
    setState(() {});
  }

  void _onPanStart(DragStartDetails dragDetails) async {
    if (_snapshot == null && _excuting == false) {
      _excuting = true;
      await _captureScreen();
    }
  }

  void _onPanEnd(DragEndDetails dragDetails) {
    _snapshot = null;
  }

  void _searchPixel(Offset globalPosition) {
    _calculatePixel(globalPosition);
  }

  Future<void> _captureScreen() async {
    try {
      RenderRepaintBoundary boundary =
          rootKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return;
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();
      _snapshot = img.decodeImage(pngBytes);
      _excuting = false;
      image.dispose();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _calculatePixel(Offset globalPosition) {
    if (_snapshot == null) return;
    double px = globalPosition.dx;
    double py = globalPosition.dy;
    int pixel32 = _snapshot!.getPixelSafe(px.toInt(), py.toInt());
    int hex = _abgrToArgb(pixel32);
    _currentColor = Color(hex);
  }

  int _abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  @override
  Widget build(BuildContext context) {
    if (_windowSize.isEmpty) {
      _windowSize = MediaQuery.of(context).size;
      _magnifierPosition = _windowSize.center(Offset.zero) -
          _magnifierSize
              .center(Offset(_handlerSize.width, _handlerSize.height));
      _handlerPosition =
          _windowSize.center(Offset.zero) - _handlerSize.center(Offset.zero);
    }
    Widget toolBar = Container(
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            const BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(2, 2))
          ]),
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentColor,
                border: Border.all(width: 2.0, color: Colors.white),
                boxShadow: [
                  const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2))
                ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 40, right: 16),
            child:
                Text("#${_currentColor.value.toRadixString(16).substring(2)}",
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.grey,
                    )),
          ),
        ],
      ),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 0,
          top: _toolBarY,
          child: GestureDetector(
            onVerticalDragUpdate: _toolBarPanUpdate,
            child: toolBar,
          ),
        ),
        Positioned(
          left: _handlerPosition.dx,
          top: _handlerPosition.dy,
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: ClipRect(
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanEnd: _onPanEnd,
                onPanUpdate: _onPanUpdate,
                child: Container(
                  height: _handlerSize.height,
                  width: _handlerSize.width,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: Colors.grey,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: _magnifierPosition.dx,
          top: _magnifierPosition.dy,
          child: ClipRRect(
            borderRadius: _radius,
            child: BackdropFilter(
              filter: ui.ImageFilter.matrix(_matrix.storage,
                  filterQuality: FilterQuality.none),
              child: Container(
                child: Center(
                  child: Container(
                    height: 5,
                    width: 5,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                  ),
                ),
                height: _magnifierSize.height,
                width: _magnifierSize.width,
                decoration: BoxDecoration(
                    borderRadius: _radius,
                    border: Border.all(color: Colors.grey, width: 3)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

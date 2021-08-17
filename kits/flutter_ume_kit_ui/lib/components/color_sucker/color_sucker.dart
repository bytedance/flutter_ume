import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_ume/flutter_ume.dart';
import 'icon.dart' as icon;

class ColorSucker extends StatefulWidget implements Pluggable {
  final double scale;
  final Size size;

  const ColorSucker({
    Key? key,
    this.scale = 8.0,
    this.size = const Size(110, 110),
  }) : super(key: key);

  @override
  _ColorSuckerState createState() => _ColorSuckerState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  String get name => 'ColorSucker';

  @override
  String get displayName => 'ColorSucker';

  @override
  void onTrigger() {}

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));
}

class _ColorSuckerState extends State<ColorSucker> {
  late Size _magnifierSize;
  double? _scale;
  BorderRadius? _radius;
  Color _currentColor = Colors.white;
  img.Image? _snapshot;
  Offset _magnifierPosition = Offset.zero;
  double _toolBarY = 60.0;
  Matrix4 _matrix = Matrix4.identity();
  late Size _windowSize;
  bool _excuting = false;
  bool _dark = false;

  @override
  void initState() {
    _windowSize = ui.window.physicalSize / ui.window.devicePixelRatio;
    _magnifierSize = widget.size;
    _scale = widget.scale;
    _radius = BorderRadius.circular(_magnifierSize.longestSide);
    _matrix = Matrix4.identity()..scale(widget.scale);
    _magnifierPosition =
        _windowSize.center(Offset.zero) - _magnifierSize.center(Offset.zero);
    super.initState();
  }

  @override
  void didUpdateWidget(ColorSucker oldWidget) {
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
    double newX = dragDetails.globalPosition.dx;
    double newY = dragDetails.globalPosition.dy;
    if (newX + (_magnifierSize.width / 2) < 0) {
      newX = 0;
    } else if (newX >= _windowSize.width) {
      newX = _windowSize.width - 1;
    }

    if (newY + (_magnifierSize.height / 2) < 0) {
      newY = 0;
    } else if (newY >= _windowSize.height) {
      newY = _windowSize.height - 1;
    }

    _magnifierPosition =
        Offset(newX, newY) - _magnifierSize.center(Offset.zero);

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
    _toolBarY = max(0, _toolBarY);
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
    _dark = Color(hex).computeLuminance() > 0.5;
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
      _magnifierPosition =
          _windowSize.center(Offset.zero) - _magnifierSize.center(Offset.zero);
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
                onVerticalDragUpdate: _toolBarPanUpdate, child: toolBar)),
        Positioned(
          left: _magnifierPosition.dx,
          top: _magnifierPosition.dy,
          child: ClipRRect(
            borderRadius: _radius,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanEnd: _onPanEnd,
              onPanUpdate: _onPanUpdate,
              child: BackdropFilter(
                filter: ui.ImageFilter.matrix(_matrix.storage,
                    filterQuality: FilterQuality.none),
                child: Container(
                  height: _magnifierSize.height,
                  width: _magnifierSize.width,
                  child: CustomPaint(
                      painter: FrontSightPainter(
                          selectedColor: _currentColor, dark: _dark)),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class FrontSightPainter extends CustomPainter {
  final Color selectedColor;
  final bool dark;
  double strokeWidth = 32.0;
  double spaceWidth = 2.0;

  FrontSightPainter({required this.selectedColor, required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    var paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..color = selectedColor
      ..invertColors = false;

    canvas.drawCircle(center, radius, paint);

    paint
      ..strokeWidth = 0.6
      ..color = dark ? Colors.black54 : Colors.white;

    canvas.drawCircle(center, radius - strokeWidth / 2, paint);
    canvas.drawCircle(center, radius - 0.3, paint);

    /// frontSight
    paint.strokeWidth = 1.6;
    canvas.drawLine(Offset(radius - spaceWidth - 4, radius),
        Offset(radius - spaceWidth, radius), paint);
    canvas.drawLine(Offset(radius + spaceWidth, radius),
        Offset(radius + spaceWidth + 4, radius), paint);

    canvas.drawLine(Offset(radius, radius - spaceWidth - 4),
        Offset(radius, radius - spaceWidth), paint);
    canvas.drawLine(Offset(radius, radius + spaceWidth),
        Offset(radius, radius + spaceWidth + 4), paint);
  }

  @override
  bool shouldRepaint(FrontSightPainter old) =>
      old.selectedColor != selectedColor;
}

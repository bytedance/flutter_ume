import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ume/util/constants.dart';
import 'package:flutter_ume_kit_ui/components/hit_test.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'icon.dart' as icon;

class AlignRuler extends StatefulWidget implements Pluggable {
  AlignRuler({Key? key}) : super(key: key);

  @override
  _AlignRulerState createState() => _AlignRulerState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  String get name => 'AlignRuler';

  @override
  String get displayName => 'AlignRuler';

  @override
  void onTrigger() {}
}

class _AlignRulerState extends State<AlignRuler> {
  Size _windowSize = windowSize;
  final Size _dotSize = Size(80, 80);
  Offset _dotPosition = Offset.zero;
  BorderRadius? _radius;
  late Offset _dotOffset;
  final TextStyle _fontStyle = TextStyle(color: Colors.red, fontSize: 15);
  Size _textSize = Size.zero;
  double _toolBarY = 60.0;
  bool _switched = false;
  InspectorSelection _selection = WidgetInspectorService.instance.selection;

  @override
  void initState() {
    _dotPosition = _windowSize.center(Offset.zero);
    _radius = BorderRadius.circular(_dotSize.longestSide);
    _dotOffset = _dotSize.center(Offset.zero);
    super.initState();
    _textSize = _getTextSize();
    _selection.clear();
  }

  void _onPanUpdate(DragUpdateDetails dragDetails) {
    setState(() {
      _dotPosition = dragDetails.globalPosition;
    });
  }

  void _onPanEnd(DragEndDetails dragDetails) {
    if (!_switched) return;
    final List<RenderObject> objects = HitTest.hitTest(_dotPosition);
    _selection.candidates = objects;
    Offset offset = Offset.zero;
    for (var obj in objects) {
      var translation = obj.getTransformTo(null).getTranslation();
      Rect rect = obj.paintBounds.shift(Offset(translation.x, translation.y));
      if (rect.contains(_dotPosition)) {
        double dx, dy = 0.0;
        double perW = rect.width / 2;
        double perH = rect.height / 2;
        if (_dotPosition.dx <= perW + translation.x) {
          dx = translation.x;
        } else {
          dx = translation.x + rect.width;
        }
        if (_dotPosition.dy <= translation.y + perH) {
          dy = translation.y;
        } else {
          dy = translation.y + rect.height;
        }
        offset = Offset(dx, dy);
        break;
      }
    }
    setState(() {
      _dotPosition = offset == Offset.zero ? _dotPosition : offset;
      HapticFeedback.mediumImpact();
    });
  }

  void _toolBarPanUpdate(DragUpdateDetails dragDetails) {
    setState(() {
      _toolBarY = dragDetails.globalPosition.dy - 40;
    });
  }

  Size _getTextSize() {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: '789.5', // for caculate size
        style: _fontStyle,
      ),
    );
    textPainter.layout();
    return Size(textPainter.width, textPainter.height);
  }

  void _switchChanged(bool swi) {
    setState(() {
      _switched = swi;
      if (!_switched) {
        _selection.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_windowSize.isEmpty) {
      _windowSize = MediaQuery.of(context).size;
      _dotPosition = _windowSize.center(Offset.zero);
    }
    const TextStyle style = TextStyle(fontSize: 17, color: Colors.black);
    Widget toolBar = Container(
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            const BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(2, 2))
          ]),
      padding: const EdgeInsets.only(bottom: 16, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 26, right: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Left: ${_dotPosition.dx.toStringAsFixed(1)}',
                          style: style),
                      Padding(padding: const EdgeInsets.only(top: 8)),
                      Text(
                          'Right: ${(_windowSize.width - _dotPosition.dx).toStringAsFixed(1)}',
                          style: style),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Top: ${_dotPosition.dy.toStringAsFixed(1)}',
                          style: style),
                      Padding(padding: const EdgeInsets.only(top: 8)),
                      Text(
                          'Bottom: ${(_windowSize.height - _dotPosition.dy).toStringAsFixed(1)}',
                          style: style),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 30,
                  child: Transform.scale(
                    scale: 1.3,
                    child: Switch(
                        value: _switched,
                        onChanged: _switchChanged,
                        activeColor: Colors.red),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text('开启后松手将会自动吸附至最近widget',
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w500)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

    double verticalLeft = _dotPosition.dx - _textSize.width;
    double horizontalTop = _dotPosition.dy - _textSize.height;

    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: horizontalTop,
              left: _dotPosition.dx / 2 - _textSize.width / 2,
              child: Text('${_dotPosition.dx.toStringAsFixed(1)}',
                  style: _fontStyle)),
          Positioned(
              left: verticalLeft,
              top: _dotPosition.dy / 2 - _textSize.height / 2,
              child: Text('${_dotPosition.dy.toStringAsFixed(1)}',
                  style: _fontStyle)),
          Positioned(
              left: _dotPosition.dx +
                  (_windowSize.width - _dotPosition.dx) / 2 -
                  _textSize.width / 2,
              top: horizontalTop,
              child: Text(
                  '${(_windowSize.width - _dotPosition.dx).toStringAsFixed(1)}',
                  style: _fontStyle)),
          Positioned(
              top: _dotPosition.dy +
                  (_windowSize.height - _dotPosition.dy) / 2 -
                  _textSize.height / 2,
              left: verticalLeft,
              child: Text(
                  '${(_windowSize.height - _dotPosition.dy).toStringAsFixed(1)}',
                  style: _fontStyle)),
          Positioned(
              left: _dotPosition.dx,
              top: 0,
              child: Container(
                width: 1,
                height: _windowSize.height,
                color: const Color(0xffff0000),
              )),
          Positioned(
              left: 0,
              top: _dotPosition.dy,
              child: Container(
                width: _windowSize.width,
                height: 1,
                color: const Color(0xffff0000),
              )),
          Positioned(
            left: _dotPosition.dx - _dotOffset.dx,
            top: _dotPosition.dy - _dotOffset.dy,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                child: Center(
                  child: Container(
                    height: _dotSize.width / 2.5,
                    width: _dotSize.height / 2.5,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.8)),
                  ),
                ),
                height: _dotSize.height,
                width: _dotSize.width,
                decoration: BoxDecoration(
                    borderRadius: _radius,
                    border: Border.all(color: Colors.black, width: 2)),
              ),
            ),
          ),
          Positioned(
              left: 16,
              top: _toolBarY,
              child: GestureDetector(
                  onVerticalDragUpdate: _toolBarPanUpdate, child: toolBar)),
          InspectorOverlay(
              selection: _selection, needDescription: false, needEdges: false),
        ],
      ),
    );
  }
}

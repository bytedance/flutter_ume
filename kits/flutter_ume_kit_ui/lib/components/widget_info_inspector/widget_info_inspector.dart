import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_ui/components/hit_test.dart';
import 'package:flutter_ume_kit_ui/util/binding_ambiguate.dart';
import 'icon.dart' as icon;
import 'package:flutter/rendering.dart';
import 'package:flutter_ume/util/constants.dart';

class WidgetInfoInspector extends StatefulWidget implements Pluggable {
  const WidgetInfoInspector({Key? key}) : super(key: key);

  @override
  _WidgetInfoInspectorState createState() => _WidgetInfoInspectorState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  String get name => 'WidgetInfo';

  @override
  String get displayName => 'WidgetInfo';

  @override
  void onTrigger() {}

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);
}

class _WidgetInfoInspectorState extends State<WidgetInfoInspector>
    with WidgetsBindingObserver {
  _WidgetInfoInspectorState()
      : selection = WidgetInspectorService.instance.selection;

  final window = bindingAmbiguate(WidgetsBinding.instance)!.window;

  Offset? _lastPointerLocation;
  OverlayEntry _overlayEntry = OverlayEntry(builder: (ctx) => Container());

  final InspectorSelection selection;

  void _inspectAt(Offset? position) {
    final List<RenderObject> selected =
        HitTest.hitTest(position, edgeHitMargin: 2.0);
    setState(() {
      selection.candidates = selected;
    });
  }

  void _handlePanDown(DragDownDetails event) {
    _lastPointerLocation = event.globalPosition;
    _inspectAt(event.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    final Rect bounds =
        (Offset.zero & (window.physicalSize / window.devicePixelRatio))
            .deflate(1.0);
    if (!bounds.contains(_lastPointerLocation!)) {
      setState(() {
        selection.clear();
      });
    }
  }

  void _handleTap() {
    if (_lastPointerLocation != null) {
      _inspectAt(_lastPointerLocation);
    }
  }

  @override
  void initState() {
    super.initState();
    selection.clear();
    bindingAmbiguate(WidgetsBinding.instance)
        ?.addPostFrameCallback((timeStamp) {
      _overlayEntry = OverlayEntry(builder: (_) => _DebugPaintButton());
      overlayKey.currentState?.insert(_overlayEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    GestureDetector gesture = GestureDetector(
      onTap: _handleTap,
      onPanDown: _handlePanDown,
      onPanEnd: _handlePanEnd,
      behavior: HitTestBehavior.opaque,
      child: IgnorePointer(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height)),
    );
    children.add(gesture);
    children.add(InspectorOverlay(selection: selection));
    return Stack(children: children, textDirection: TextDirection.ltr);
  }

  @override
  void dispose() {
    super.dispose();
    if (_overlayEntry.mounted) {
      _overlayEntry.remove();
    }
  }
}

class _DebugPaintButton extends StatefulWidget {
  const _DebugPaintButton({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DebugPaintButtonState();
}

class _DebugPaintButtonState extends State<_DebugPaintButton> {
  double _dx = windowSize.width - dotSize.width - margin * 2;
  double _dy = windowSize.width - dotSize.width - bottomDistance;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _dx,
      top: _dy,
      child: Container(
        width: dotSize.width,
        height: dotSize.width,
        child: GestureDetector(
            onPanUpdate: _buttonPanUpdate,
            child: FloatingActionButton(
              elevation: 10,
              child: new Icon(Icons.all_out_sharp),
              onPressed: _showAllSize,
            )),
      ),
    );
  }

  void _buttonPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dx = details.globalPosition.dx - dotSize.width / 2;
      _dy = details.globalPosition.dy - dotSize.width / 2;
    });
  }

  void _showAllSize() async {
    debugPaintSizeEnabled = !debugPaintSizeEnabled;
    setState(() {
      late RenderObjectVisitor visitor;
      visitor = (RenderObject child) {
        child.markNeedsPaint();
        child.visitChildren(visitor);
      };
      bindingAmbiguate(RendererBinding.instance)
          ?.renderView
          .visitChildren(visitor);
    });
  }

  @override
  void dispose() {
    super.dispose();
    debugPaintSizeEnabled = false;
    bindingAmbiguate(WidgetsBinding.instance)
        ?.addPostFrameCallback((timeStamp) {
      late RenderObjectVisitor visitor;
      visitor = (RenderObject child) {
        child.markNeedsPaint();
        child.visitChildren(visitor);
      };
      bindingAmbiguate(RendererBinding.instance)
          ?.renderView
          .visitChildren(visitor);
    });
  }
}

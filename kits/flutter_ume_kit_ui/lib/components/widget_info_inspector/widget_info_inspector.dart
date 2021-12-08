import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume/core/pluggable_communication_service.dart';
import 'package:flutter_ume/service/inspector/inspector_overlay.dart';
import 'package:flutter_ume_kit_ui/components/hit_test.dart';
import 'icon.dart' as icon;

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
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));
}

class _WidgetInfoInspectorState extends State<WidgetInfoInspector>
    with WidgetsBindingObserver {
  _WidgetInfoInspectorState()
      : selection = WidgetInspectorService.instance.selection;

  final window = WidgetsBinding.instance!.window;

  Offset? _lastPointerLocation;

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
    if (selection.active)
      children.add(Positioned(
          left: _lastPointerLocation?.dx,
          top: _lastPointerLocation?.dy,
          child: CircleAvatar(
              child: IconButton(
                  onPressed: () {
                    PluggableCommunicationService().callWithKey('ShowCode',
                        {'launchKey': SelectionInfo(selection).filePath!});
                  },
                  icon: Icon(
                    Icons.zoom_in,
                  )))));
    return Stack(children: children, textDirection: TextDirection.ltr);
  }
}

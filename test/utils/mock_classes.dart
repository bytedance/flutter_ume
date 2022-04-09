import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_ume/core/pluggable.dart';
import 'package:flutter_ume/util/store_mixin.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockPaintingContext extends Mock implements PaintingContext {}

class MockInspectorSelection extends Mock implements InspectorSelection {
  @override
  bool get active => true;

  @override
  List<RenderObject> get candidates => [MockRenderObject()];

  @override
  RenderObject get current => MockRenderObject();

  @override
  Element get currentElement => MockElement();
}

class MockElement extends Mock implements Element {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();

  @override
  String toStringShort() => '';
}

class MockRenderObject extends Mock implements RenderObject {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();

  @override
  bool get attached => true;

  @override
  Rect get semanticBounds => Rect.largest;

  @override
  Matrix4 getTransformTo(RenderObject? ancestor) => Matrix4.identity();

  @override
  Rect get paintBounds => Rect.largest;

  @override
  DiagnosticsNode toDiagnosticsNode(
      {String? name, DiagnosticsTreeStyle? style}) {
    return DiagnosticableTreeNode(
      name: name,
      value: this,
      style: style,
    );
  }
}

class MockPluggableWithStream extends Mock implements PluggableWithStream {
  // ignore: close_sinks
  final streamController = StreamController.broadcast();

  @override
  String get name => 'MockPluggableWithStream';
  @override
  String get displayName => 'MockPluggableWithStream';
  @override
  Stream get stream => streamController.stream;
  @override
  get streamFilter => (value) => true;
  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(
      base64Decode('R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='));
}

class MockPluggable extends Mock implements Pluggable {
  @override
  String get name => 'MockPluggable';
  @override
  String get displayName => 'MockPluggable';
  @override
  Widget buildWidget(BuildContext? context) => Container();
  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(
      base64Decode('R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='));
}

class MockPluggableWithNestedWidget extends Mock
    implements PluggableWithNestedWidget {
  @override
  String get name => 'MockPluggableWithNestedWidget';
  @override
  String get displayName => 'MockPluggableWithNestedWidget';
  @override
  Widget buildWidget(BuildContext? context) => Container();
  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(
      base64Decode('R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=='));
  @override
  Widget buildNestedWidget(Widget child) => Container(
        child: child,
      );
}

class MockStoreMixinCls extends Mock with StoreMixin implements Object {}

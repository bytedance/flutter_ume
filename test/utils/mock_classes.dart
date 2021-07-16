import 'dart:async';

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
  Matrix4 getTransformTo(RenderObject ancestor) => Matrix4.identity();

  @override
  Rect get paintBounds => Rect.largest;
}

class MockPluggableWithStream extends Mock implements PluggableWithStream {
  // ignore: close_sinks
  final streamController = StreamController.broadcast();

  @override
  String get name => 'MockPluggableWithStream';
  @override
  Stream get stream => streamController.stream;
  @override
  get streamFilter => (value) => true;
}

class MockPluggable extends Mock implements Pluggable {
  @override
  String get name => 'MockPluggable';
  @override
  Widget buildWidget(BuildContext context) => Container();
}

class MockStoreMixinCls extends Mock with StoreMixin implements Object {}

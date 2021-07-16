import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/service/inspector/inspector_overlay.dart';
import '../../utils/mock_classes.dart';

void main() {
  group('InspectorOverlay', () {
    test('constructor', () {
      expect(
          InspectorOverlay(
            selection: InspectorSelection(),
          ),
          isNotNull);
    });

    testWidgets('pump widget', (tester) async {
      final inspectorOverlay = InspectorOverlay(
          selection: MockInspectorSelection(), needDescription: true);
      await tester.pumpWidget(inspectorOverlay);

      inspectorOverlay.updateRenderObject(MockBuildContext(),
          inspectorOverlay.createRenderObject(MockBuildContext()));
      inspectorOverlay.createRenderObject(MockBuildContext()).selection =
          MockInspectorSelection();
    });
  });
}

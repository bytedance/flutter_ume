import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume_kit_ui/components/color_sucker/color_sucker.dart';

import '../../mock_classes.dart';

void main() {
  group('ColorSucker', () {
    test('Pluggable', () {
      final pluggable = ColorSucker();
      final widget = pluggable.buildWidget(MockContext());
      final name = pluggable.name;
      final onTrigger = pluggable.onTrigger;
      onTrigger();
      final imageProvider = pluggable.iconImageProvider;

      expect(widget, isA<Widget>());
      expect(name, isNotEmpty);
      expect(onTrigger, isA<Function>());
      expect(imageProvider, isNotNull);
    });
    testWidgets('ColorSucker pump widget', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final colorSucker = ColorSucker();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: colorSucker,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(colorSucker, isNotNull);
    });

    testWidgets('ColorSucker Pan the point', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final colorSucker = ColorSucker();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: colorSucker,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset pointLocation =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is GestureDetector &&
            widget.onPanUpdate != null &&
            widget.onPanEnd != null &&
            widget.onPanUpdate != null;
      }));

      final TestGesture dragGesture =
          await tester.startGesture(pointLocation, pointer: 0);
      await tester.pump(const Duration(seconds: 3));
      await dragGesture.moveTo(pointLocation + Offset(20, 20));
      await dragGesture.up();
      await tester.pump();

      expect(colorSucker, isNotNull);
    });

    testWidgets('ColorSucker Pan the toolbar', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final colorSucker = ColorSucker();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: colorSucker,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset toolbarLocation =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is GestureDetector && widget.onVerticalDragUpdate != null;
      }));

      final TestGesture dragGesture =
          await tester.startGesture(toolbarLocation, pointer: 0);
      await tester.pump(const Duration(seconds: 3));
      await dragGesture.moveTo(toolbarLocation + Offset(0, 40));
      await dragGesture.up();
      await tester.pump();

      expect(colorSucker, isNotNull);
    });
  });
}

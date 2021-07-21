import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume_kit_ui/components/align_ruler/align_ruler.dart';

import '../../mock_classes.dart';

void main() {
  group('AlignRuler', () {
    test('Pluggable', () {
      final pluggable = AlignRuler();
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
    testWidgets('AlignRuler pump widget', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final ruler = AlignRuler();

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: ruler,
      )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(ruler, isNotNull);
    });

    testWidgets('AlignRuler Pan the point', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final ruler = AlignRuler();

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: ruler,
      )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset pointLocation =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is GestureDetector &&
            widget.onPanUpdate != null &&
            widget.onPanEnd != null;
      }));

      final TestGesture dragGesture =
          await tester.startGesture(pointLocation, pointer: 0);
      await tester.pump(const Duration(seconds: 3));
      await dragGesture.moveTo(pointLocation + Offset(20, 20));
      await dragGesture.up();
      await tester.pump();

      expect(ruler, isNotNull);
    });

    testWidgets('AlignRuler Pan the point, and switched == true',
        (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final ruler = AlignRuler();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: ruler,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.byWidgetPredicate(
          (widget) => widget is Switch && widget.activeColor == Colors.red));
      await tester.pump(Duration(seconds: 1));

      final Offset pointLocation =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is GestureDetector &&
            widget.onPanUpdate != null &&
            widget.onPanEnd != null;
      }));

      final TestGesture dragGesture =
          await tester.startGesture(pointLocation, pointer: 0);
      await tester.pump(const Duration(seconds: 3));
      await dragGesture.moveTo(pointLocation + Offset(20, 20));
      await tester.pump(Duration(seconds: 1));
      await dragGesture.up();
      await tester.pump();

      expect(ruler, isNotNull);
    });
  });
}

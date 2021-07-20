import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume_kit_ui/components/widget_detail_inspector/widget_detail_inspector.dart';

import '../../mock_classes.dart';

void main() {
  group('WidgetDetailInspector', () {
    test('Pluggable', () {
      final pluggable = WidgetDetailInspector();
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
    testWidgets('WidgetDetailInspector pump widget', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final inspector = WidgetDetailInspector();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: inspector,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(inspector, isNotNull);
    });

    testWidgets('WidgetDetailInspector tap the Text widget', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final inspector = WidgetDetailInspector();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: Container(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 200,
                    child: Text('test text'),
                  ),
                  inspector
                ],
              ),
            ),
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset textLocation =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is Text && widget.data == 'test text';
      }));

      await tester.tapAt(textLocation);
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset detailInfoLocation =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is GestureDetector &&
            widget.onTap != null &&
            widget.child is Container;
      }).at(2));

      await tester.tapAt(detailInfoLocation);
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(inspector, isNotNull);
    });
  });
}

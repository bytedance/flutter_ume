import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume_kit_perf/components/performance/performance.dart';
import '../../mock_classes.dart';

void main() {
  group('Performance', () {
    test('Pluggable', () {
      final pluggable = Performance();
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
    testWidgets('WidgetInfoInspector pump widget', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final performance = Performance();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: performance,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(performance, isNotNull);
    });
  });
}

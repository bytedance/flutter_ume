import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume_kit_perf/components/memory_info/memory_info_page.dart';
import '../../mock_classes.dart';

void main() {
  group('MemoryInfoPage', () {
    test('Pluggable', () {
      final pluggable = MemoryInfoPage();
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
    testWidgets('MemoryInfoPage pump widget', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final memoryInfoPage = MemoryInfoPage();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: memoryInfoPage,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(memoryInfoPage, isNotNull);
    });

    testWidgets('MemoryInfoPage tap the Text widget', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final memoryInfoPage = MemoryInfoPage();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: memoryInfoPage,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.byWidgetPredicate((widget) => widget is Checkbox));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Size'));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Count'));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(memoryInfoPage, isNotNull);
    });
  });
}

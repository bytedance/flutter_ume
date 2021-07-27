import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume_kit_show_code/show_code/show_code.dart';

import '../mock_classes.dart';

void main() {
  group('ShowCode', () {
    test('Pluggable', () {
      final pluggable = ShowCode();
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

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: Container(),
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final showCode = ShowCode();

      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: showCode,
          )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(showCode, isNotNull);
    });
  });
}

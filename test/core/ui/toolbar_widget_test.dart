import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/core/ui/toolbar_widget.dart';

import '../../utils/mock_classes.dart';

void main() {
  group('ToolBarWidget', () {
    setUp(() {
      final plugin0 = 'MockPluggable';
      final plugin1 = 'MockPluggableWithStream';
      SharedPreferences.setMockInitialValues({
        'PluginStoreKey': [plugin0, plugin1],
        'maximalToolbarSwitch': true,
      });
    });
    testWidgets('ToolbarWidget pump widget', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      PluginManager.instance
          .registerAll([MockPluggable(), MockPluggableWithStream()]);

      final toolbarWidget = ToolBarWidget(
        action: (pluggable) => null,
        maximalAction: () => null,
        closeAction: () => null,
      );

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: Stack(
          children: [toolbarWidget],
        ),
      )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(toolbarWidget, isNotNull);
    });

    testWidgets('toolbarWidget drag', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      PluginManager.instance
          .registerAll([MockPluggable(), MockPluggableWithStream()]);

      final toolbarWidget = ToolBarWidget(
        action: (pluggable) {},
        maximalAction: () => null,
        closeAction: () => null,
      );

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: Stack(
          children: [toolbarWidget],
        ),
      )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset toolBarHeaderPosition = tester.getCenter(find.text('UME'));
      final TestGesture longPressGesture =
          await tester.startGesture(toolBarHeaderPosition, pointer: 0);
      await tester.pump(const Duration(seconds: 1));
      await longPressGesture.moveBy(Offset(-10, -10));
      await longPressGesture.up();
      await tester.pump();
    });

    testWidgets('toolbarWidget actions', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      bool maximalTapped = false;
      bool closeTapped = false;

      PluginManager.instance
          .registerAll([MockPluggable(), MockPluggableWithStream()]);

      final toolbarWidget = ToolBarWidget(
        action: (pluggable) {},
        maximalAction: () => maximalTapped = true,
        closeAction: () => closeTapped = true,
      );

      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: Stack(
          children: [toolbarWidget],
        ),
      )));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset closeBtnPosition =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is InkWell &&
            (widget.child is CircleAvatar) &&
            (widget.child as CircleAvatar).backgroundColor == Color(0xffff5a52);
      }));
      await tester.tapAt(closeBtnPosition);
      expect(closeTapped, isTrue);

      final Offset maximalBtnPosition =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is InkWell &&
            (widget.child is CircleAvatar) &&
            (widget.child as CircleAvatar).backgroundColor == Color(0xff53c22b);
      }));
      await tester.tapAt(maximalBtnPosition);
      expect(maximalTapped, isTrue);

      final Offset cellPosition =
          tester.getCenter(find.text('MockPluggableWithStream'));
      await tester.tapAt(cellPosition);
    });
  });
}

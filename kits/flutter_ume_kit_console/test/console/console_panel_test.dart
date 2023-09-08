import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume_kit_console/console/console_manager.dart';
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock_classes.dart';

void main() {
  group('ConsolePanel', () {
    test('Pluggable', () {
      final pluggable = Console();
      final widget = pluggable.buildWidget(MockContext());
      final name = pluggable.name;
      final onTrigger = pluggable.onTrigger;
      onTrigger();
      final imageProvider = pluggable.iconImageProvider;

      expect(widget, isA<Widget>());
      expect(name, isNotEmpty);
      expect(onTrigger, isA<Function>());
      expect(imageProvider, isNotNull);
      ConsoleManager.clearRedirect();
    });
    testWidgets('Console pump widget', (tester) async {
      final console = Console();
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: console,
          )));
      await tester.pumpAndSettle();
      expect(console, isNotNull);
      ConsoleManager.clearRedirect();
    });

    testWidgets('Console pump widget, call debugPrint, change datetime style',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'console_panel_datetime_style': 1,
      });
      final console = Console();
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: console,
          )));
      await tester.pumpAndSettle();

      for (int i = 0; i < 4; ++i) {
        debugPrint('TEST LOG $i');
        await tester.pumpAndSettle();
      }

      for (int i = 0; i < 4; ++i) {
        await tester.tap(find.byIcon(Icons.access_time));
        await tester.pumpAndSettle();
      }

      ConsoleManager.clearRedirect();
    });

    testWidgets('Console pump widget, call debugPrint, clear logs',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final console = Console();
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: console,
          )));
      await tester.pumpAndSettle();

      for (int i = 0; i < 4; ++i) {
        debugPrint('TEST LOG $i');
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byIcon(Icons.do_not_disturb));
      await tester.pumpAndSettle();

      expect(ConsoleManager.logData.first.item2, 'UME CONSOLE == ClearLog');

      ConsoleManager.clearRedirect();
    });

    testWidgets('Console pump widget, call debugPrint, trigger filter',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final console = Console();
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: console,
          )));
      await tester.pumpAndSettle();

      for (int i = 0; i < 4; ++i) {
        debugPrint('TEST LOG $i');
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'TEST LOG 0');
      await tester.pumpAndSettle();

      await tester.tap(find.byWidgetPredicate((widget) =>
          widget is Icon && widget.icon == Icons.search && widget.size == 20));
      await tester.pumpAndSettle();

      ConsoleManager.clearRedirect();
    });

    testWidgets('Console pump widget, call debugPrint, share', (tester) async {
      SharedPreferences.setMockInitialValues({
        'console_panel_datetime_style': 1,
      });
      final console = Console();
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: console,
          )));
      await tester.pumpAndSettle();

      for (int i = 0; i < 4; ++i) {
        debugPrint('TEST LOG $i');
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      ConsoleManager.clearRedirect();
    });
  });
}

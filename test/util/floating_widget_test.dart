import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_ume/core/ui/global.dart';
import 'package:flutter_ume/util/floating_widget.dart';

void main() {
  group('FloatingWidget', () {
    testWidgets('FloatingWidget pump widget', (tester) async {
      final floatingWidget = FloatingWidget();
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: floatingWidget,
          )));
      await tester.pumpAndSettle();
      expect(floatingWidget, isNotNull);
    });

    testWidgets('FloatingWidget pump widget, drag window', (tester) async {
      final floatingWidget = FloatingWidget();
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: floatingWidget,
          )));
      await tester.pumpAndSettle();

      final toolbarTitle = find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'UME');

      await tester.drag(toolbarTitle, Offset(0, -100));
    });

    testWidgets('FloatingWidget pump widget, fullscreen action',
        (tester) async {
      final floatingWidget = FloatingWidget();
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: floatingWidget,
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.byWidgetPredicate((widget) =>
          widget is CircleAvatar &&
          widget.backgroundColor == Color(0xff53c22b)));
      await tester.pumpAndSettle();
      await tester.tap(find.byWidgetPredicate((widget) =>
          widget is CircleAvatar &&
          widget.backgroundColor == Color(0xffe6c029)));
    });

    testWidgets('FloatingWidget pump widget, toolbar actions', (tester) async {
      var a = 1;
      final toolbarAction = () {
        a = 2;
      };
      final floatingWidget = FloatingWidget(
        toolbarActions: [Tuple3('test', Icon(Icons.search), toolbarAction)],
      );
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: floatingWidget,
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(a, 2);
    });

    testWidgets('FloatingWidget pump widget, close action', (tester) async {
      var a = 1;
      final closeAction = () {
        a = 2;
      };
      final floatingWidget = FloatingWidget(
        closeAction: closeAction,
      );
      await tester.pumpWidget(MaterialApp(
          key: rootKey,
          home: Scaffold(
            body: floatingWidget,
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.byWidgetPredicate((widget) =>
          widget is CircleAvatar &&
          widget.backgroundColor == Color(0xffff5a52)));
      await tester.pumpAndSettle();

      expect(a, 2);
    });
  });
}

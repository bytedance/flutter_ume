import 'package:flutter/material.dart' hide FlutterLogo;
import 'package:flutter_ume/core/pluggable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ume/util/flutter_logo.dart' as flutterLogo;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/core/ui/root_widget.dart';

import '../../utils/mock_classes.dart';

void main() {
  setUp(() {
    final plugin0 = 'MockPluggable';
    final plugin1 = 'MockPluggableWithStream';
    SharedPreferences.setMockInitialValues({
      'PluginStoreKey': [plugin0, plugin1],
      'MinimalToolbarSwitch': true,
    });
  });

  group('RootWidget', () {
    testWidgets('RootWidget assert constructor', (tester) async {
      await tester.pumpWidget(UMEWidget(
        child: Container(),
        enable: false,
      ));
      expect(find.byType(UMEWidget), isOnstage);
      expect(find.byType(Container), isOnstage);
      expect(find.byType(Overlay), findsOneWidget);
    });

    testWidgets('RootWidget pump widget', (tester) async {
      PluginManager.instance
          .registerAll([MockPluggable(), MockPluggableWithStream()]);
      final umeRoot = UMEWidget(
          child: MaterialApp(
              home: Scaffold(
            body: Container(),
          )),
          enable: true);

      await tester.pumpWidget(umeRoot);
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(umeRoot, isNotNull);
    });

    testWidgets('Floating dot position', (tester) async {
      final plugin0 = 'MockPluggable';
      final plugin1 = 'MockPluggableWithStream';
      MethodChannel channel = const MethodChannel('bd_shared_preferences');
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'commit') {
          return Map<String, dynamic>.from(methodCall.arguments);
        } else if (methodCall.method == 'getAll') {
          return {
            'PluginStoreKey': [plugin0, plugin1],
            'MinimalToolbarSwitch': true,
            'FloatingDotPos': '123,123',
          };
        } else
          return null;
      });

      PluginManager.instance.registerAll([
        MockPluggable(),
        MockPluggableWithStream(),
        MockPluggableWithNestedWidget()
      ]);
      final umeRoot = UMEWidget(
          child: MaterialApp(
              home: Scaffold(
            body: Container(),
          )),
          enable: true);
      await tester.pumpWidget(umeRoot);
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      channel.setMockMethodCallHandler(null);
    });

    testWidgets('RootWidget flutter logo drag', (tester) async {
      PluginManager.instance
          .registerAll([MockPluggable(), MockPluggableWithStream()]);
      final umeRoot = UMEWidget(
          child: MaterialApp(
              home: Scaffold(
            body: Container(),
          )),
          enable: true);
      await tester.pumpWidget(umeRoot);
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final fl = find.byType(flutterLogo.FlutterLogo);
      await tester.drag(fl, Offset(-100, -100));
      await tester.pump(Duration(seconds: 1));
      await tester.drag(fl, Offset(-2000, -2000));
      await tester.pump(Duration(seconds: 1));
      await tester.drag(fl, Offset(2000, 2000));
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();
    });

    testWidgets('RootWidget flutter logo drag', (tester) async {
      PluginManager.instance
          .registerAll([MockPluggable(), MockPluggableWithStream()]);
      final umeRoot = UMEWidget(
          child: MaterialApp(
              home: Scaffold(
            body: Container(),
          )),
          enable: true);
      await tester.pumpWidget(umeRoot);
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset flutterLogoPosition =
          tester.getCenter(find.byType(flutterLogo.FlutterLogo));
      await tester.dragFrom(flutterLogoPosition, Offset(-100, -100));
      await tester.pump();
      await tester.pumpAndSettle();
    });

    testWidgets('RootWidget flutter logo tap', (tester) async {
      PluginManager.instance
          .registerAll([MockPluggable(), MockPluggableWithStream()]);
      final umeRoot = UMEWidget(
          child: MaterialApp(
              home: Scaffold(
            body: Container(),
          )),
          enable: true);
      await tester.pumpWidget(umeRoot);
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset flutterLogoPosition =
          tester.getCenter(find.byType(flutterLogo.FlutterLogo));
      await tester.tapAt(flutterLogoPosition);
      await tester.pump();
      await tester.pumpAndSettle();

      await tester.tapAt(flutterLogoPosition);
      await tester.pump(Duration(seconds: 2));
      await tester.pumpAndSettle();
    });

    testWidgets('RootWidget actions', (tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      PluginManager.instance
          .registerAll([MockPluggable(), MockPluggableWithStream()]);

      final umeRoot = UMEWidget(
          child: MaterialApp(
              home: Scaffold(
            body: Container(),
          )),
          enable: true);
      await tester.pumpWidget(umeRoot);
      await tester.pump(Duration(seconds: 1));

      final Offset flutterLogoPosition =
          tester.getCenter(find.byType(flutterLogo.FlutterLogo));
      await tester.tapAt(flutterLogoPosition);
      await tester.pump(Duration(seconds: 1));

      final Offset maximalBtnPosition =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is InkWell &&
            (widget.child is CircleAvatar) &&
            (widget.child as CircleAvatar).backgroundColor == Color(0xff53c22b);
      }));
      await tester.tapAt(maximalBtnPosition);
      await tester.pump(Duration(seconds: 1));

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump(Duration(seconds: 1));

      await tester.tapAt(flutterLogoPosition);
      await tester.pump(Duration(seconds: 1));

      final Offset minimalBtnPosition =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is InkWell &&
            (widget.child is CircleAvatar) &&
            (widget.child as CircleAvatar).backgroundColor == Color(0xffe6c029);
      }));
      await tester.tapAt(minimalBtnPosition);
      await tester.pump(Duration(seconds: 1));

      final Offset closeBtnPosition =
          tester.getCenter(find.byWidgetPredicate((widget) {
        return widget is InkWell &&
            (widget.child is CircleAvatar) &&
            (widget.child as CircleAvatar).backgroundColor == Color(0xffff5a52);
      }));
      await tester.tapAt(closeBtnPosition);
      await tester.pump(Duration(seconds: 1));
    });

    testWidgets('Build nested widget', (tester) async {
      PluginManager.instance.registerAll([MockPluggableWithNestedWidget()]);
      final umeRoot = UMEWidget(
          child: MaterialApp(
              home: Scaffold(
            body: Container(),
          )),
          enable: true);
      await tester.pumpWidget(umeRoot);
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle();

      final Offset flutterLogoPosition =
          tester.getCenter(find.byType(flutterLogo.FlutterLogo));
      await tester.tapAt(flutterLogoPosition);
      await tester.pump();
      await tester.pumpAndSettle();

      await tester.tap(find.text('MockPluggableWithNestedWidget'));
      await tester.pumpAndSettle();

      await tester.tapAt(flutterLogoPosition);
    });
  });
}

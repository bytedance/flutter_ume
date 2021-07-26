import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/pluggable_message_service.dart';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/core/red_dot.dart';

import '../utils/mock_classes.dart';

void main() {
  group('RedDot', () {
    test('default constructor', () {
      final redDot = RedDot(
        pluginDatas: [],
      );
      expect(redDot, isNotNull);
    });

    testWidgets('empty container', (tester) async {
      final redDot = RedDot(
        pluginDatas: [],
      );
      await tester.pumpWidget(redDot);
      await tester.pumpAndSettle();
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
    });

    testWidgets('build, debugMode, has error', (tester) async {
      final mockPluggable = MockPluggableWithStream();
      PluginManager.instance!.register(mockPluggable);

      final redDot = RedDot(
        pluginDatas: [mockPluggable],
      );

      await tester.pumpWidget(redDot);
      await tester.pumpAndSettle();
      PluggableMessageService().resetListener();

      final message = PluggableMessage.create('MockPluggableWithStream', 1);

      mockPluggable.streamController.sink.add(message);

      await tester.pumpWidget(redDot);
      await tester.pumpAndSettle();

      final textFinder = find.byType(Text);
      expect(textFinder, findsOneWidget);
    });
  });
}

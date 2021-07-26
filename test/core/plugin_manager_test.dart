import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ume/core/pluggable.dart';
import 'package:flutter_ume/core/plugin_manager.dart';

import '../utils/mock_classes.dart';

void main() {
  group('PluggableMessageService.', () {
    test('register single plugin', () {
      final plugin = MockPluggableWithStream();
      PluginManager.instance!.register(plugin);
      expect(PluginManager.instance!.pluginsMap['MockPluggableWithStream'],
          isInstanceOf<Pluggable>());
    });
    test('register multiple plugin', () {
      final mockPluggableWithStream = MockPluggableWithStream();
      final mockPluggable = MockPluggable();
      PluginManager.instance!
          .registerAll([mockPluggable, mockPluggableWithStream]);
      expect(PluginManager.instance!.pluginsMap.keys.length, 2);
    });
  });
}

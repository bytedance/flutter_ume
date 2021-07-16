import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ume/core/pluggable.dart';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/core/store_manager.dart';

import '../utils/mock_classes.dart';

void main() {
  group('PluginStoreManager.', () {
    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      final plugin0 = 'plugin0';
      final plugin1 = 'plugin1';

      SharedPreferences.setMockInitialValues({
        'PluginStoreKey': [plugin0, plugin1],
        'MinimalToolbarSwitch': true,
      });
    });

    test('register single plugin', () {
      final plugin = MockPluggableWithStream();
      PluginManager.instance.register(plugin);
      expect(PluginManager.instance.pluginsMap['MockPluggableWithStream'],
          isInstanceOf<Pluggable>());
    });
    test('store multiple plugins, expect count', () async {
      final plugin0 = 'plugin0';
      final plugin1 = 'plugin1';

      PluginStoreManager().storePlugins([plugin0, plugin1]);

      final storePlugins = await PluginStoreManager().fetchStorePlugins();

      expect(storePlugins.length, 2);
    });

    test('store minimal toolbar switch, expect bool', () async {
      PluginStoreManager().storeMinimalToolbarSwitch(true);
      final toolbarSwitch =
          await PluginStoreManager().fetchMinimalToolbarSwitch();
      expect(toolbarSwitch, true);
    });
  });
}

import 'package:shared_preferences/shared_preferences.dart';

class PluginStoreManager {
  final String _pluginStoreKey = 'PluginStoreKey';
  final String _minimalToolbarSwitch = 'MinimalToolbarSwitch';
  final String _floatingDotPos = 'FloatingDotPos';

  Future<SharedPreferences> _sharedPref = SharedPreferences.getInstance();

  Future<List<String>?> fetchStorePlugins() async {
    final SharedPreferences prefs = await _sharedPref;
    return prefs.getStringList(_pluginStoreKey);
  }

  void storePlugins(List<String> plugins) async {
    if (plugins == null || plugins.isEmpty) {
      return;
    }
    final SharedPreferences prefs = await _sharedPref;
    await prefs.setStringList(_pluginStoreKey, plugins);
  }

  Future<bool?> fetchMinimalToolbarSwitch() async {
    final SharedPreferences prefs = await _sharedPref;
    return prefs.getBool(_minimalToolbarSwitch);
  }

  void storeMinimalToolbarSwitch(bool value) async {
    if (value == null) {
      return;
    }
    final SharedPreferences prefs = await _sharedPref;
    await prefs.setBool(_minimalToolbarSwitch, value);
  }

  Future<String?> fetchFloatingDotPos() async {
    final SharedPreferences prefs = await _sharedPref;
    return prefs.getString(_floatingDotPos);
  }

  void storeFloatingDotPos(double x, double y) async {
    final SharedPreferences prefs = await _sharedPref;
    prefs.setString(_floatingDotPos, "$x,$y");
  }
}

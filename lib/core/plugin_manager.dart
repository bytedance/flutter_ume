import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume/core/pluggable.dart';

class PluginManager {
  static PluginManager _instance;

  Map<String, Pluggable> get pluginsMap => _pluginsMap;

  Map<String, Pluggable> _pluginsMap = {};

  static PluginManager get instance {
    if (_instance == null) {
      _instance = PluginManager._();
    }
    return _instance;
  }

  PluginManager._();

  void register(Pluggable plugin) {
    if (plugin.name == null ||
        plugin.name.isEmpty ||
        plugin.onTrigger == null) {
      return;
    }
    _pluginsMap[plugin.name] = plugin;
  }

  void registerAll(List<Pluggable> plugins) {
    for (final plugin in plugins) {
      assert(plugin is Pluggable);
      register(plugin);
    }
  }
}

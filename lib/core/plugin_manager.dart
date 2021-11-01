import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume/core/pluggable.dart';

class PluginManager {
  static PluginManager? _instance;

  Map<String, Pluggable?> get pluginsMap => _pluginsMap;

  Map<String, Pluggable?> _pluginsMap = {};

  Pluggable? _activatedPluggable;
  String? get activatedPluggableName => _activatedPluggable?.name;

  static PluginManager get instance {
    if (_instance == null) {
      _instance = PluginManager._();
    }
    return _instance!;
  }

  PluginManager._();

  /// Register a single [plugin]
  void register(Pluggable plugin) {
    if (plugin.name.isEmpty) {
      return;
    }
    _pluginsMap[plugin.name] = plugin;
  }

  /// Register multiple [plugins]
  void registerAll(List<Pluggable> plugins) {
    for (final plugin in plugins) {
      assert(plugin is Pluggable);
      register(plugin);
    }
  }

  void activatePluggable(Pluggable pluggable) {
    _activatedPluggable = pluggable;
  }

  void deactivatePluggable(Pluggable pluggable) {
    if (_activatedPluggable?.name == pluggable.name) {
      _activatedPluggable = null;
    }
  }
}

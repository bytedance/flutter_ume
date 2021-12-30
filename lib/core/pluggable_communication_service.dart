import 'package:flutter/material.dart';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/util/exception_factory.dart';

import 'ui/global.dart';

abstract class Communicable {
  void handleParams(dynamic params);
}

class PluggableCommunicationService {
  static final PluggableCommunicationService _instance =
      PluggableCommunicationService._internal();
  factory PluggableCommunicationService() => _instance;

  final _availableKeys = <String>{};
  List<String> get availableKeys => _availableKeys.toList();
  void registerKeys(String pluggableKey) => _availableKeys.add(pluggableKey);

  PluggableCommunicationService._internal();

  bool isAvailableKey(String pluggableKey) {
    return PluginManager.instance.pluginsMap.containsKey(pluggableKey) &&
        PluginManager.instance.pluginsMap[pluggableKey] is Communicable &&
        _availableKeys.contains(pluggableKey);
  }

  ImageProvider? pluginImageWithKey(String pluggableKey) {
    if (!isAvailableKey(pluggableKey)) return null;
    return PluginManager.instance.pluginsMap[pluggableKey]!.iconImageProvider;
  }

  void callWithKey(String pluggableKey, dynamic params) {
    if (!PluginManager.instance.pluginsMap.containsKey(pluggableKey)) {
      throw ExceptionFactory.pluggableCommunicationNonexistKeyException;
    }
    if (!(PluginManager.instance.pluginsMap[pluggableKey] is Communicable)) {
      throw ExceptionFactory.pluggableCommunicationNotCommunicableException;
    }
    umeEventBus.fire(PluggableChangedEvent(pluggableKey, params: params));
  }
}

class PluggableChangedEvent {
  String pluggableKey;
  Object? params;
  PluggableChangedEvent(this.pluggableKey, {this.params});
}

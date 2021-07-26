import 'dart:async';
import 'package:flutter_ume/core/plugin_manager.dart';
import 'package:flutter_ume/core/pluggable.dart';

class PluggableMessageService {
  static final PluggableMessageService _instance =
      PluggableMessageService._internal();
  factory PluggableMessageService() {
    return _instance;
  }

  // ignore: close_sinks
  StreamController<PluggableMessage> messageStreamController =
      StreamController.broadcast();

  Map<String, PluggableMessageInfo> get pluggableMessageData =>
      _pluggableMessageData;
  Map<String, PluggableMessageInfo> _pluggableMessageData = Map();
  PluggableMessageService._internal() {
    _pluggableMessageData = Map();
  }

  void resetListener() {
    clearListener();

    PluginManager.instance!.pluginsMap.values
        .where((element) => element is PluggableWithStream)
        .forEach((element) {
      final pluggable = element as PluggableWithStream;
      // ignore: cancel_subscriptions
      final subscription = pluggable.stream.where((event) {
        if (pluggable.streamFilter == null) return true;
        return pluggable.streamFilter(event);
      }).listen((event) {
        _pluggableMessageData[pluggable.name]!.increaseCounter();
        _sendSink(pluggable);
      });
      _pluggableMessageData.update(pluggable.name, (old) {
        old.subscription?.cancel();
        return PluggableMessageInfo.subscription(subscription);
      }, ifAbsent: () => PluggableMessageInfo.subscription(subscription));
    });
  }

  int countAll(List<Pluggable?> pluggable) {
    int result = 0;
    pluggable.map((e) => e!.name).toSet().forEach((element) {
      result += (_pluggableMessageData[element]?.count ?? 0);
    });
    return result;
  }

  int count(Pluggable pluggable) =>
      _pluggableMessageData[pluggable.name]?.count ?? 0;

  void resetCounter(Pluggable pluggable) {
    _pluggableMessageData[pluggable.name]?.resetCounter();
    _sendSink(pluggable);
  }

  void clearListener() {
    _pluggableMessageData.values.forEach((messageInfo) {
      messageInfo.subscription?.cancel();
    });
    _pluggableMessageData.clear();
  }

  void _sendSink(Pluggable pluggable) {
    messageStreamController.sink.add(PluggableMessage.create(
        pluggable.name, PluggableMessageService().count(pluggable)));
  }
}

class PluggableMessageInfo {
  StreamSubscription<dynamic>? _subscription;
  int _count = 0;
  StreamSubscription<dynamic>? get subscription => _subscription;
  int get count => _count;

  PluggableMessageInfo.subscription(StreamSubscription<dynamic> subscription) {
    _subscription = subscription;
    _count = 0;
  }

  void increaseCounter() {
    _count++;
  }

  void resetCounter() {
    _count = 0;
  }
}

class PluggableMessage {
  int _count;
  String _key;
  int get count => _count;
  String get key => _key;
  PluggableMessage.create(this._key, this._count);
}

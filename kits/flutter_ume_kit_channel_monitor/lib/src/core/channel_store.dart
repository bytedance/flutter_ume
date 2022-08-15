import 'dart:async';

import 'package:flutter_ume_kit_channel_monitor/src/core/channel_info_model.dart';
import 'package:rxdart/rxdart.dart';

class _ChannelStore {
  final BehaviorSubject<List<String>> _orderedChannelNamePublisher =
      BehaviorSubject();

  final Map<String, List<ChannelInfoModel>> _orderedChannelEvents = {};

  Stream<List<String>> get channelNamePublisher =>
      _orderedChannelNamePublisher.stream;

  void saveChannelInfo(ChannelInfoModel model) {
    if (_orderedChannelEvents[model.channelName] == null) {
      _orderedChannelEvents[model.channelName] = [];
    }
    _orderedChannelEvents[model.channelName]!.add(model);
    refresh();
  }

  void getChannelByName(String name, Sink sink) {
    if (name == '') {
      return;
    }
    sink.add(_orderedChannelEvents[name]);
  }

  void clearChannelRecords() {
    refresh();
  }

  void refresh() {
    _orderedChannelNamePublisher.add(_orderedChannelEvents.keys.toList());
  }
}

_ChannelStore channelStore = _ChannelStore();

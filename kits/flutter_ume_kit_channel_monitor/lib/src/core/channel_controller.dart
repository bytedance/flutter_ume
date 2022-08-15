import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:flutter_ume_kit_channel_monitor/src/core/channel_info_model.dart';
import 'package:flutter_ume_kit_channel_monitor/src/core/channel_store.dart';

class _ChannelController {
  final StandardMethodCodec codec = const StandardMethodCodec();

  void trackChannelEvent(String channel, DateTime sendTime, bool send,
      {ByteData? data,
      MessageHandler? handler,
      ui.PlatformMessageResponseCallback? callback}) {
    MethodCall call = const MethodCall('unknown');
    try {
      call = codec.decodeMethodCall(data);
    } catch (e) {
      debugPrint('decode data failed, caused by: $e');
      debugPrint('data: ${data.toString()}');
    }
    final ChannelInfoModel model = ChannelInfoModel(
      type: ChannelType.method,
      channelName: channel,
      direction: send
          ? TransDirection.flutterToNative
          : TransDirection.nativeToFlutter,
      methodName: call.method,
      timestamp: sendTime,
      duration: DateTime.now().difference(sendTime),
      sendDataSize: send ? (data?.elementSizeInBytes ?? 0) : 0,
      sendData: send ? call.arguments : null,
      receiveData: send ? null : call.arguments,
      receiveDataSize: send ? 0 : (data?.elementSizeInBytes ?? 0),
    );
    channelStore.saveChannelInfo(model);
  }
}

_ChannelController channelController = _ChannelController();

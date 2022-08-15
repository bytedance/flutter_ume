import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ume_kit_channel_monitor/src/core/channel_controller.dart';

// 在 _DefaultBinaryMessenger 的基础上增加数据监控
class UmeBinaryMessenger extends BinaryMessenger {
  static UmeBinaryMessenger binaryMessenger = UmeBinaryMessenger._();

  UmeBinaryMessenger._();

  @override
  Future<void> handlePlatformMessage(String channel, ByteData? data,
      ui.PlatformMessageResponseCallback? callback) async {
    DateTime now = DateTime.now();
    ui.channelBuffers.push(channel, data, (ByteData? data) {
      if (callback != null) {
        callback(data);
      }
      channelController.trackChannelEvent(channel, now, false,
          data: data, callback: callback);
      // print(
      //     '\n handlePlatformMessage: channel: $channel \n  data:${data.toString()} \n');
    });
  }

  @override
  Future<ByteData?>? send(String channel, ByteData? message) {
    DateTime now = DateTime.now();
    final Completer<ByteData?> completer = Completer<ByteData?>();
    // ui.PlatformDispatcher.instance is accessed directly instead of using
    // ServicesBinding.instance.platformDispatcher because this method might be
    // invoked before any binding is initialized. This issue was reported in
    // #27541. It is not ideal to statically access
    // ui.PlatformDispatcher.instance because the PlatformDispatcher may be
    // dependency injected elsewhere with a different instance. However, static
    // access at this location seems to be the least bad option.
    // TODO(ianh): Use ServicesBinding.instance once we have better diagnostics
    // on that getter.
    ui.PlatformDispatcher.instance.sendPlatformMessage(channel, message,
        (ByteData? reply) {
      try {
        completer.complete(reply);
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'services library',
          context:
              ErrorDescription('during a platform message response callback'),
        ));
      }
    });
    channelController.trackChannelEvent(channel, now, true, data: message);
    // print('\n send \n channel: $channel \n message: ${message.toString()} \n}');
    return completer.future;
  }

  @override
  void setMessageHandler(String channel, MessageHandler? handler) {
    DateTime now = DateTime.now();
    if (handler == null) {
      ui.channelBuffers.clearListener(channel);
    } else {
      ui.channelBuffers.setListener(channel,
          (ByteData? data, ui.PlatformMessageResponseCallback callback) async {
        ByteData? response;
        try {
          response = await handler(data);
        } catch (exception, stack) {
          FlutterError.reportError(FlutterErrorDetails(
            exception: exception,
            stack: stack,
            library: 'services library',
            context: ErrorDescription('during a platform message callback'),
          ));
        } finally {
          callback(response);
        }
      });
    }
    channelController.trackChannelEvent(channel, now, false, handler: handler);
    // print(
    //     '\n setMessageHandler \n channel: $channel \n handler: ${handler.toString()} \n');
  }
}

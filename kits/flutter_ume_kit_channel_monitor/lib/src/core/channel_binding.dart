import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ume_kit_channel_monitor/src/core/ume_binary_messenger.dart';

class ChannelBinding extends WidgetsFlutterBinding {
  static WidgetsBinding? ensureInitialized() {
    if (WidgetsBinding.instance == null) {
      // make sure init this before WidgetsFlutterBinding ensureInitialized called
      ChannelBinding();
    }
    return WidgetsBinding.instance;
  }

  @override
  @protected
  // 替换 BinaryMessenger
  BinaryMessenger createBinaryMessenger() {
    return UmeBinaryMessenger.binaryMessenger;
  }
}

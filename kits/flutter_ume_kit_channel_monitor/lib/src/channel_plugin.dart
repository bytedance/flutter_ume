import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_channel_monitor/src/ui/channel_pages.dart';
import 'dart:convert';
import 'core/channel_binding.dart';
import 'icon.dart' as icon;

class ChannelPlugin extends Pluggable {
  ChannelPlugin() {
    ChannelBinding.ensureInitialized();
  }

  @override
  Widget buildWidget(BuildContext? context) {
    return const ChannelPages();
  }

  @override
  String get displayName => 'Channel Monitor';

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'Channel Monitor';

  @override
  void onTrigger() {}
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ume/core/pluggable.dart';

import 'icon.dart' as icon;

class UMENetworkPanel extends StatefulWidget implements PluggableWithStream {
  const UMENetworkPanel({Key? key}) : super(key: key);

  @override
  _UMENetworkPanelState createState() => _UMENetworkPanelState();

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'Network';

  @override
  String get displayName => 'Network';

  @override
  Stream get stream => Stream.empty();

  @override
  StreamFilter get streamFilter => (e) => true;

  @override
  void onTrigger() {}

  @override
  Widget buildWidget(BuildContext? context) => this;
}

class _UMENetworkPanelState extends State<UMENetworkPanel> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

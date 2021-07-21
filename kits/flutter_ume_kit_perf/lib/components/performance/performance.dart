import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'icon.dart' as icon;

class Performance extends StatelessWidget implements Pluggable {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 20),
        child: SizedBox(
            child: PerformanceOverlay.allEnabled(),
            width: MediaQuery.of(context).size.width));
  }

  @override
  Widget buildWidget(BuildContext context) => this;

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'PerfOverlay';

  @override
  String get displayName => 'PerfOverlay';

  @override
  void onTrigger() {}
}

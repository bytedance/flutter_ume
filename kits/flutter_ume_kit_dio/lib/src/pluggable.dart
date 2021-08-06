///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/8/6 11:24
///
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ume/core/pluggable.dart';

import 'widgets/icon.dart' as icon;
import 'widgets/pluggable_state.dart';

class DioPluggable extends StatefulWidget implements Pluggable {
  const DioPluggable({Key? key}) : super(key: key);

  @override
  DioPluggableState createState() => DioPluggableState();

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'Dio';

  @override
  String get displayName => 'Dio';

  @override
  void onTrigger() {}

  @override
  Widget buildWidget(BuildContext? context) => this;
}

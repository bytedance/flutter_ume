import 'dart:convert';

import 'package:example/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:tuple/tuple.dart';
import 'icon.dart' as icon;

class CustomRouterPluggable implements PluggableWithAnywhereDoor {
  NavigatorState? nav;

  @override
  Widget? buildWidget(BuildContext? context) {
    return null;
  }

  @override
  String get displayName => 'ToDetail';

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  String get name => 'ToDetail';

  @override
  NavigatorState get navigator => nav!;

  @override
  void onTrigger() {}

  @override
  void popResultReceive(result) {
    print(result.toString());
  }

  @override
  Route? get route =>
      null; // or MaterialPageRoute(builder: (ctx) => DetailPage());

  @override
  Tuple2<String, Object?>? get routeNameAndArgs =>
      Tuple2('detail', {'arg': 'custom params'});
//      null; // or Tuple2('DetailPage', null);
}

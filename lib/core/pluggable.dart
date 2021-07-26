import 'package:flutter/widgets.dart';

abstract class Pluggable {
  String get name;
  String get displayName;
  void onTrigger();
  Widget buildWidget(BuildContext? context);
  ImageProvider get iconImageProvider;
}

typedef StreamFilter = bool Function(dynamic);

abstract class PluggableWithStream extends Pluggable {
  Stream get stream;
  StreamFilter get streamFilter;
}

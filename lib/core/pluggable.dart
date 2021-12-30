import 'package:flutter/widgets.dart';

abstract class Pluggable {
  String get name;
  String get displayName;
  void onTrigger();
  Widget buildWidget(BuildContext? context);
  ImageProvider get iconImageProvider;
}

abstract class PluggableLifeCycle {
  void onActivate();
  void onDeactivate();
}

typedef StreamFilter = bool Function(dynamic);

abstract class PluggableWithStream extends Pluggable {
  Stream get stream;
  StreamFilter get streamFilter;
}

abstract class PluggableWithNestedWidget extends Pluggable {
  Widget buildNestedWidget(Widget child);
}

import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

abstract class PluggableInterface {
  String get name;
  void onTrigger();
  Widget? buildWidget(BuildContext? context);
  ImageProvider get iconImageProvider;
}

abstract class Pluggable extends PluggableInterface {
  String get name;
  String get displayName;
  void onTrigger();
  Widget? buildWidget(BuildContext? context);
  ImageProvider get iconImageProvider;
}

typedef StreamFilter = bool Function(dynamic);

abstract class PluggableWithStream extends Pluggable {
  Stream get stream;
  StreamFilter get streamFilter;
}

abstract class PluggableWithNestedWidget extends Pluggable {
  Widget buildNestedWidget(Widget child);
}

abstract class PluggableWithAnywhereDoor extends Pluggable {
  NavigatorState? get navigator;

  Tuple2<String, Object?>? get routeNameAndArgs;
  Route? get route;

  void popResultReceive(dynamic result);
}

import 'package:touch_indicator/touch_indicator.dart' as ti;
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'icon.dart' as icon;

class TouchIndicator extends StatelessWidget
    implements PluggableWithNestedWidget {
  const TouchIndicator({Key? key}) : super(key: key);

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  String get name => 'TouchIndicator';

  @override
  String get displayName => 'TouchIndicator';

  @override
  void onTrigger() {}

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  Widget buildNestedWidget(Widget child) {
    return ti.TouchIndicator(child: child);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

import 'dart:convert';

import 'package:flutter_ume_kit_ui/third_party/cyclop/lib/cyclop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'icon.dart' as icon;

class Palette extends StatefulWidget
    implements Pluggable, Communicable, PluggableLifeCycle {
  Palette({Key? key}) : super(key: key);

  Color? initialColor;

  @override
  _PaletteState createState() => _PaletteState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  String get name => 'Palette';

  @override
  String get displayName => 'Palette';

  @override
  void onTrigger() {}

  @override
  ImageProvider<Object> get iconImageProvider =>
      MemoryImage(base64Decode(icon.iconData));

  @override
  void handleParams(dynamic params) {
    if (params is Map && params.containsKey('initialColor')) {
      initialColor = params['initialColor'];
    }
  }

  @override
  void onDeactivate() {
    initialColor = null;
  }

  @override
  void onActivate() {}
}

class _PaletteState extends State<Palette> {
  late Color backgroundColor;

  Set<Color> swatches = Colors.primaries.map((e) => Color(e.value)).toSet();

  @override
  void initState() {
    super.initState();
    if (widget.initialColor != null) {
      backgroundColor = widget.initialColor!;
    } else {
      backgroundColor = Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ColorButton(
        key: const Key('c1'),
        color: backgroundColor,
        swatches: swatches,
        onColorChanged: (value) => setState(() => backgroundColor = value),
        onSwatchesChanged: (newSwatches) =>
            setState(() => swatches = newSwatches),
      ),
    );
  }
}

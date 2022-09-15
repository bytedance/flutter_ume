import 'package:flutter_ume_kit_ui/third_party/cyclop/lib/cyclop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'icon.dart' as icon;

class ColorPicker extends StatefulWidget implements PluggableWithNestedWidget {
  const ColorPicker({Key? key}) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();

  @override
  Widget buildWidget(BuildContext? context) => this;

  @override
  String get name => 'ColorPicker';

  @override
  String get displayName => 'TouchIndicator';

  @override
  void onTrigger() {}

  @override
  ImageProvider<Object> get iconImageProvider => MemoryImage(icon.iconBytes);

  @override
  Widget buildNestedWidget(Widget child) {
    return EyeDrop(child: child);
  }
}

class _ColorPickerState extends State<ColorPicker> {
  final colorTextStyle = TextStyle(
      fontFamily: "Monospace", fontWeight: FontWeight.bold, fontSize: 20);

  Color? _color;

  bool _panelDown = true;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (downEvent) {},
      onPointerMove: (moveEvent) {
        setState(() => _panelDown =
            moveEvent.position.dy < MediaQuery.of(context).size.height * 0.5);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: Align(
            alignment:
                _panelDown ? Alignment.bottomCenter : Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 28, bottom: 28),
              child: Container(
                  decoration: ShapeDecoration(
                    shape: StadiumBorder(),
                    color: Colors.white,
                    shadows: [
                      BoxShadow(color: Colors.black54, blurRadius: 12),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                          radius: 40,
                          backgroundColor: _color,
                          child: EyedropperButton(
                            onColor: (color) => setState(() => _color = color),
                            onColorChanged: (color) =>
                                setState(() => _color = color),
                          )),
                      GestureDetector(
                        onTap: () {
                          debugPrint(_color?.hexARGB.toString());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 18.0),
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text:
                                    '${_color?.hexARGB.toString().substring(0, 2) ?? '👈🏻Tap to pick'}',
                                style: colorTextStyle.copyWith(
                                    color: Colors.grey)),
                            TextSpan(
                                text:
                                    '${_color?.hexARGB.toString().substring(2, 4) ?? ''}',
                                style:
                                    colorTextStyle.copyWith(color: Colors.red)),
                            TextSpan(
                                text:
                                    '${_color?.hexARGB.toString().substring(4, 6) ?? ''}',
                                style: colorTextStyle.copyWith(
                                    color: Colors.green)),
                            TextSpan(
                                text:
                                    '${_color?.hexARGB.toString().substring(6, 8) ?? ''}',
                                style: colorTextStyle.copyWith(
                                    color: Colors.blue)),
                          ])),
                        ),
                      )
                    ],
                  )),
            )),
      ),
    );
  }
}

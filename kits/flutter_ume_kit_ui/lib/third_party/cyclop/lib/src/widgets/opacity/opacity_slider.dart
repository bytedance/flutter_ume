import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme.dart';
import 'opacity_slider_thumb.dart';
import 'opacity_slider_track.dart';

class OpacitySlider extends StatelessWidget {
  final double opacity;

  final Color selectedColor;

  final ValueChanged<double> onChange;

  const OpacitySlider({
    required this.opacity,
    required this.selectedColor,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return FutureBuilder<ui.Image>(
      future: getGridImage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(Labels.opacity, style: textTheme.subtitle2),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Theme(
                      data: _opacitySliderTheme(selectedColor),
                      child: Slider(
                        value: opacity,
                        min: 0,
                        max: 1,
                        divisions: 100,
                        onChanged: onChange,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.inputDecorationTheme.fillColor,
                      borderRadius: defaultBorderRadius,
                    ),
                    width: 60,
                    child: Text(
                      '${(opacity * 100).toInt()}%',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

ui.Image? _gridImage;

Future<ui.Image> getGridImage() {
  if (_gridImage != null) return Future.value(_gridImage!);
  final completer = Completer<ui.Image>();
  const AssetImage('packages/cyclop/assets/grid.png')
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    _gridImage = info.image;
    completer.complete(_gridImage);
  }));
  return completer.future;
}

ThemeData _opacitySliderTheme(Color color) => ThemeData.light().copyWith(
      sliderTheme: SliderThemeData(
        trackHeight: 24,
        thumbColor: Colors.white,
        trackShape: OpacitySliderTrack(color, gridImage: _gridImage!),
        thumbShape: OpacitySliderThumbShape(color),
      ),
    );

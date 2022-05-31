import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../../utils.dart';

const _cellSize = 10;

const _gridSize = 90.0;

class EyeDropOverlay extends StatelessWidget {
  final Offset? cursorPosition;
  final bool touchable;

  final List<Color> colors;

  const EyeDropOverlay({
    required this.colors,
    this.cursorPosition,
    this.touchable = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return cursorPosition != null
        ? Positioned(
            left: cursorPosition!.dx - (_gridSize / 2),
            top: cursorPosition!.dy -
                (_gridSize / 2) -
                (touchable ? _gridSize / 2 : 0),
            width: _gridSize,
            height: _gridSize,
            child: _buildZoom(),
          )
        : const SizedBox.shrink();
  }

  Widget _buildZoom() {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        foregroundDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 8, color: colors.isEmpty ? Colors.white : colors.center),
        ),
        width: _gridSize,
        height: _gridSize,
        constraints: BoxConstraints.loose(const Size.square(_gridSize)),
        child: ClipOval(
          child: CustomPaint(
            size: const Size.square(_gridSize),
            painter: _PixelGridPainter(colors),
          ),
        ),
      ),
    );
  }
}

/// paint a hovered pixel/colors preview
class _PixelGridPainter extends CustomPainter {
  final List<Color> colors;

  static const gridSize = 9;
  static const eyeRadius = 35.0;

  final blackStroke = Paint()
    ..color = Colors.black
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;

  _PixelGridPainter(this.colors);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    final blackLine = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final selectedStroke = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // fill pixels color square
    for (final color in enumerate(colors)) {
      final fill = Paint()..color = color.value;
      final rect = Rect.fromLTWH(
        (color.index % gridSize).toDouble() * _cellSize,
        ((color.index ~/ gridSize) % gridSize).toDouble() * _cellSize,
        _cellSize.toDouble(),
        _cellSize.toDouble(),
      );
      canvas.drawRect(rect, fill);
    }

    // draw pixels borders after fills
    for (final color in enumerate(colors)) {
      final rect = Rect.fromLTWH(
        (color.index % gridSize).toDouble() * _cellSize,
        ((color.index ~/ gridSize) % gridSize).toDouble() * _cellSize,
        _cellSize.toDouble(),
        _cellSize.toDouble(),
      );
      canvas.drawRect(
          rect, color.index == colors.length ~/ 2 ? selectedStroke : stroke);

      if (color.index == colors.length ~/ 2) {
        canvas.drawRect(rect.deflate(1), blackLine);
      }
    }

    // black contrast ring
    canvas.drawCircle(
      const Offset((_gridSize) / 2, (_gridSize) / 2),
      eyeRadius,
      blackStroke,
    );
  }

  @override
  bool shouldRepaint(_PixelGridPainter oldDelegate) =>
      !listEquals(oldDelegate.colors, colors);
}

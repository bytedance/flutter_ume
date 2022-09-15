import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../utils.dart';

const _cellSize = 25.0;
const _numColumns = 12;

const _cellBorderWidth = 3.0;

class GridColorSelector extends StatelessWidget {
  final Color selectedColor;

  final ValueChanged<Color> onColorSelected;

  const GridColorSelector({
    required this.selectedColor,
    required this.onColorSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1.1,
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.all(Radius.circular(defaultRadius)),
            child: GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              crossAxisCount: 12,
              childAspectRatio: 1,
              children: _buildColorsTiles(),
            ),
          ),
        ),
      );

  List<Widget> _buildColorsTiles() =>
      _buildColorGridValues().map(_buildCell).toList();

  List<Color> _buildColorGridValues({int columns = _numColumns}) => [
        ...Colors.white.getShades(columns, skipFirst: false),
        for (final primary in Colors.primaries) ...primary.getShades(columns)
      ];

  GestureDetector _buildCell(Color color) => GestureDetector(
        onTap: () => onColorSelected(color),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(isSelected(color) ? _cellBorderWidth : 0),
          child: Container(color: color, width: _cellSize, height: _cellSize),
        ),
      );

  bool isSelected(Color color) =>
      selectedColor.withOpacity(1).value == color.withOpacity(1).value;
}

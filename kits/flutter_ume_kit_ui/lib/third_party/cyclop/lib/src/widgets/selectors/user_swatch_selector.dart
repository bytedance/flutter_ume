import 'package:basics/int_basics.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';

const _maxSwatch = 50;

class SwatchLibrary extends StatefulWidget {
  final Set<Color> colors;
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<Set<Color>>? onSwatchesUpdate;

  const SwatchLibrary({
    required this.currentColor,
    required this.onColorSelected,
    this.onSwatchesUpdate,
    this.colors = const {},
    Key? key,
  }) : super(key: key);

  bool get canAdd => !colors.contains(currentColor);

  @override
  _SwatchLibraryState createState() => _SwatchLibraryState();
}

class _SwatchLibraryState extends State<SwatchLibrary> {
  late Set<Color> colors;

  @override
  void initState() {
    super.initState();
    colors = widget.colors.take(_maxSwatch).toSet();
  }

  @override
  void didUpdateWidget(SwatchLibrary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setsEqual(oldWidget.colors, widget.colors)) {
      colors = widget.colors;
      colors = widget.colors.take(_maxSwatch).toSet();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 8,
      children: [
        ...colors.take(_maxSwatch).map(_colorToSwatch),
        if (colors.length < _maxSwatch) _buildNewColorButton(theme)
      ],
    );
  }

  Widget _colorToSwatch(Color color) => GestureDetector(
        onTap: () => widget.onColorSelected(color),
        onDoubleTap: widget.onSwatchesUpdate == null
            ? null
            : () {
                widget.onSwatchesUpdate!(colors..remove(color));
                setState(() {});
              },
        child: Tooltip(
          height: 52,
          showDuration: 0.seconds,
          message: 'Tap to select /\nDouble Tap to remove',
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(4),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            foregroundDecoration: BoxDecoration(
              border: color == widget.currentColor
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );

  Container _buildNewColorButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: IconButton(
          color:
              widget.canAdd ? theme.toggleableActiveColor : theme.disabledColor,
          icon: const Icon(Icons.add),
          onPressed: widget.canAdd && widget.onSwatchesUpdate != null
              ? () {
                  setState(() => colors.add(widget.currentColor));
                  final newSwatches = widget.colors..add(widget.currentColor);
                  widget.onSwatchesUpdate!(newSwatches);
                }
              : null,
        ),
      ),
    );
  }
}

import 'package:basics/int_basics.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../theme.dart';

const _kTabWidth = 86.0;

/// custom Tabbar component
class Tabs extends StatefulWidget {
  final int selectedIndex;

  final List<String> labels;

  final List<Widget> views;

  const Tabs({
    required this.labels,
    required this.views,
    this.selectedIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int selectedIndex = 0;

  Alignment get markerPosition {
    switch (selectedIndex) {
      case 0:
        return Alignment.topLeft;
      case 1:
        return widget.labels.length == 2
            ? Alignment.topRight
            : Alignment.topCenter;
      case 2:
        return Alignment.topRight;
    }
    throw Exception();
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTabs(theme, size),
        Flexible(fit: FlexFit.loose, child: widget.views[selectedIndex])
      ],
    );
  }

  Container _buildTabs(ThemeData theme, Size size) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      constraints: const BoxConstraints.expand(height: 42),
      decoration: BoxDecoration(
        borderRadius: defaultBorderRadius,
        color: theme.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: 200.milliseconds,
              curve: Curves.fastOutSlowIn,
              alignment: markerPosition,
              child: Container(
                width: _kTabWidth,
                height: size.height,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: defaultBorderRadius,
                  boxShadow: defaultShadowBox,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: enumerate(widget.labels)
                  .map((label) => _buildTab(label, height: size.height))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  void _onSelectionChanged(int newIndex) =>
      setState(() => selectedIndex = newIndex);

  Widget _buildTab(IndexedValue<String> label, {required double height}) =>
      SizedBox(
        width: _kTabWidth,
        height: height,
        child: TextButton(
          onPressed: () => _onSelectionChanged(label.index),
          child: Text(label.value),
        ),
      );
}

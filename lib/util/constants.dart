import 'package:flutter/material.dart';

const Size dotSize = Size(65.0, 65.0);

const double margin = 10.0;

const double bottomDistance = margin * 4;

const int kMaxTooltipLines = 10;

const double kScreenEdgeMargin = 10.0;

const double kTooltipPadding = 5.0;

const Color kTooltipBackgroundColor = Color.fromARGB(230, 60, 60, 60);

const Color kHighlightedRenderObjectFillColor =
    Color.fromARGB(128, 128, 128, 255);

const Color kHighlightedRenderObjectBorderColor =
    Color.fromARGB(128, 64, 64, 128);

const Color kTipTextColor = Color(0xFFFFFFFF);

final double ratio = WidgetsBinding.instance.window.devicePixelRatio;

final Size windowSize = WidgetsBinding.instance.window.physicalSize / ratio;

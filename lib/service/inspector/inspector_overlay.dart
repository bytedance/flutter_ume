import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter_ume/util/constants.dart';

class InspectorOverlay extends LeafRenderObjectWidget {
  const InspectorOverlay(
      {Key? key,
      required this.selection,
      this.needEdges = true,
      this.needDescription = true})
      : super(key: key);

  final InspectorSelection selection;

  final bool needDescription;

  final bool needEdges;

  @override
  _RenderInspectorOverlay createRenderObject(BuildContext context) {
    return _RenderInspectorOverlay(
        selection: selection,
        needDescription: needDescription,
        needEdges: needEdges);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderInspectorOverlay renderObject) {
    renderObject.selection = selection;
  }
}

class _RenderInspectorOverlay extends RenderBox {
  _RenderInspectorOverlay({
    required InspectorSelection selection,
    required this.needDescription,
    required this.needEdges,
  })  : _selection = selection;

  final bool needDescription;
  final bool needEdges;

  InspectorSelection get selection => _selection;
  InspectorSelection _selection;
  set selection(InspectorSelection value) {
    if (value != _selection) {
      _selection = value;
    }
    markNeedsPaint();
  }

  @override
  bool get sizedByParent => true;

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  void performResize() {
    size = constraints.constrain(const Size(double.infinity, double.infinity));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(needsCompositing);
    context.addLayer(_InspectorOverlayLayer(
      needEdges: needEdges,
      needDescription: needDescription,
      overlayRect: Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
      selection: selection,
    ));
  }
}

class _InspectorOverlayLayer extends Layer {
  _InspectorOverlayLayer({
    required this.overlayRect,
    required this.selection,
    required this.needDescription,
    required this.needEdges,
  });

  InspectorSelection selection;

  final bool needDescription;

  final bool needEdges;

  final Rect overlayRect;

  _InspectorOverlayRenderState? _lastState;

  late ui.Picture _picture;

  TextPainter? _textPainter;
  double? _textPainterMaxWidth;

  @override
  void addToScene(ui.SceneBuilder builder, [Offset layerOffset = Offset.zero]) {
    if (!selection.active) return;

    final _SelectionInfo info = _SelectionInfo(selection);
    final RenderObject? selected = info.renderObject;
    final List<_TransformedRect> candidates = <_TransformedRect>[];
    for (RenderObject candidate in selection.candidates) {
      if (candidate == selected || !candidate.attached) continue;
      candidates.add(_TransformedRect(candidate));
    }

    final _InspectorOverlayRenderState state = _InspectorOverlayRenderState(
      selectionInfo: info,
      overlayRect: overlayRect,
      selected: _TransformedRect(selected!),
      textDirection: TextDirection.ltr,
      candidates: candidates,
    );

    if (state != _lastState) {
      _lastState = state;
      _picture = _buildPicture(state);
    }
    builder.addPicture(layerOffset, _picture);
  }

  ui.Picture _buildPicture(_InspectorOverlayRenderState state) {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder, state.overlayRect);
    final Size size = state.overlayRect.size;

    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = kHighlightedRenderObjectFillColor;

    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = kHighlightedRenderObjectBorderColor;

    final Rect selectedPaintRect = state.selected.rect.deflate(0.5);
    canvas
      ..save()
      ..transform(state.selected.transform.storage)
      ..drawRect(selectedPaintRect, fillPaint)
      ..drawRect(selectedPaintRect, borderPaint)
      ..restore();

    if (needEdges) {
      for (_TransformedRect transformedRect in state.candidates) {
        canvas
          ..save()
          ..transform(transformedRect.transform.storage)
          ..drawRect(transformedRect.rect.deflate(0.5), borderPaint)
          ..restore();
      }
    }
    final Rect targetRect = MatrixUtils.transformRect(
        state.selected.transform, state.selected.rect);
    final Offset target = Offset(targetRect.left, targetRect.center.dy);
    const double offsetFromWidget = 9.0;
    final double verticalOffset = (targetRect.height) / 2 + offsetFromWidget;

    if (needDescription) {
      _paintDescription(canvas, state.selectionInfo.message,
          state.textDirection, target, verticalOffset, size, targetRect);
    }
    return recorder.endRecording();
  }

  void _paintDescription(
    Canvas canvas,
    String message,
    TextDirection textDirection,
    Offset target,
    double verticalOffset,
    Size size,
    Rect targetRect,
  ) {
    canvas.save();
    final double maxWidth =
        size.width - 2 * (kScreenEdgeMargin + kTooltipPadding);
    final TextSpan? textSpan = _textPainter?.text as TextSpan?;
    if (_textPainter == null ||
        textSpan!.text != message ||
        _textPainterMaxWidth != maxWidth) {
      _textPainterMaxWidth = maxWidth;
      _textPainter = TextPainter()
        ..maxLines = kMaxTooltipLines
        ..ellipsis = '...'
        ..text = TextSpan(
            style: TextStyle(color: kTipTextColor, fontSize: 12.0, height: 1.2),
            text: message)
        ..textDirection = textDirection
        ..layout(maxWidth: maxWidth);
    }

    final Size tooltipSize = _textPainter!.size +
        const Offset(kTooltipPadding * 2, kTooltipPadding * 2);
    final Offset tipOffset = positionDependentBox(
      size: size,
      childSize: tooltipSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: false,
    );

    final Paint tooltipBackground = Paint()
      ..style = PaintingStyle.fill
      ..color = kTooltipBackgroundColor;
    canvas.drawRect(
      Rect.fromPoints(
        tipOffset,
        tipOffset.translate(tooltipSize.width, tooltipSize.height),
      ),
      tooltipBackground,
    );

    double wedgeY = tipOffset.dy;
    final bool tooltipBelow = tipOffset.dy > target.dy;
    if (!tooltipBelow) wedgeY += tooltipSize.height;

    const double wedgeSize = kTooltipPadding * 2;
    double wedgeX = math.max(tipOffset.dx, target.dx) + wedgeSize * 2;
    wedgeX = math.min(wedgeX, tipOffset.dx + tooltipSize.width - wedgeSize * 2);
    final List<Offset> wedge = <Offset>[
      Offset(wedgeX - wedgeSize, wedgeY),
      Offset(wedgeX + wedgeSize, wedgeY),
      Offset(wedgeX, wedgeY + (tooltipBelow ? -wedgeSize : wedgeSize)),
    ];
    canvas.drawPath(Path()..addPolygon(wedge, true), tooltipBackground);
    _textPainter!.paint(
        canvas, tipOffset + const Offset(kTooltipPadding, kTooltipPadding));
    canvas.restore();
  }

  @override
  @protected
  bool findAnnotations<S extends Object>(
      AnnotationResult<S> result, Offset localPosition,
      {required bool onlyFirst}) {
    return false;
  }
}

class _SelectionInfo {
  const _SelectionInfo(this.selection);
  final InspectorSelection selection;

  RenderObject? get renderObject => selection.current;

  Element? get element => selection.currentElement;

  Map? get jsonInfo {
    if (renderObject == null) return null;
    final widgetId = WidgetInspectorService.instance
        // ignore: invalid_use_of_protected_member
        .toId(renderObject!.toDiagnosticsNode(), '');
    if (widgetId == null) return null;
    String infoStr =
        WidgetInspectorService.instance.getSelectedSummaryWidget(widgetId, '');
    return json.decode(infoStr);
  }

  String? get filePath {
    final f = (jsonInfo != null && jsonInfo!.containsKey('creationLocation'))
        ? jsonInfo!['creationLocation']['file']
        : '';
    return f;
  }

  int? get line {
    final l = (jsonInfo != null && jsonInfo!.containsKey('creationLocation'))
        ? jsonInfo!['creationLocation']['line']
        : 0;
    return l;
  }

  String get message {
    return '''${element!.toStringShort()}\nsize: ${renderObject!.paintBounds.size}\nfilePath: $filePath\nline: $line''';
  }
}

class _InspectorOverlayRenderState {
  _InspectorOverlayRenderState({
    required this.overlayRect,
    required this.selected,
    required this.candidates,
    required this.textDirection,
    required this.selectionInfo,
  });

  final Rect overlayRect;
  final _TransformedRect selected;
  final List<_TransformedRect> candidates;
  final TextDirection textDirection;
  final _SelectionInfo selectionInfo;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;

    final _InspectorOverlayRenderState typedOther = other;
    return overlayRect == typedOther.overlayRect &&
        selected == typedOther.selected &&
        listEquals<_TransformedRect>(candidates, typedOther.candidates);
  }

  @override
  int get hashCode => hashValues(overlayRect, selected, hashList(candidates));
}

class _TransformedRect {
  _TransformedRect(RenderObject object)
      : rect = object.semanticBounds,
        transform = object.getTransformTo(null);

  final Rect rect;
  final Matrix4 transform;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _TransformedRect typedOther = other;
    return rect == typedOther.rect && transform == typedOther.transform;
  }

  @override
  int get hashCode => hashValues(rect, transform);
}

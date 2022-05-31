import 'dart:js' as js;

/// Color picker config
/// allow to disable some part of the picker :
/// - [enableOpacity] : hide/show the opacity slider
/// - [enableLibrary] : hide/show the custom swatches library tab
/// - [enableEyePicker] : hide/show the eyedropper button ( should be disabled in html renderer )
///
/// With Flutter web the eyedropper and opacity is disabled in the html renderer
class ColorPickerConfig {
  /// hide/show the custom swatches library tab
  final bool enableLibrary;

  final bool _enableOpacity;

  /// only enable opacity in canvasKit
  bool get enableOpacity =>
      _enableOpacity && js.context['flutterCanvasKit'] != null;

  final bool _enableEyePicker;

  /// only enable eyeDropper in canvasKit
  bool get enableEyePicker =>
      _enableEyePicker && js.context['flutterCanvasKit'] != null;

  const ColorPickerConfig({
    this.enableLibrary = true,
    bool enableOpacity = true,
    bool enableEyePicker = true,
  })  : _enableEyePicker = enableEyePicker,
        _enableOpacity = enableOpacity;
}

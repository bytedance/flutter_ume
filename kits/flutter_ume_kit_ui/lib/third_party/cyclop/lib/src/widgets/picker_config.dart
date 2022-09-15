/// Color picker config
/// allow to disable some part of the picker :
/// - [enableOpacity] : hide/show the opacity slider
/// - [enableLibrary] : hide/show the custom library tab
/// - [enableEyePicker] : hide/show the eyedropper button ( should be disabled in html renderer )
class ColorPickerConfig {
  /// hide/show the opacity slider
  final bool enableOpacity;

  /// hide/show the custom library tab
  final bool enableLibrary;

  /// hide/show the eyedropper button ( should be disabled in html renderer )
  final bool enableEyePicker;

  const ColorPickerConfig({
    this.enableOpacity = true,
    this.enableLibrary = true,
    this.enableEyePicker = true,
  });
}

# Cyclop [![Pub Version](https://img.shields.io/pub/v/cyclop)](https://pub.dev/packages/cyclop)

![Cyclop logo](https://github.com/rxlabz/paco/raw/master/assets/cyclop_banner.png)

A flutter colorpicker with an eyedropper tool. Works on mobile, desktop & web ( CanvasKit)

## [Demo](https://rxlabz.github.io/cyclop/)

| Desktop & tablet  |  Mobile|
| --- | --- |
| ![Cyclop desktop eyedropper](https://github.com/rxlabz/cyclop/raw/master/assets/cyclop.gif) | ![Cyclop onmobile](https://github.com/rxlabz/cyclop/raw/master/assets/pacomob.gif) |


| Material | HSL | RVB | Custom |
| --- | --- | --- | --- |
| ![Cyclop material](https://github.com/rxlabz/cyclop/raw/master/assets/cyclop_material.png) | ![Cyclop hsl](https://github.com/rxlabz/cyclop/raw/master/assets/cyclop_hsl.png) | ![Cyclop hsl](https://github.com/rxlabz/cyclop/raw/master/assets/cyclop_rvb.png) | ![Cyclop hsl](https://github.com/rxlabz/cyclop/raw/master/assets/cyclop_custom.png) |



| Light theme | Dark theme |
| --- | --- |
| ![Cyclop light](https://github.com/rxlabz/cyclop/raw/master/assets/cyclop_hsl.png) | ![Cyclop dark](https://github.com/rxlabz/cyclop/raw/master/assets/cyclop_dark.png) |


### Eyedropper

Select a color from your Flutter mobile or desktop screen.

![Cyclop eye dropper](https://github.com/rxlabz/cyclop/raw/master/assets/paco_eyedropper.png) 

To use the eyedropper you need to wrap the app in the EyeDrop widget.

```dart
@override
  Widget build(BuildContext context) {
    return EyeDrop(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: backgroundColor,
          body: Container(
            child: ColorButton(
              key: Key('c1'),
              color: color1,
              config: ColorPickerConfig(enableEyePicker = true),
              size: 32,
              elevation: 5,
              boxShape: BoxShape.rectangle, // default : circle
              swatches: swatches,
              onColorChanged: (value) => setState(() => color1 = value),
            ),
          ),
        ),
      ),
    );
  }
```

### Customisable

- disable opacity slider
- disable eye dropping 
- disable swatch library
- Circle or Square color buttons

```dart
ColorButton(
  key: Key('c1'),
  color: color1,
  config: ColorPickerConfig(
    this.enableOpacity = true,
    this.enableLibrary = false,
    this.enableEyePicker = true,
  ),
  boxShape: BoxShape.rectangle, // default : circle
  size: 32,
  swatches: swatches,
  onColorChanged: (value) => setState( () => color1 = value ),
 );

ColorButton(
  key: Key('c2'),
  color: color2,
  config: ColorPickerConfig(enableEyePicker: false),
  size: 64,
  swatches: swatches,
  onColorChanged: (value) => setState( () => color2 = value ),
  onSwatchesChanged: (newSwatches) => setState(() => swatches = newSwatches),
 );
```









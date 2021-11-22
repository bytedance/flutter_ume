import 'package:flutter/material.dart';

class Labels {
  static const String mainTitle = 'Colors';
  static const String opacity = 'Opacity';
  static const String red = 'Red';
  static const String green = 'Green';
  static const String blue = 'Blue';
  static const String hue = 'Hue';
  static const String saturation = 'Saturation';
  static const String light = 'Lightness';
}

const defaultRadius = 8.0;

const defaultBorderRadius = BorderRadius.all(Radius.circular(defaultRadius));

final lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xfff0f0f0),
  backgroundColor: const Color(0xffdadada),
  toggleableActiveColor: Colors.cyan,
  inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(defaultRadius)),
      ),
  dialogTheme: ThemeData.light().dialogTheme.copyWith(
        backgroundColor: const Color(0xfff6f6f6),
      ),
  iconTheme: ThemeData.light().iconTheme.copyWith(color: Colors.blue),
  textButtonTheme: TextButtonThemeData(style: _lightTextButtonStyle),
);

final darkTheme = ThemeData.dark().copyWith(
  backgroundColor: Colors.grey.shade700,
  toggleableActiveColor: Colors.cyan,
  textSelectionTheme: ThemeData.light()
      .textSelectionTheme
      .copyWith(selectionColor: Colors.cyan.shade700),
  dialogTheme: ThemeData.light().dialogTheme.copyWith(
        backgroundColor: Colors.grey.shade800,
      ),
  inputDecorationTheme:
      lightTheme.inputDecorationTheme.copyWith(fillColor: Colors.grey.shade800),
  textButtonTheme: TextButtonThemeData(style: _darkTextButtonStyle),
);

final _lightTextButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all(
    const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  ),
  padding: MaterialStateProperty.all(
    const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
  ),
  foregroundColor: MaterialStateProperty.all(Colors.grey.shade700),
  overlayColor: MaterialStateProperty.all(Colors.white30),
);

final _darkTextButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all(
    const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  ),
  padding: MaterialStateProperty.all(
    const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
  ),
  foregroundColor: MaterialStateProperty.all(Colors.white70),
  overlayColor: MaterialStateProperty.all(Colors.black12),
);

const defaultDivider = Divider(
  color: Color(0xff999999),
  indent: 8,
  height: 10,
  endIndent: 8,
);

const shadowColor = Color(0x44333333);

const darkShadowColor = Color(0x99333333);

const defaultShadowBox = [
  BoxShadow(blurRadius: 3, spreadRadius: 1, color: shadowColor)
];

const darkShadowBox = [
  BoxShadow(blurRadius: 3, spreadRadius: 1, color: darkShadowColor)
];

const largeDarkShadowBox = [
  BoxShadow(blurRadius: 10, spreadRadius: 5, color: shadowColor)
];

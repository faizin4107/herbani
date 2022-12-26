import 'package:flutter/material.dart';

class ColorCustom extends Color {
  static int _getColorFromHex(String flutterColor) {
    flutterColor = flutterColor.toUpperCase().replaceAll("#", "");
    if (flutterColor.length == 6) {
      flutterColor = "FF$flutterColor";
    }
    return int.parse(flutterColor, radix: 16);
  }

  ColorCustom(final String flutterColor)
      : super(_getColorFromHex(flutterColor));
}

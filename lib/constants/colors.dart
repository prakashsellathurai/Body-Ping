import 'package:flutter/material.dart';
Color base_color = Color(0xFF41B4BC);
Color complementary_color = Color(0xFFBC4941);
Color secondary_color = Color(0xFF41BC87);
Color tertiary_color = Color(0xFF4177bc);

Color base_color_monochrome_1 = Color(0xFFFFFFFF);
Color base_color_monochrome_2 = Color(0xFFFFFFFF);
Color base_color_monochrome_3 = Color(0xFFFFFFFF);
Color base_color_monochrome_4 = Color(0xFFf2F3F8);
Color background = Color(0xFFF2F3F8);
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
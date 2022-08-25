import 'package:flutter/material.dart';

class CoreColor {
  // static Color primary = Color(0xFF52c234);
  static Color primary = Colors.deepPurple;
  static Color primarySoft = Color(0xFF695DDC);
  static Color primaryExtraSoft = Color(0xFF018749);
  static Color secondary = Color(0xFF061700);
  static Color whiteSoft = Color(0xFFF8F8F8);
  static Color kTextColor = Color(0xFF757575);
  static Color kHintTextColor = Color(0xFFBB9B9B9);

  static LinearGradient linearGradient = LinearGradient(
      colors: [Color(0xFFA4508B), Color(0xFF5F0A87)],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft);
  static LinearGradient linearGradientEnd = LinearGradient(
      colors: [Colors.red, Colors.red, Color(0xFF83489e)],
      end: Alignment.topRight,
      begin: Alignment.bottomLeft);

  static LinearGradient bottomShadowShoft = LinearGradient(colors: [
    Color(0xFF107873).withOpacity(0.2),
    Color(0xFF107873).withOpacity(0.2)
  ], begin: Alignment.bottomCenter, end: Alignment.topCenter);
  static LinearGradient linearBlackBottom = LinearGradient(
      colors: [Colors.black.withOpacity(0.45), Colors.black.withOpacity(0)],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter);
  static LinearGradient linearBlackTop = LinearGradient(
      colors: [Colors.black.withOpacity(0.5), Colors.transparent],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}

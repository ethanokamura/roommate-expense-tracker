// dart packages
import 'package:flutter/material.dart';

// defines custom colors for the app
abstract class CustomColors {
  // universal accent
  static const Color lightAccent = Color(0xff357b95);

  static const List<Color> dangerLevelColors = [
    Color(0xff3CC480),
    Color(0xffefb90a),
    Color(0xfff24b49),
  ];

  static const List<Color> chartColors = [
    Color(0xff3CC480),
    Color(0xff64D0A2),
    Color(0xff8CDCC4),
    Color(0xffB4E8E6),
    Color(0xffDCF4F8),
  ];

  // light mode
  static const Color lightBackground = Color(0xfffdfdfa);
  static const Color lightSurface = Color(0xfff5f5f5);
  static const Color lightPrimary = Color(0xffe5e8ea);
  static const Color lightSecondary = Color(0xfffada7a);
  static const Color lightTextColor = Color(0xff46494b);
  static const Color lightSubtextColor = Color(0xff7f8b90);
  static const Color lightHintTextColor = Color(0xff8f8f8f);
  static const Color inverseLightTextColor = Color(0xfdfdfdfa);
  static const Color lightError = Color(0xfff24b49);
  static const Color lightOnError = Color(0xff46494b);
}

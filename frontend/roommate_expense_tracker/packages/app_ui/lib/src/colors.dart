// dart packages
import 'package:flutter/material.dart';

// defines custom colors for the app
abstract class CustomColors {
  static const List<Color> chartColors = [
    Color(0xff32ba76),
    Color(0xff3CC480),
    Color(0xff64D0A2),
    Color(0xff8CDCC4),
    Color(0xffB4E8E6),
    Color(0xffbbeddb),
  ];
  // universal accent
  static const Color accent = Color(0xff57b6bd);
  static const Color lightAccent = Color(0xff58c7d1);
  static const Color success = Color(0xff3CC480);
  static const Color error = Color(0xfff24b49);

  // dark mode
  static const Color darkBackground = Color(0xff141b1d);
  static const Color darkSurface = Color(0xff172124);
  static const Color darkPrimary = Color(0xff1a2529);
  static const Color darkTextColor = Color(0xffe1e6f0);
  static const Color darkSubtextColor = Color(0xff969eb0);
  static const Color darkHintTextColor = Color(0xff666e7d);
  static const Color inverseDarkTextColor = Color(0xff151b24);

  // light mode
  static const Color lightBackground = Color(0xfff5f5f5);
  static const Color lightSurface = Color(0xffe5e8ea);
  static const Color lightPrimary = Color(0xfffdfdfa);
  static const Color lightTextColor = Color(0xff46494b);
  static const Color lightSubtextColor = Color(0xff7f8b90);
  static const Color lightHintTextColor = Color(0xff8f8f8f);
  static const Color inverseLightTextColor = Color(0xff46494b);
}

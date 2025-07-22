// dart packages
import 'package:flutter/material.dart';

// defines custom colors for the app
abstract class CustomColors {
  static const List<Color> chartColors = [
    Color(0xff57b6bd),
    Color(0xff2a9d8f),
    Color(0xff8ab17d),
    Color(0xffe9c46a),
    Color(0xfff4a261),
    Color(0xffe76f51),
  ];
  // universal accent
  static const Color accent = Color(0xff57b6bd);
  static const Color lightAccent = Color(0xff47a5ad);
  static const Color success = Color(0xff3CC480);
  static const Color error = Color(0xfff24b49);

  // dark mode
  static const Color darkBackground = Color(0xff10141a);
  static const Color darkSurface = Color(0xff151b24);
  static const Color darkPrimary = Color(0xff1d2530);
  static const Color darkTextColor = Color(0xffe1e6f0);
  static const Color darkSubtextColor = Color(0xff969eb0);
  static const Color darkHintTextColor = Color(0xff666e7d);
  static const Color inverseDarkTextColor = Color(0xff151b24);

  // light mode
  static const Color lightBackground = Color(0xfff2f2f2);
  static const Color lightSurface = Color(0xffe5e8ea);
  static const Color lightPrimary = Color(0xfffdfdfa);
  static const Color lightTextColor = Color(0xff46494b);
  static const Color lightSubtextColor = Color(0xff7f8b90);
  static const Color lightHintTextColor = Color(0xff8f8f8f);
  static const Color inverseLightTextColor = Color(0xff46494b);
}

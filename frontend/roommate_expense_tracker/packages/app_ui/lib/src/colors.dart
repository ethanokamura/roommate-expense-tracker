// dart packages
import 'package:flutter/material.dart';

// defines custom colors for the app
abstract class CustomColors {
  // universal accent
  static const Color accent = Color(0xff59B3BC);
  static const Color lightAccent = Color(0xff58c7d1);

  // dark mode
  static const Color darkBackground = Color(0xff10151a);
  static const Color darkSurface = Color(0xff161c21);
  static const Color darkPrimary = Color(0xff1e272e);
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

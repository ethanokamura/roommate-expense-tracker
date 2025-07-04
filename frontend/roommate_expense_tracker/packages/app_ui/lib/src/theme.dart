import 'package:app_ui/src/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// create custom themes that adapt to user brightness mode
extension CustomThemeData on ThemeData {
  /// [accentColor]
  /// Gives the signature look to the app
  Color get accentColor => brightness == Brightness.dark
      ? CustomColors.accent
      : CustomColors.lightAccent;

  /// [backgroundColor]
  /// Used for scaffolds
  /// the main background color for the app
  Color get backgroundColor => brightness == Brightness.dark
      ? CustomColors.darkBackground
      : CustomColors.lightBackground;

  /// [surfaceColor]
  /// The main color of all widgets on the page
  /// Most common color in the app
  Color get surfaceColor => brightness == Brightness.dark
      ? CustomColors.darkSurface
      : CustomColors.lightSurface;

  /// [primaryColor]
  /// Sits on top of surface colored containers / widgets
  /// Secondary surface
  Color get primaryColor => brightness == Brightness.dark
      ? CustomColors.darkPrimary
      : CustomColors.lightPrimary;

  /// [textColor]
  /// Default text color for the app
  Color get textColor => brightness == Brightness.dark
      ? CustomColors.darkTextColor
      : CustomColors.lightTextColor;

  /// [subtextColor]
  /// Secondary text color. ie used for descriptions
  Color get subtextColor => brightness == Brightness.dark
      ? CustomColors.darkSubtextColor
      : CustomColors.lightSubtextColor;

  /// [hintTextColor]
  /// Tertiary color for text. rarely used
  Color get hintTextColor => brightness == Brightness.dark
      ? CustomColors.darkSubtextColor
      : CustomColors.lightSubtextColor;

  /// [inverseTextColor]
  /// Used on backgrounds with the accent color
  Color get inverseTextColor => brightness == Brightness.dark
      ? CustomColors.inverseDarkTextColor
      : CustomColors.inverseLightTextColor;
}

// Dark Mode
ThemeData darkMode = ThemeData(
  // brightness mode
  brightness: Brightness.dark,

  // default font
  fontFamily: GoogleFonts.rubik().fontFamily,

  // app background color
  scaffoldBackgroundColor: CustomColors.darkBackground,

  // misc colors
  shadowColor: Colors.black,

  // custom color scheme
  colorScheme: const ColorScheme.dark(
    surface: CustomColors.darkSurface,
    onSurface: CustomColors.darkTextColor,
    primary: CustomColors.darkPrimary,
    onPrimary: CustomColors.darkTextColor,
  ),
);

// Light Mode
ThemeData lightMode = ThemeData(
  // brightness mode
  brightness: Brightness.light,

  // default font
  fontFamily: GoogleFonts.rubik().fontFamily,

  // app background color
  scaffoldBackgroundColor: CustomColors.lightBackground,

  // default shadow color
  shadowColor: Colors.black,

  // custom color scheme
  colorScheme: const ColorScheme.light(
    surface: CustomColors.lightSurface,
    onSurface: CustomColors.lightTextColor,
    primary: CustomColors.lightPrimary,
    onPrimary: CustomColors.lightTextColor,
  ),
);

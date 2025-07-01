import 'package:app_ui/src/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// create custom themes that adapt to user brightness mode
extension CustomThemeData on ThemeData {
  /// [accentColor]
  /// Gives the signature look to the app
  Color get accentColor => CustomColors.lightAccent;

  /// [backgroundColor]
  /// Used for scaffolds
  /// the main background color for the app
  Color get backgroundColor => CustomColors.lightBackground;

  /// [surfaceColor]
  /// The main color of all widgets on the page
  /// Most common color in the app
  Color get surfaceColor => CustomColors.lightSurface;

  /// [primaryColor]
  /// Sits on top of surface colored containers / widgets
  /// Secondary surface
  Color get primaryColor => CustomColors.lightPrimary;

  /// [secondaryColor]
  /// Sits on top of surface colored containers / widgets
  /// Secondary surface
  Color get secondaryColor => CustomColors.lightSecondary;

  /// [textColor]
  /// Default text color for the app
  Color get textColor => CustomColors.lightTextColor;

  /// [subtextColor]
  /// Secondary text color. ie used for descriptions
  Color get subtextColor => CustomColors.lightSubtextColor;

  /// [hintTextColor]
  /// Tertiary color for text. rarely used
  Color get hintTextColor => CustomColors.lightSubtextColor;

  /// [inverseTextColor]
  /// Used on backgrounds with the accent color
  Color get inverseTextColor => CustomColors.inverseLightTextColor;

  /// [dangerLevelColors]
  /// Used on to handle different danger levels
  List<Color> get dangerLevelColors => CustomColors.dangerLevelColors;

  /// [chartColors]
  /// Used on to handle different danger levels
  List<Color> get chartColors => CustomColors.chartColors;
}

// Light Mode
ThemeData theme = ThemeData(
  // brightness mode
  brightness: Brightness.light,

  // default font
  fontFamily: GoogleFonts.montserrat().fontFamily,

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
    secondary: CustomColors.lightSecondary,
    onSecondary: CustomColors.inverseLightTextColor,
    error: CustomColors.lightError,
    onError: CustomColors.lightOnError,
  ),
);

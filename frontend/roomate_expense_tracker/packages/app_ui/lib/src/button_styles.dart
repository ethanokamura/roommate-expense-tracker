import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:flutter/material.dart';

ButtonStyle defaultStyle(BuildContext context, int color) {
  List<Color> colors = [
    context.theme.surfaceColor,
    context.theme.primaryColor,
    context.theme.accentColor,
    context.theme.secondaryColor,
  ];
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: defaultPadding,
      vertical: 0,
    ),
    elevation: defaultElevation,
    backgroundColor: colors[color],
    shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  );
}

ButtonStyle textFormButtonStyle(BuildContext context, int color) {
  List<Color> colors = [
    context.theme.surfaceColor,
    context.theme.primaryColor,
    context.theme.accentColor,
    context.theme.secondaryColor,
  ];
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: defaultPadding,
      vertical: 0,
    ),
    elevation: defaultElevation,
    backgroundColor: colors[color],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(defaultRadius),
        bottomRight: Radius.circular(defaultRadius),
      ),
    ),
  );
}

ButtonStyle iconButtonStyle() {
  return IconButton.styleFrom(
    padding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

import 'package:app_ui/src/constants.dart';
import 'package:flutter/material.dart';

ButtonStyle defaultStyle(BuildContext context, Color color) {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: defaultPadding,
      vertical: 0,
    ),
    elevation: defaultElevation,
    backgroundColor: color,
    shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  );
}

ButtonStyle textFormButtonStyle(BuildContext context, Color color) {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: defaultPadding,
      vertical: 0,
    ),
    elevation: defaultElevation,
    backgroundColor: color,
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

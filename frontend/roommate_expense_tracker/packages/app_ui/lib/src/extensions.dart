import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  void popUntil(RoutePredicate predicate) =>
      Navigator.of(this).popUntil(predicate);

  void showSnackBar(String text) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: theme.surfaceColor,
          content: CustomText(
            text: text,
            style: AppTextStyles.primary,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<T?> showScrollControlledBottomSheet<T>({
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: builder,
      backgroundColor: theme.backgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    );
  }
}

// Custom Clipper to clip only the top
class TopClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
}

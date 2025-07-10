import 'package:app_ui/src/app_ui.dart';
import 'package:app_ui/src/constants.dart';
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
          content: Text(text),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<T?> showScrollControlledBottomSheet<T>({
    required WidgetBuilder builder,
    required BuildContext context,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: builder,
      backgroundColor: context.theme.backgroundColor,
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

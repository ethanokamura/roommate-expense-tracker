import 'package:animations/animations.dart';
import 'package:app_ui/src/constants.dart';
import 'package:flutter/material.dart';

Route<dynamic> fadeThroughTransition(Widget page, {int duration = 500}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration(milliseconds: duration),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      );
    },
  );
}

class TransitionContainer extends StatelessWidget {
  const TransitionContainer({
    required this.page,
    required this.child,
    this.color,
    super.key,
  });

  final Widget page;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (BuildContext context, VoidCallback _) {
        return page;
      },
      closedElevation: defaultElevation,
      closedColor: color ?? Colors.white,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: child,
        );
      },
    );
  }
}

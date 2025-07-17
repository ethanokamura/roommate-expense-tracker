import 'package:animations/animations.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/theme.dart';
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
    super.key,
  });

  final Widget page;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (BuildContext context, VoidCallback _) {
        return page;
      },
      closedElevation: defaultElevation,
      openColor: context.theme.backgroundColor,
      closedColor: context.theme.backgroundColor,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: child,
        );
      },
    );
  }
}

class FloatingActionTransitionContainer extends StatelessWidget {
  const FloatingActionTransitionContainer({
    required this.page,
    required this.icon,
    super.key,
  });

  final Widget page;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 500),
      openBuilder: (BuildContext context, VoidCallback _) {
        return page;
      },
      closedElevation: 5,
      closedShape: const RoundedRectangleBorder(
        borderRadius: defaultBorderRadius,
      ),
      openColor: context.theme.backgroundColor,
      closedColor: context.theme.accentColor,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
          height: 48,
          width: 48,
          child: Center(
            child: icon,
          ),
        );
      },
    );
  }
}

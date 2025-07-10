import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Icon defaultIconStyle(
  BuildContext context,
  IconData icon,
  Color color, {
  double size = 14,
}) {
  return Icon(
    icon,
    color: color,
    size: size,
  );
}

Icon appBarIconStyle(BuildContext context, IconData icon, {double size = 24}) {
  return Icon(
    icon,
    color: context.theme.textColor,
    size: size,
  );
}

Icon inverseIconStyle(BuildContext context, IconData icon, {double size = 14}) {
  return Icon(
    icon,
    color: context.theme.inverseTextColor,
    size: size,
  );
}

class AppIcons {
  // buttons
  static const IconData logOut = FontAwesomeIcons.arrowRightFromBracket;
  static const IconData settings = FontAwesomeIcons.gear;
  static const IconData send = FontAwesomeIcons.paperPlane;
  static const IconData calendar = FontAwesomeIcons.calendar;
  static const IconData downTrend = FontAwesomeIcons.arrowTrendDown;
  static const IconData contract = FontAwesomeIcons.fileContract;
  static const IconData user = FontAwesomeIcons.solidCircleUser;
  static const IconData notificationBell = FontAwesomeIcons.bell;

  static const IconData money = FontAwesomeIcons.moneyBillTransfer;
  static const IconData sort = Icons.sort_sharp;
  static const IconData letters = FontAwesomeIcons.a;
  static const IconData link = FontAwesomeIcons.link;
  static const IconData cancel = FontAwesomeIcons.xmark;
  static const IconData confirm = FontAwesomeIcons.check;
  static const IconData copy = FontAwesomeIcons.copy;
  static const IconData house = FontAwesomeIcons.house;
  static const IconData darkMode = FontAwesomeIcons.moon;
  static const IconData lightMode = FontAwesomeIcons.sun;
  static const IconData add = Icons.add;

  /// APP ICONS
  static const IconData groceries = Icons.fastfood_outlined;
  static const IconData rent = FontAwesomeIcons.houseUser;
  static const IconData utilities = FontAwesomeIcons.wrench;
  static const IconData toiletries = FontAwesomeIcons.toiletPaper;
  static const IconData random = FontAwesomeIcons.dice;
  static const IconData food = Icons.restaurant;
}

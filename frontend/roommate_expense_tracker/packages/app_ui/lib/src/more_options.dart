import 'package:app_core/app_core.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/icons.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/widgets.dart';
import 'package:flutter/material.dart';

/// A data model for each dropDown item.
/// This encapsulates all the necessary information for a single dropDown option.
class DropDownItem {
  const DropDownItem({
    required this.icon,
    required this.text,
    required this.onSelect,
    this.value,
  });

  final IconData icon;
  final String text;
  final Future<void> Function() onSelect;
  final dynamic value;
}

/// Action button for the UI
/// Accent colored background
/// Requires [dropDownItems] to define the dynamic list of dropDowns
/// Optionally changes background color with [onSurface]
class DropDown extends StatelessWidget {
  const DropDown({
    required this.dropDownItems,
    this.onSurface = false,
    super.key,
  });

  final bool onSurface;
  final List<DropDownItem> dropDownItems;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      // Change type to int for index, or dynamic if you use DropDownItem directly
      offset: const Offset(0, 40),
      color: onSurface
          ? context.theme.backgroundColor
          : context.theme.surfaceColor,
      icon: defaultIconStyle(
        context,
        AppIcons.sort,
        onSurface ? context.theme.textColor : context.theme.subtextColor,
        size: 18,
      ),
      itemBuilder: (BuildContext context) {
        return dropDownItems.asMap().entries.map((entry) {
          final int index = entry.key;
          final DropDownItem item = entry.value;
          return _dropDownItem(context, item, index);
        }).toList();
      },
      onSelected: (selectedIndex) async {
        if (selectedIndex >= 0 && selectedIndex < dropDownItems.length) {
          await dropDownItems[selectedIndex].onSelect();
        }
      },
    );
  }

  /// Generic menu item
  /// Requires [context] for build context
  /// Requires a [DropDownItem] to hold data
  /// Requires [index] to identify the selected item
  PopupMenuItem<int> _dropDownItem(
    BuildContext context,
    DropDownItem item,
    int index,
  ) {
    return PopupMenuItem<int>(
      value: index,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          defaultIconStyle(context, item.icon, context.theme.textColor),
          const HorizontalSpacer(),
          CustomText(
            style: AppTextStyles.primary,
            text: item.text.toTitleCase,
            autoSize: false,
          ),
        ],
      ),
    );
  }
}

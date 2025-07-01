import 'dart:async';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/text.dart';
import 'package:flutter/material.dart';

/// Custom container widget
/// Requires [child] widget to display inside the container
/// Optional padding using [horizontal] and [vertical]
class DefaultContainer extends StatelessWidget {
  const DefaultContainer({
    required this.child,
    this.accent,
    this.horizontal,
    this.vertical,
    super.key,
  });

  final bool? accent;
  final double? horizontal;
  final double? vertical;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: accent == null || !accent!
          ? context.theme.colorScheme.surface
          : context.theme.accentColor,
      borderRadius: defaultBorderRadius,
      elevation: defaultElevation,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal == null ? 15 : horizontal!,
          vertical: vertical == null ? 10 : vertical!,
        ),
        child: child,
      ),
    );
  }
}

/// Custom page widget
/// Requires [body] content to display inside the page
class DefaultPageView extends StatelessWidget {
  const DefaultPageView({
    required this.body,
    this.centerTitle,
    this.drawer,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.title = '',
    this.actions = const [],
    this.fontSize = 24,
    super.key,
  });
  final Widget body;
  final String title;
  final bool? centerTitle;
  final List<Widget> actions;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    final appBar =
        title.isNotEmpty || actions.isNotEmpty || centerTitle != null;
    return Scaffold(
      appBar: appBar
          ? AppBar(
              centerTitle: centerTitle,
              backgroundColor: context.theme.accentColor,
              title: title.isNotEmpty
                  ? CustomText(
                      style: AppTextStyles.appBar,
                      color: 3,
                      text: title,
                      fontSize: fontSize,
                    )
                  : null,
              actions: actions.isEmpty ? null : actions,
              iconTheme: IconThemeData(
                color: context.theme.inverseTextColor,
                size: 28,
              ),
            )
          : null,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxScreenWidth),
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

/// Customer vertical spacer with default spacing
class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer({this.multiple, super.key});
  final double? multiple;
  @override
  Widget build(BuildContext context) {
    return multiple != null
        ? SizedBox(height: defaultSpacing * multiple!)
        : const SizedBox(height: defaultSpacing);
  }
}

/// Customer horizontal spacer with default spacing
class HorizontalSpacer extends StatelessWidget {
  const HorizontalSpacer({this.multiple, super.key});
  final double? multiple;

  @override
  Widget build(BuildContext context) {
    return multiple != null
        ? SizedBox(width: defaultSpacing * multiple!)
        : const SizedBox(width: defaultSpacing);
  }
}

class VerticalBar extends StatelessWidget {
  const VerticalBar({this.multiple = 1, super.key});
  final double multiple;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpacer(multiple: multiple / 2),
        Divider(
          color: context.theme.subtextColor,
          thickness: 0.5,
          indent: 10,
          endIndent: 10,
        ),
        VerticalSpacer(multiple: multiple / 2),
      ],
    );
  }
}

class PageLoader extends StatefulWidget {
  const PageLoader({
    required this.duration,
    required this.child,
    super.key,
  });

  final int duration;
  final Widget Function(bool loaded) child;

  @override
  State<PageLoader> createState() => _PageLoaderState();
}

class _PageLoaderState extends State<PageLoader> {
  bool loaded = false;

  @override
  void initState() {
    Timer(Duration(milliseconds: widget.duration), _delayedDataLoad);
    super.initState();
  }

  void _delayedDataLoad() {
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(loaded);
  }
}

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(text: label, style: AppTextStyles.secondary, fontSize: 14),
        CustomText(text: value, style: AppTextStyles.primary),
      ],
    );
  }
}

class KeyValueGrid extends StatelessWidget {
  const KeyValueGrid({
    required this.items,
    this.multiple = 0.5,
    super.key,
  });
  final Map<String, String> items;
  final double multiple;

  @override
  Widget build(BuildContext context) {
    final nonEmptyItems =
        items.values.where((value) => value.isNotEmpty).length;
    return SizedBox(
      height: nonEmptyItems * 20 + (multiple * defaultSpacing) * nonEmptyItems,
      child: ListView.separated(
        itemCount: items.length,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => VerticalSpacer(
          multiple: multiple,
        ),
        itemBuilder: (context, index) =>
            items[items.keys.toList()[index]] == null ||
                    items[items.keys.toList()[index]]!.isEmpty
                ? const SizedBox.shrink()
                : KeyValueRow(
                    label: items.keys.toList()[index],
                    value: items[items.keys.toList()[index]]!,
                  ),
      ),
    );
  }
}

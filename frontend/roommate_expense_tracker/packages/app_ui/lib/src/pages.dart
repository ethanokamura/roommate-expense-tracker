import 'package:app_ui/src/app_ui.dart';
import 'package:flutter/material.dart';

class ModularPageBuilder extends StatelessWidget {
  const ModularPageBuilder({
    required this.sectionsData,
    this.title = '',
    super.key,
  });

  final String title;
  final Map<String, List<Widget>> sectionsData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) ...[
              const VerticalSpacer(multiple: 2),
              CustomText(
                text: title,
                style: AppTextStyles.appBar,
                fontSize: 32,
                maxLines: 3,
              ),
              const VerticalSpacer(),
            ],
            ...List.generate(sectionsData.length, (index) {
              final key = sectionsData.keys.toList()[index];
              final String title = key;
              final List<Widget> children = sectionsData[key]!;
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Section(
                    title: title,
                    multiple: 0.5,
                    children: children,
                  ),
                  if (index < sectionsData.length - 1)
                    const VerticalBar(multiple: 2),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  const Section({
    required this.title,
    required this.children,
    this.multiple = 1.0,
    super.key,
  });

  final String title;
  final double multiple;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          style: AppTextStyles.appBar,
          maxLines: 3,
          color: context.theme.accentColor,
        ),
        ..._addSpacingToChildren(children, multiple),
      ],
    );
  }

  List<Widget> _addSpacingToChildren(List<Widget> children, double multiple) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(VerticalSpacer(multiple: multiple));
      }
    }
    return spacedChildren;
  }
}

// You'll still need a 'SliverSection' to handle the title and its children as slivers
class SliverSectionForNested extends StatelessWidget {
  const SliverSectionForNested({
    required this.title,
    required this.children,
    this.multiple = 1.0,
    super.key,
  });

  final String title;
  final double multiple;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsetsGeometry.symmetric(horizontal: defaultPadding),
            child: CustomText(
              text: title,
              style: AppTextStyles.title,
              color: context.theme.accentColor,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: VerticalSpacer(),
        ),
        SliverPadding(
          padding:
              const EdgeInsetsGeometry.symmetric(horizontal: defaultPadding),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              _addSpacingToChildren(children, multiple),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _addSpacingToChildren(List<Widget> children, double multiple) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(VerticalSpacer(multiple: multiple));
      }
    }
    return spacedChildren;
  }
}

class NestedPageBuilder extends StatelessWidget {
  const NestedPageBuilder({
    required this.sectionsData,
    required this.itemBuilder,
    required this.itemCount,
    required this.isLoading,
    required this.emptyMessage,
    this.filter,
    this.title = '',
    super.key,
  });

  final String title;
  final Map<String, List<Widget>> sectionsData;
  final Widget? filter;
  final String emptyMessage;
  final bool isLoading;
  final int itemCount;
  final Widget? Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        List<Widget> headerSlivers = [
          const SliverToBoxAdapter(child: VerticalSpacer()),
          if (title.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(
                  horizontal: defaultPadding,
                ),
                child: CustomText(
                  text: title,
                  style: AppTextStyles.appBar,
                  maxLines: 2,
                  fontSize: 28,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: VerticalBar()),
          ]
        ];

        for (int i = 0; i < sectionsData.length; i++) {
          final key = sectionsData.keys.toList()[i];
          final String title = key;
          final List<Widget> children = sectionsData[key]!;

          if (children.isEmpty) {
            headerSlivers.add(
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsetsGeometry.symmetric(
                    horizontal: defaultPadding,
                  ),
                  child: CustomText(
                    text: title,
                    style: AppTextStyles.title,
                    color: context.theme.accentColor,
                  ),
                ),
              ),
            );
          } else {
            headerSlivers.add(
              SliverSectionForNested(
                title: title,
                children: children,
              ),
            );
          }
          if (i < sectionsData.length - 1) {
            headerSlivers
                .add(const SliverToBoxAdapter(child: VerticalBar(multiple: 2)));
          } else {
            headerSlivers.addAll([
              const SliverToBoxAdapter(child: VerticalSpacer(multiple: 1)),
              const SliverToBoxAdapter(child: VerticalBar()),
            ]);
          }
        }

        if (filter != null) {
          headerSlivers.addAll([
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                  horizontal: defaultPadding),
              child: filter!,
            )),
            const SliverToBoxAdapter(child: VerticalSpacer()),
          ]);
        }
        return headerSlivers;
      },
      body: Expanded(
        child: isLoading
            ? const SkeletonList(lines: 7)
            : itemCount == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                    ),
                    child: CustomText(
                      text: emptyMessage,
                      style: AppTextStyles.secondary,
                    ),
                  )
                : CustomListView(
                    itemBuilder: itemBuilder,
                    itemCount: itemCount,
                  ),
      ),
    );
  }
}

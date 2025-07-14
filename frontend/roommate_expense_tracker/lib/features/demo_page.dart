import 'package:app_ui/app_ui.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: DemoPage());

  @override
  Widget build(BuildContext context) {
    return DefaultPageView(
      title: 'Demo Page',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalBar(),
              CustomText(
                text: 'Text Styles',
                style: AppTextStyles.appBar,
                color: context.theme.accentColor,
              ),
              const CustomText(
                text: 'style: AppTextStyles.appBar',
                style: AppTextStyles.appBar,
              ),
              const CustomText(
                text: 'style: AppTextStyles.title',
                style: AppTextStyles.title,
              ),
              const CustomText(
                text: 'style: AppTextStyles.primary',
                style: AppTextStyles.primary,
              ),
              const CustomText(
                text: 'style: AppTextStyles.secondary',
                style: AppTextStyles.secondary,
              ),
              const VerticalBar(),
              CustomText(
                text: 'Colors',
                style: AppTextStyles.appBar,
                color: context.theme.accentColor,
              ),
              CustomText(
                text: 'color: context.theme.accentColor',
                style: AppTextStyles.primary,
                color: context.theme.accentColor,
              ),
              CustomText(
                text: 'color: context.theme.textColor',
                style: AppTextStyles.primary,
                color: context.theme.textColor,
              ),
              CustomText(
                text: 'color: context.theme.subtextColor',
                style: AppTextStyles.primary,
                color: context.theme.subtextColor,
              ),
              const VerticalSpacer(),
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: context.theme.surfaceColor,
                  borderRadius: defaultBorderRadius,
                ),
                child: const CustomText(
                  text: 'color: context.theme.surfaceColor',
                  style: AppTextStyles.primary,
                ),
              ),
              const VerticalSpacer(),
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: defaultBorderRadius,
                ),
                child: const CustomText(
                  text: 'color: context.theme.primaryColor',
                  style: AppTextStyles.primary,
                ),
              ),
              const VerticalSpacer(),
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: context.theme.backgroundColor,
                  borderRadius: defaultBorderRadius,
                ),
                child: const CustomText(
                  text: 'color: context.theme.backgroundColor',
                  style: AppTextStyles.primary,
                ),
              ),
              const VerticalBar(),
              CustomText(
                text: 'Containers',
                style: AppTextStyles.appBar,
                color: context.theme.accentColor,
              ),
              const DefaultContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Default Container',
                      style: AppTextStyles.primary,
                    ),
                    VerticalSpacer(),
                    CustomText(
                      text:
                          'Default container is a wrapper widget for a "Card" like design. It requires a child widget (of any type).',
                      style: AppTextStyles.secondary,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              const VerticalSpacer(),
              Row(
                children: [
                  CustomTag(
                    text: 'Custom Tag',
                    color: context.theme.accentColor,
                  ),
                  const HorizontalSpacer(),
                  CustomTag(
                    text: 'Custom Tag',
                    color: context.theme.primaryColor,
                  ),
                  const HorizontalSpacer(),
                  CustomTag(
                    text: 'Custom Tag',
                    color: context.theme.surfaceColor,
                  ),
                ],
              ),
              const VerticalBar(),
              CustomText(
                text: 'Buttons',
                style: AppTextStyles.appBar,
                color: context.theme.accentColor,
              ),
              CustomButton(
                text: 'Custom Button',
                onTap: () {},
              ),
              const CustomButton(
                text: 'Inactive Custom Button',
                onTap: null,
              ),
              CustomButton(
                text: 'Custom Button',
                onTap: () {},
                color: context.theme.accentColor,
              ),
              const VerticalBar(),
              const CustomText(
                text: 'SkeletonRows(lines: 3),',
                style: AppTextStyles.primary,
              ),
              const VerticalSpacer(),
              const SkeletonRows(lines: 3),
              const VerticalSpacer(),
              const CustomText(
                text: 'SkeletonRows(lines: 3, hasTitle: false),',
                style: AppTextStyles.primary,
              ),
              const VerticalSpacer(),
              const SkeletonRows(lines: 3, hasTitle: false),
              const VerticalSpacer(),
              const CustomText(
                text: 'SkeletonCard(lines: 3),',
                style: AppTextStyles.primary,
              ),
              const VerticalSpacer(),
              const SkeletonCard(lines: 3),
              const VerticalBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'DropDown()',
                    style: AppTextStyles.title,
                  ),
                  DropDown(dropDownItems: [
                    DropDownItem(
                      icon: AppIcons.person,
                      text: 'DropDownItem() #1',
                      onSelect: () async {},
                    ),
                    DropDownItem(
                      icon: AppIcons.person,
                      text: 'DropDownItem() #2',
                      onSelect: () async {},
                    ),
                    DropDownItem(
                      icon: AppIcons.person,
                      text: 'DropDownItem() #3',
                      onSelect: () async {},
                    ),
                  ]),
                ],
              ),
              const VerticalBar(),
              customTextFormField(
                context: context,
                label: 'customTextFormField()',
                controller: TextEditingController(),
                onBackground: true,
              ),
              const VerticalSpacer(multiple: 6),
            ],
          ),
        ),
      ),
    );
  }
}

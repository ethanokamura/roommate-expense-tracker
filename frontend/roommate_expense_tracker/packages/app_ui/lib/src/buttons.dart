import 'package:app_ui/app_ui.dart';

/// Default button for the UI
/// Requires [onTap] function to handle the tap event
/// [icon] AppIcon to display
/// [text] Text to display
/// [color] Defines the color of the button within the range [0,3]
/// [horizontal] / [vertical] Provides optional padding
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onTap,
    this.fontSize,
    this.color,
    this.icon,
    this.text,
    this.vertical,
    this.horizontal,
    super.key,
  });

  final Color? color;
  final double? fontSize;
  final IconData? icon;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: defaultStyle(context, color ?? context.theme.surfaceColor),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              defaultIconStyle(
                context,
                icon!,
                color != context.theme.accentColor
                    ? context.theme.textColor
                    : context.theme.backgroundColor,
                size: 16,
              ),
            if (text != null && icon != null) const SizedBox(width: 5),
            if (text != null)
              CustomText(
                style: AppTextStyles.button,
                color: color != context.theme.accentColor
                color: color != context.theme.accentColor
                    ? context.theme.textColor
                    : context.theme.backgroundColor,
                fontSize: fontSize,
                text: text!,
                autoSize: false,
              ),
          ],
        ),
      ),
    );
  }
}

/// Icon button for the app bar
/// Requires [onTap] function to handle the tap event
/// Requires an [icon] for UI
class AppBarButton extends StatelessWidget {
  const AppBarButton({
    required this.icon,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: appBarIconStyle(context, icon),
    );
  }
}

/// Default text button for the UI
/// Requires [onTap] function to handle the tap event
/// [text] Text to display
/// [horizontal] / [vertical] Provides optional padding
class DefaultTextButton extends StatelessWidget {
  const DefaultTextButton({
    required this.onTap,
    required this.text,
    this.vertical,
    this.horizontal,
    super.key,
  });

  final String text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: CustomText(
          style: AppTextStyles.button,
          text: text,
          autoSize: false,
        ),
      ),
    );
  }
}

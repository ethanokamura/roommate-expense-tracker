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

  final int? color;
  final double? fontSize;
  final IconData? icon;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = [
      0,
      1,
      3,
      0,
    ];
    return ElevatedButton(
      onPressed: onTap,
      style: defaultStyle(context, color ?? 0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              defaultIconStyle(context, icon!, colors[color ?? 0], size: 16),
            if (text != null && icon != null) const SizedBox(width: 5),
            if (text != null)
              CustomText(
                style: AppTextStyles.button,
                color: colors[color ?? 0],
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

/// Button to confirm text input
/// Requires [onTap] function to handle the tap event
/// [icon] AppIcon to display
/// [color] Defines the color of the button within the range [0,3]
/// [horizontal] / [vertical] Provides optional padding
class ConfirmTextField extends StatelessWidget {
  const ConfirmTextField({
    required this.onTap,
    required this.icon,
    this.color,
    this.vertical,
    this.horizontal,
    super.key,
  });

  final int? color;
  final IconData icon;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = [
      1,
      1,
      3,
      0,
    ];
    return ElevatedButton(
      onPressed: onTap,
      style: textFormButtonStyle(context, color ?? 0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            defaultIconStyle(context, icon, colors[onTap != null ? 2 : 0]),
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

/// Default button for the UI
/// Requires [onTap] function to handle the tap event
/// [text] Text to display
/// [selected] Updates the button colors to indicate if the drawer item is selected
/// [horizontal] / [vertical] Provides optional padding
class DefaultDrawerButton extends StatelessWidget {
  const DefaultDrawerButton({
    required this.onTap,
    required this.text,
    required this.selected,
    this.vertical,
    this.horizontal,
    super.key,
  });

  final String text;
  final bool selected;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: CustomText(
          style: AppTextStyles.primary,
          text: text,
          color: selected ? 4 : 0,
        ),
      ),
    );
  }
}

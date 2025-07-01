import 'package:app_ui/app_ui.dart';

InputDecoration defaultTextFormFieldDecoration({
  required BuildContext context,
  required String label,
  String? hintText,
  bool? onBackground,
  String? prefix,
}) =>
    InputDecoration(
      filled: true,
      fillColor: onBackground != null && onBackground
          ? context.theme.surfaceColor
          : context.theme.backgroundColor,
      prefixText: prefix,
      prefixStyle: AppTextStyles.primary,
      hintText: hintText,
      hintStyle: AppTextStyles.secondary,
      hintMaxLines: 1,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      labelStyle: AppTextStyles.primary,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultRadius),
          bottomLeft: Radius.circular(defaultRadius),
        ),
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultRadius),
          bottomLeft: Radius.circular(defaultRadius),
        ),
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      label: Text(label),
    );

TextFormField customTextFormField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  bool? onBackground,
  bool autofocus = false,
  String? prefix,
  int? maxLength,
  TextInputType? keyboardType,
  bool obscureText = false,
  String? hintText,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
}) =>
    TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      minLines: 1,
      maxLines: obscureText ? 1 : 5,
      maxLength: maxLength,
      cursorColor: context.theme.hintTextColor,
      autofocus: autofocus,
      style: const TextStyle(fontSize: 16),
      decoration: defaultTextFormFieldDecoration(
        onBackground: onBackground,
        context: context,
        hintText: hintText,
        label: label,
        prefix: prefix,
      ),
    );

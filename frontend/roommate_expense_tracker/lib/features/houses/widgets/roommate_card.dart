import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';

class RoommateCard extends StatelessWidget {
  const RoommateCard({
    required this.profilePicture,
    required this.name,
    required this.paymentMethod,
    required this.paymentLink,
    super.key,
  });

  final Widget profilePicture;
  final String name;
  final String paymentMethod;
  final String paymentLink;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Row(
        children: [
          profilePicture,
          const HorizontalSpacer(
            multiple: 1.5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  style: AppTextStyles.primary,
                ),
                Row(
                  children: [
                    const CustomText(
                      text: "Pref. Payment Method: ",
                      style: AppTextStyles.primary,
                    ),
                    Expanded(
                      child: CustomText(
                        text: paymentMethod,
                        style: AppTextStyles.primary,
                        color: (paymentMethod != "NOT SET")
                            ? context.theme.textColor
                            : context.theme.errorColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const CustomText(
                      text: "Link: ",
                      style: AppTextStyles.primary,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (paymentMethod != "NOT SET" &&
                              paymentLink != "NOT SET") {
                            Clipboard.setData(ClipboardData(text: paymentLink));
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Copied To Dashboard")));
                          }
                        },
                        child: CustomText(
                          text: paymentLink,
                          style: AppTextStyles.primary,
                          color: (paymentLink != "NOT SET")
                              ? context.theme.accentColor
                              : context.theme.errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

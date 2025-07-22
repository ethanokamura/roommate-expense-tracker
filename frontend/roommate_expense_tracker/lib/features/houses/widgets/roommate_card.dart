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
                      text: "Payment Method: ",
                      style: AppTextStyles.primary,
                    ),
                    Expanded(
                      child: CustomText(
                        text: (paymentMethod == '') ? "NOT SET" : paymentMethod,
                        style: AppTextStyles.primary,
                        color: (paymentMethod != '')
                            ? context.theme.accentColor
                            : context.theme.errorColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const CustomText(
                      text: "Payment Info: ",
                      style: AppTextStyles.primary,
                    ),
                    Expanded(
                      child: CustomText(
                        text: (paymentLink == "") ? "NOT SET" : paymentLink,
                        style: AppTextStyles.primary,
                        color: (paymentLink != "")
                            ? context.theme.accentColor
                            : context.theme.errorColor,
                      ),
                    ),
                    if (paymentLink != "")
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: paymentLink));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Copied To Dashboard")));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(1), // Small padding
                          child: Icon(
                            Icons.copy,
                            size: 12,
                            color: CustomColors.lightPrimary,
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

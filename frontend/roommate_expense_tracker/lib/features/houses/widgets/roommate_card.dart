import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';

class RoommateCard extends StatelessWidget {
  const RoommateCard({
    required this.profilePicture,
    required this.name,
    required this.paymentMethod,
    required this.paymentLink,
    required this.isLoading,
    super.key,
  });

  final Widget profilePicture;
  final String name;
  final String paymentMethod;
  final String paymentLink;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SkeletonProfileCard(lines: 3)
        : DefaultContainer(
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
                          const HorizontalSpacer(),
                          Flexible(
                            child: CustomText(
                              text:
                                  (paymentMethod == '') ? "N/A" : paymentMethod,
                              style: AppTextStyles.primary,
                              color: (paymentMethod != '')
                                  ? context.theme.accentColor
                                  : context.theme.subtextColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                const CustomText(
                                  text: "Payment Info: ",
                                  style: AppTextStyles.primary,
                                ),
                                const HorizontalSpacer(),
                                Flexible(
                                  child: CustomText(
                                    text: (paymentLink == "")
                                        ? "N/A"
                                        : paymentLink,
                                    style: AppTextStyles.primary,
                                    color: (paymentLink != "")
                                        ? context.theme.accentColor
                                        : context.theme.subtextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (paymentLink != "") ...[
                            const HorizontalSpacer(),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: paymentLink));
                                context.showSnackBar("Copied To Dashboard");
                              },
                              child: defaultIconStyle(
                                context,
                                Icons.copy,
                                context.theme.textColor,
                                size: 16,
                              ),
                            ),
                          ],
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

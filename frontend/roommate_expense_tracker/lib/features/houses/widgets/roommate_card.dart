import 'package:app_ui/app_ui.dart';

class RoommateCard extends StatelessWidget {
  const RoommateCard({
    required this.profilePicture,
    required this.name,
    this.paymentMethod,
    this.paymentMethodId,
    super.key,
  });

  final Widget profilePicture;
  final String name;
  final String? paymentMethod;
  final String? paymentMethodId;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Row(
        children: [
          profilePicture,
          const HorizontalSpacer(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CustomText(text: name, style: AppTextStyles.primary),
                      if (paymentMethod != null)
                        CustomText(
                          text: paymentMethod!,
                          style: AppTextStyles.primary,
                        ),
                      if (paymentMethod != null && paymentMethodId != null)
                        CustomText(
                          text: paymentMethodId!,
                          style: AppTextStyles.primary,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

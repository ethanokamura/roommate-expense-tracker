import 'package:app_ui/app_ui.dart';

class HouseDashboard extends StatelessWidget {
  const HouseDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomText(
        text: 'House Dashboard',
        style: AppTextStyles.title,
      ),
    );
  }
}

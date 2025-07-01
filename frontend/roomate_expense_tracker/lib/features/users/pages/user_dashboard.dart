import 'package:app_ui/app_ui.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Center(
          child: CustomText(
            text: 'User Dashboard',
            style: AppTextStyles.title,
          ),
        )
      ],
    );
  }
}

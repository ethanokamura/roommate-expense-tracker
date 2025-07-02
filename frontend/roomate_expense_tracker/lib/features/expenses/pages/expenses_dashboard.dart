import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:users_repository/users_repository.dart';

class ExpensesDashboard extends StatelessWidget {
  const ExpensesDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomText(
            text: 'Expenses Dashboard',
            style: AppTextStyles.title,
          ),
          CustomText(
            text:
                'Welcome back, ${context.read<UsersRepository>().currentUser!.email}',
            style: AppTextStyles.secondary,
          ),
        ],
      ),
    );
  }
}

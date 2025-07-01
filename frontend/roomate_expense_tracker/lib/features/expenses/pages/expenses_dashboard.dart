import 'package:app_ui/app_ui.dart';

class ExpensesDashboard extends StatelessWidget {
  const ExpensesDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomText(
        text: 'Expenses Dashboard',
        style: AppTextStyles.title,
      ),
    );
  }
}

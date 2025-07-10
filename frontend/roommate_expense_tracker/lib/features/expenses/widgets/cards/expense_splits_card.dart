import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';

class ExpenseSplitsCard extends StatelessWidget {
  const ExpenseSplitsCard({required this.split, super.key});
  final ExpenseSplit split;
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Column(
        children: [
          CustomText(
            text: split.userId,
            style: AppTextStyles.primary,
          ),
          CustomText(
            text: formatCurrency(split.amountOwed),
            style: AppTextStyles.primary,
          ),
          CustomText(
            text: split.paidOn != null
                ? DateFormatter.formatTimestamp(split.paidOn!)
                : 'Expense has not been paid.',
            style: AppTextStyles.secondary,
          ),
        ],
      ),
    );
  }
}

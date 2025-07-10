import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/cards/expense_splits_card.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({
    required this.expense,
    required this.splits,
    super.key,
  });
  static MaterialPage<dynamic> page({
    required Expenses expense,
    required List<ExpenseSplit> splits,
  }) =>
      MaterialPage<void>(
        child: ExpensePage(
          expense: expense,
          splits: splits,
        ),
      );
  final Expenses expense;
  final List<ExpenseSplit> splits;
  @override
  Widget build(BuildContext context) {
    return DefaultPageView(
      title: 'Expenses Page',
      body: Column(
        children: [
          CustomText(
            text: expense.title,
            style: AppTextStyles.primary,
          ),
          CustomText(
            text: expense.description,
            style: AppTextStyles.primary,
          ),
          CustomText(
            text: expense.category,
            style: AppTextStyles.primary,
          ),
          CustomText(
            text: formatCurrency(expense.totalAmount),
            style: AppTextStyles.primary,
          ),
          CustomText(
            text: expense.isSettled.toString(),
            style: AppTextStyles.primary,
          ),
          Column(
            children: List.generate(
              splits.length,
              (index) => ExpenseSplitsCard(split: splits[index]),
            ),
          )
        ],
      ),
    );
  }
}

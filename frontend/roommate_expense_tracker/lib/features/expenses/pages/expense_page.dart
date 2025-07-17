import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/widgets.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpacer(multiple: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: expense.title,
                  style: AppTextStyles.appBar,
                ),
                CustomTag(
                  text: '#${expense.category}',
                  color: context.theme.accentColor,
                ),
              ],
            ),
            CustomText(
              text: expense.description,
              style: AppTextStyles.secondary,
            ),
            const VerticalBar(),
            CustomText(
              text: formatCurrency(expense.totalAmount),
              style: AppTextStyles.title,
            ),
            CustomText(
              text: expense.isSettled ? 'Paid' : 'Unpaid',
              style: AppTextStyles.primary,
              color: expense.isSettled
                  ? context.theme.successColor
                  : context.theme.errorColor,
            ),
            Column(
              children: List.generate(
                splits.length,
                (index) => ExpenseSplitsCard(
                  split: splits[index],
                  paid: expense.isSettled,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

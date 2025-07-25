import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/page_data/page_data.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    required this.expense,
    super.key,
  });

  final Expenses expense;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Row(
        children: [
          defaultIconStyle(
            context,
            categoryData[expense.category.toLowerCase()] ??
                categoryData.values.first,
            context.theme.textColor,
            size: 24,
          ),
          const HorizontalSpacer(multiple: 1.5),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: expense.title,
                        style: AppTextStyles.primary,
                      ),
                      CustomText(
                        text: expense.description,
                        style: AppTextStyles.secondary,
                      ),
                    ],
                  ),
                ),
                const HorizontalSpacer(multiple: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: formatCurrency(expense.totalAmount),
                      style: AppTextStyles.primary,
                      color: expense.isSettled
                          ? context.theme.accentColor
                          : context.theme.errorColor,
                    ),
                    CustomText(
                      text: DateFormatter.formatTimestamp(
                        expense.createdAt ?? DateTime.now(),
                      ),
                      style: AppTextStyles.secondary,
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

import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/widgets.dart';
import 'package:roommate_expense_tracker/features/expenses/page_data/page_data.dart';

Future<dynamic> expensePopUp({
  required BuildContext context,
  required Expenses expense,
  required List<ExpenseSplit> splits,
}) async {
  await context.showScrollControlledBottomSheet<void>(
    builder: (context) => Padding(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: defaultPadding * 2,
              left: defaultPadding * 2,
              right: defaultPadding * 2,
              bottom: 60,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    defaultIconStyle(
                      context,
                      categoryData[expense.category]!,
                      context.theme.textColor,
                      size: 30,
                    ),
                    const HorizontalSpacer(multiple: 2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: expense.title,
                          style: AppTextStyles.appBar,
                        ),
                        CustomText(
                          text: expense.description,
                          style: AppTextStyles.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
                const VerticalBar(),
                KeyValueGrid(
                  items: {
                    'Category': expense.category.toTitleCase,
                    'Total': formatCurrency(expense.totalAmount),
                    'Created On':
                        DateFormatter.formatTimestamp(expense.createdAt!),
                    'Splits': (expense.splits.length + 1).toString(),
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: 'Status',
                      style: AppTextStyles.primary,
                    ),
                    CustomText(
                      text: expense.isSettled ? 'Paid' : 'Unpaid',
                      style: AppTextStyles.primary,
                      color: expense.isSettled
                          ? context.theme.successColor
                          : context.theme.errorColor,
                    ),
                  ],
                ),
                const VerticalBar(),
                Column(
                  children: List.generate(
                    splits.length,
                    (index) => Stack(children: [
                      ExpenseSplitsCard(
                        split: splits[index],
                        paid: expense.isSettled,
                      ),
                    ]),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/widgets.dart';
import 'package:roommate_expense_tracker/features/expenses/page_data/page_data.dart';
import 'package:users_repository/users_repository.dart';

Future<dynamic> expensePopUp({
  required BuildContext context,
  required Expenses expense,
  required List<ExpenseSplit> splits,
  required List<HouseMembers> members,
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
                      categoryData[expense.category.toLowerCase()] ??
                          categoryData.values.first,
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
                    'Created By': members
                        .firstWhere(
                            (el) => el.houseMemberId == expense.houseMemberId)
                        .nickname,
                    'Category': expense.category.toTitleCase,
                    'Total': formatCurrency(expense.totalAmount),
                    'Created On': DateFormatter.formatTimestamp(
                      expense.createdAt ?? DateTime.now(),
                    ),
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
                if (expense.houseMemberId ==
                        context.read<UsersRepository>().getMemberId &&
                    expense.isSettled == false) ...[
                  const VerticalSpacer(),
                  CustomButton(
                    text: 'Mark as resolved',
                    onTap: () async {
                      final List<Map<String, dynamic>> splitData =
                          splits.map((split) => split.toJson()).toList();
                      for (Map<String, dynamic> split in splitData) {
                        split['paid_on'] = DateTime.now().toIso8601String();
                      }
                      final newExpenseData = Expenses.fromJson({
                        ...expense.toJson(),
                        Expenses.isSettledConverter: true,
                        Expenses.settledAtConverter: DateTime.now(),
                        Expenses.splitsConverter: {"member_splits": splitData},
                      });
                      debugPrint(
                          'marking expense as resolved:${expense.expenseId}');
                      await context.read<ExpensesRepository>().updateExpenses(
                            expenseId: expense.expenseId ?? '',
                            newExpensesData: newExpenseData,
                            token:
                                context.read<UsersRepository>().idToken ?? '',
                          );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    color: context.theme.accentColor,
                  ),
                ],
                const VerticalBar(),
                if (splits.isNotEmpty)
                  const CustomText(
                    text: 'No Splits.',
                    style: AppTextStyles.secondary,
                  )
                else
                  Column(
                    children: List.generate(
                      splits.length,
                      (index) => ExpenseSplitsCard(
                        nickname: members
                            .firstWhere((el) =>
                                el.houseMemberId == splits[index].memberId)
                            .nickname,
                        split: splits[index],
                        paid: expense.isSettled,
                      ),
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

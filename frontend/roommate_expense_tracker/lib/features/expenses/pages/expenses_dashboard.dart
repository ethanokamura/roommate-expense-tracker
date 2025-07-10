import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/expenses.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/category_data.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/expense_cubit_wrapper.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/expense_popup.dart';
import 'package:users_repository/users_repository.dart';

class ExpensesDashboard extends StatelessWidget {
  const ExpensesDashboard({
    required this.houseId,
    super.key,
  });

  final String houseId;
  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    return BlocProvider(
      create: (context) => ExpensesCubit(
        expensesRepository: context.read<ExpensesRepository>(),
      )..fetchAllExpensesWithHouseId(
          houseId: houseId, // requires house ID
          token: userRepository.credentials.credential!.accessToken ?? '',
          orderBy: Users.createdAtConverter,
          ascending: false,
        ),
      child: ExpensesCubitWrapper(
        builder: (context, state) {
          debugPrint(state.status.toString());
          List<double> values = [12.3, 70, 50.4, 45, 90, 21, 47];
          final total = values.reduce((value, element) => value += element);
          final average = total / values.length;

          return NestedPageBuilder(
            title: 'Expense Dashboard',
            sectionsData: {
              'My Expenses': [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DefaultContainer(
                      child: Column(
                        children: [
                          const CustomText(
                            text: 'Daily Average',
                            style: AppTextStyles.primary,
                          ),
                          CustomText(
                            text: formatCurrency(average),
                            style: AppTextStyles.primary,
                            color: context.theme.subtextColor,
                          ),
                        ],
                      ),
                    ),
                    DefaultContainer(
                      child: Column(
                        children: [
                          const CustomText(
                            text: 'Lowest Day',
                            style: AppTextStyles.primary,
                          ),
                          CustomText(
                            text: formatCurrency(12.3),
                            style: AppTextStyles.primary,
                            color: context.theme.successColor,
                          ),
                        ],
                      ),
                    ),
                    DefaultContainer(
                      child: Column(
                        children: [
                          const CustomText(
                            text: 'Highest Day',
                            style: AppTextStyles.primary,
                          ),
                          CustomText(
                            text: formatCurrency(90),
                            style: AppTextStyles.primary,
                            color: context.theme.errorColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                LargeCustomLineChart(
                  title: 'Expenses This Week',
                  unit: formatCurrency(total),
                  values: values,
                  dataType: ChartDataType.isCurrency,
                )
              ],
              'Cost Analysis': const [
                Center(
                  child: CustomPieChart(title: 'Expense Distribution', data: {
                    "groceries": 304.37,
                    "rent": 1000,
                    "utilities": 200,
                    "toiletries": 56.4,
                    "food": 79.35,
                    "random": 103.34,
                  }),
                )
              ],
            },
            itemCount: state.expensesList.length,
            itemBuilder: (context, index) {
              final expense = state.expensesList[index];
              final splits = context
                  .read<ExpensesRepository>()
                  .extractSplits(expense.splits);
              debugPrint('Found ${splits.length} splits');
              return GestureDetector(
                onTap: () async => expensePopUp(
                  context: context,
                  expense: expense,
                  splits: splits,
                ),
                child: ExpenseCard(
                  expense: expense,
                  splits: splits,
                ),
              );
            },
            isLoading: state.isLoading,
            filter: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Expense List',
                  style: AppTextStyles.title,
                  color: context.theme.accentColor,
                ),
                DropDown(dropDownItems: [
                  DropDownItem(
                    icon: AppIcons.money,
                    text: 'Total Amount',
                    onSelect: () async {},
                  ),
                  DropDownItem(
                    icon: AppIcons.calendar,
                    text: 'Created At',
                    onSelect: () async {},
                  ),
                  DropDownItem(
                    icon: AppIcons.calendar,
                    text: 'Updated At',
                    onSelect: () async {},
                  ),
                  DropDownItem(
                    icon: AppIcons.calendar,
                    text: 'Settled At',
                    onSelect: () async {},
                  ),
                  DropDownItem(
                    icon: AppIcons.calendar,
                    text: 'Due Date',
                    onSelect: () async {},
                  ),
                ])
              ],
            ),
            emptyMessage: 'No expenses have been posted',
          );
        },
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    required this.expense,
    required this.splits,
    super.key,
  });

  final Expenses expense;
  final List<ExpenseSplit> splits;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Row(
        children: [
          defaultIconStyle(
            context,
            categoryData[expense.category]!,
            context.theme.textColor,
            size: 24,
          ),
          const HorizontalSpacer(multiple: 1.5),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: '-${formatCurrency(expense.totalAmount)}',
                      style: AppTextStyles.primary,
                      color: context.theme.accentColor,
                    ),
                    CustomText(
                      text: expense.createdAt,
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

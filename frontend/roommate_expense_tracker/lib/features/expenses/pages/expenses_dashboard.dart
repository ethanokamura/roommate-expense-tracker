import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/cubit/expenses_cubit.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/widgets.dart';
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
          houseId: houseId,
          token: userRepository.idToken ?? '',
          orderBy: Users.createdAtConverter,
          ascending: false,
          forceRefresh: false,
        ),
      child: ExpensesCubitWrapper(
        builder: (context, state) {
          List<double> values = [12.3, 70, 50.4, 45, 90, 21, 47];
          final total = values.reduce((value, element) => value += element);
          final average = total / values.length;
          return NestedPageBuilder(
            title: 'Expense Dashboard',
            sectionsData: {
              'Cost Analysis': [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 3 -
                          (defaultPadding * 2),
                      child: DefaultContainer(
                        child: Column(
                          children: [
                            const CustomText(
                              autoSize: true,
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
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 3 -
                          (defaultPadding * 2),
                      child: DefaultContainer(
                        child: Column(
                          children: [
                            const CustomText(
                              autoSize: true,
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
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 3 -
                          (defaultPadding * 2),
                      child: DefaultContainer(
                        child: Column(
                          children: [
                            const CustomText(
                              autoSize: true,
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
              'Expense Distribution': const [
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
                    onSelect: () async => context
                        .read<ExpensesCubit>()
                        .fetchAllExpensesWithHouseId(
                          houseId: houseId,
                          token: userRepository.idToken ?? '',
                          orderBy: Expenses.totalAmountConverter,
                          ascending: false,
                          forceRefresh: false,
                        ),
                  ),
                  DropDownItem(
                    icon: AppIcons.calendar,
                    text: 'Created At',
                    onSelect: () async => context
                        .read<ExpensesCubit>()
                        .fetchAllExpensesWithHouseId(
                          houseId: houseId,
                          token: userRepository.idToken ?? '',
                          orderBy: Expenses.createdAtConverter,
                          ascending: false,
                          forceRefresh: false,
                        ),
                  ),
                  DropDownItem(
                    icon: AppIcons.calendar,
                    text: 'Updated At',
                    onSelect: () async => context
                        .read<ExpensesCubit>()
                        .fetchAllExpensesWithHouseId(
                          houseId: houseId,
                          token: userRepository.idToken ?? '',
                          orderBy: Expenses.updatedAtConverter,
                          ascending: false,
                          forceRefresh: false,
                        ),
                  ),
                  DropDownItem(
                    icon: AppIcons.calendar,
                    text: 'Due Date',
                    onSelect: () async => context
                        .read<ExpensesCubit>()
                        .fetchAllExpensesWithHouseId(
                          houseId: houseId,
                          token: userRepository.idToken ?? '',
                          orderBy: Expenses.expenseDateConverter,
                          ascending: false,
                          forceRefresh: false,
                        ),
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

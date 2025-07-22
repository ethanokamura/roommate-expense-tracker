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
      )
        ..fetchAllExpensesWithHouseId(
          houseId: houseId,
          token: userRepository.idToken ?? '',
          orderBy: Users.createdAtConverter,
          ascending: false,
          forceRefresh: true,
        )
        ..fetchWeeklyExpenses(
          key: Expenses.houseIdConverter,
          value: houseId,
          token: userRepository.idToken ?? '',
        )
        ..fetchWeeklyExpenseCategories(
          key: Expenses.houseIdConverter,
          value: houseId,
          token: userRepository.idToken ?? '',
          forceRefresh: true,
        ),
      child: ExpensesCubitWrapper(
        builder: (context, state) {
          final values = _formatResponse(state.weeklyExpenses);
          final total = totalExpenses(state.weeklyExpenses);
          final min = minExpenses(state.weeklyExpenses);
          final max = maxExpenses(state.weeklyExpenses);

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
                              text: formatCurrency(total / 7),
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
                              text: formatCurrency(min),
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
                              text: formatCurrency(max),
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
                  values: values.isEmpty
                      ? [0, 0, 0, 0, 0, 0, 0]
                      : values.values.toList(),
                  // titles: values.isEmpty
                  //     ? days
                  //     : values.keys
                  //         .map(
                  //           (key) => (days[
                  //               (DateTime.tryParse(key.toString())?.toUtc() ??
                  //                           DateTime.now().toUtc())
                  //                       .weekday -
                  //                   1]),
                  //         )
                  //         .toList(),
                  dataType: ChartDataType.isCurrency,
                ),
                // ExpensesChart(
                //   field: Expenses.houseIdConverter,
                //   value: houseId,
                //   token: userRepository.idToken ?? '',
                // )
              ],
              'Expense Distribution': [
                Center(
                  child: state.expenseCategories.isEmpty
                      ? const SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : CustomPieChart(
                          title: 'Expense Distribution',
                          data:
                              _formatCategoryResponse(state.expenseCategories),
                        ),
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
                          forceRefresh: true,
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
                          forceRefresh: true,
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
                          forceRefresh: true,
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
                          forceRefresh: true,
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

Map<String, double> _formatResponse(List<Map<String, dynamic>> response) {
  Map<String, double> values = {};
  for (int i = 0; i < response.length; i++) {
    values[response[i]["day"].toString()] =
        double.tryParse(response[i]["total"].toString()) ?? 0.0;
  }
  return values;
}

Map<String, double> _formatCategoryResponse(
  List<Map<String, dynamic>> response,
) {
  Map<String, double> values = {};
  for (int i = 0; i < response.length; i++) {
    values[response[i]["category"].toString()] =
        double.tryParse(response[i]["total"].toString()) ?? 0.0;
  }
  return values;
}

double maxExpenses(List<Map<String, dynamic>> data) => data.isEmpty
    ? 0.0
    : data.map((map) => double.tryParse(map['total']) ?? 0.0).reduce(
        (currentMax, element) => element > currentMax ? element : currentMax);

double minExpenses(List<Map<String, dynamic>> data) => data.isEmpty
    ? 0.0
    : data.map((map) => double.tryParse(map['total']) ?? 0.0).reduce(
        (currentMin, element) => element < currentMin ? element : currentMin);

double totalExpenses(List<Map<String, dynamic>> data) => data.isEmpty
    ? 0.0
    : data
        .map((map) => double.tryParse(map['total']) ?? 0.0)
        .reduce((sum, element) => sum + element);

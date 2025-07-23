import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/cubit/expenses_cubit.dart';
import 'package:roommate_expense_tracker/features/expenses/pages/expense_manager.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/cards/total_expenses.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/widgets.dart';
import 'package:roommate_expense_tracker/features/users/users.dart';
import 'package:users_repository/users_repository.dart';

class ExpensesDashboard extends StatelessWidget {
  const ExpensesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpensesCubit>(
          create: (context) => ExpensesCubit(
            expensesRepository: context.read<ExpensesRepository>(),
          )
            ..fetchMyExpenses(
              houseMemberId: userRepository.getMemberId,
              houseId: userRepository.getHouseId,
              token: userRepository.idToken ?? '',
              forceRefresh: true,
            )
            ..fetchWeeklyExpenses(
              key: Expenses.houseIdConverter,
              value: userRepository.getHouseId,
              token: userRepository.idToken ?? '',
            )
            ..fetchWeeklyExpenseCategories(
              key: Expenses.houseIdConverter,
              value: userRepository.getHouseId,
              token: userRepository.idToken ?? '',
            ),
        ),
        BlocProvider<UsersCubit>(
          create: (context) =>
              UsersCubit(usersRepository: context.read<UsersRepository>())
                ..fetchAllHouseMembersWithHouseId(
                  houseId: userRepository.getHouseId,
                  token: userRepository.idToken ?? '',
                  orderBy: HouseMembers.createdAtConverter,
                  ascending: false,
                ),
        )
      ],
      child: Builder(
        builder: (context) {
          final expenseState = context.watch<ExpensesCubit>().state;
          final userState = context.watch<UsersCubit>().state;
          final values = _formatResponse(expenseState.weeklyExpenses);
          final total = totalExpenses(expenseState.weeklyExpenses);
          final min = minExpenses(expenseState.weeklyExpenses);
          final max = maxExpenses(expenseState.weeklyExpenses);

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
                  dataType: ChartDataType.isCurrency,
                ),
                const MyTotalExpenses(),
                const TransitionContainer(
                  page: ExpenseManager(),
                  child: DefaultContainer(
                    child: CustomText(
                      text: 'View My Expenses',
                      style: AppTextStyles.primary,
                    ),
                  ),
                )
              ],
              'Expense Distribution': [
                Center(
                  child: expenseState.expenseCategories.isEmpty
                      ? const SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : CustomPieChart(
                          title: 'Expense Distribution',
                          data: _formatCategoryResponse(
                              expenseState.expenseCategories),
                        ),
                )
              ],
            },
            itemCount: expenseState.expensesList.length,
            itemBuilder: (context, index) {
              final expense = expenseState.expensesList[index];
              final splits = context
                  .read<ExpensesRepository>()
                  .extractSplits(expense.splits);
              return GestureDetector(
                onTap: () async => expensePopUp(
                  context: context,
                  expense: expense,
                  splits: splits,
                  members: userState.houseMembersList,
                ),
                child: ExpenseCard(
                  expense: expense,
                ),
              );
            },
            isLoading: expenseState.isLoading,
            filter: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'My Expenses',
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
                          houseId: userRepository.getHouseId,
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
                          houseId: userRepository.getHouseId,
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
                          houseId: userRepository.getHouseId,
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
                          houseId: userRepository.getHouseId,
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

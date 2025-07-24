import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/cubit/expenses_cubit.dart';
import 'package:roommate_expense_tracker/features/expenses/pages/expense_manager.dart';
import 'package:roommate_expense_tracker/features/expenses/pages/my_expenses_page.dart';
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
              houseMemberId: userRepository.getMemberId,
              houseId: userRepository.getHouseId,
              token: userRepository.idToken ?? '',
              forceRefresh: true,
            )
            ..fetchWeeklyExpenseCategories(
              houseMemberId: userRepository.getMemberId,
              houseId: userRepository.getHouseId,
              token: userRepository.idToken ?? '',
              forceRefresh: true,
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
          final min = expenseState.weeklyExpenses.length < 6
              ? 0.0
              : minExpenses(expenseState.weeklyExpenses);
          final max = maxExpenses(expenseState.weeklyExpenses);

          return ModularPageBuilder(
            title: 'Expense Dashboard',
            sectionsData: {
              'Cost Analysis - Last 7 Days': [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: formatCurrency(min),
                                  style: AppTextStyles.primary,
                                  color: context.theme.successColor,
                                ),
                                const HorizontalSpacer(multiple: 0.5),
                                defaultIconStyle(
                                  context,
                                  AppIcons.downTrend,
                                  context.theme.successColor,
                                ),
                              ],
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: formatCurrency(max),
                                  style: AppTextStyles.primary,
                                  color: context.theme.errorColor,
                                ),
                                const HorizontalSpacer(multiple: 0.5),
                                defaultIconStyle(
                                  context,
                                  AppIcons.upTrend,
                                  context.theme.errorColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                LargeCustomLineChart(
                  title: 'My Expenses',
                  unit: formatCurrency(total),
                  values: values.isEmpty
                      ? [0, 0, 0, 0, 0, 0, 0]
                      : values.values.toList(),
                  dataType: ChartDataType.isCurrency,
                ),
                expenseState.expenseCategories.isEmpty
                    ? const CustomText(
                        text: 'No Expenses Yet.',
                        style: AppTextStyles.secondary,
                      )
                    : DefaultContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(
                              text: 'Expense Distribution',
                              style: AppTextStyles.primary,
                            ),
                            const VerticalSpacer(),
                            Center(
                              child: CustomPieChart(
                                title: 'Expense Distribution',
                                data: _formatCategoryResponse(
                                    expenseState.expenseCategories),
                              ),
                            ),
                          ],
                        ),
                      ),
                const VerticalSpacer(),
              ],
              "Expenses I Am Owed:": [
                DefaultContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Total:',
                        style: AppTextStyles.primary,
                        color: context.theme.textColor,
                      ),
                      CustomText(
                        text: formatCurrency(0),
                        style: AppTextStyles.primary,
                        color: context.theme.successColor,
                      ),
                    ],
                  ),
                ),
                TransitionContainer(
                  page: const ExpenseManager(),
                  child: DefaultContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: 'View Expenses',
                          style: AppTextStyles.primary,
                        ),
                        defaultIconStyle(
                          context,
                          AppIcons.goTo,
                          context.theme.textColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              "Expenses I Owe:": [
                DefaultContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Total:',
                        style: AppTextStyles.primary,
                        color: context.theme.textColor,
                      ),
                      const MyTotalExpenses(),
                    ],
                  ),
                ),
                TransitionContainer(
                  page: const ExpensesOwedPage(),
                  child: DefaultContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CustomText(
                          text: 'View Expenses',
                          style: AppTextStyles.primary,
                        ),
                        defaultIconStyle(
                          context,
                          AppIcons.goTo,
                          context.theme.textColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            },
          );
        },
      ),
    );
  }
}

Map<String, double> _formatResponse(List<Map<String, dynamic>> response) {
  Map<String, double> values = {};
  for (int i = 5; i >= 0; i--) {
    DateTime date = today.subtract(Duration(days: i));
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    values[formattedDate] = 0.0;
  }

  for (int i = 0; i < response.length; i++) {
    String responseDayRaw = response[i]["day"].toString();
    String responseDay = responseDayRaw.split('T')[0];
    double total = double.tryParse(response[i]["total"].toString()) ?? 0.0;
    values[responseDay] = total;
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

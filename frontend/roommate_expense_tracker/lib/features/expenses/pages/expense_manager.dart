import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/cubit/expenses_cubit.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/widgets.dart';
import 'package:roommate_expense_tracker/features/users/users.dart';
import 'package:users_repository/users_repository.dart';

class ExpenseManager extends StatelessWidget {
  const ExpenseManager({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    return DefaultPageView(
      title: 'Manage Expenses',
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ExpensesCubit>(
            create: (context) => ExpensesCubit(
              expensesRepository: context.read<ExpensesRepository>(),
            )..fetchAllExpensesWithHouseMemberId(
                houseId: userRepository.getHouseId,
                houseMemberId: userRepository.getMemberId,
                token: userRepository.idToken ?? '',
                orderBy: Expenses.createdAtConverter,
                ascending: true,
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

            return NestedPageBuilder(
              sectionsData: {},
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
                  child: Row(
                    children: [
                      Expanded(
                        child: ExpenseCard(
                          expense: expense,
                        ),
                      ),
                      const HorizontalSpacer(),
                      GestureDetector(
                        // Use GestureDetector for better tap control
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding / 1.5),
                          decoration: BoxDecoration(
                            color: context.theme.accentColor,
                            borderRadius: defaultBorderRadius,
                          ),
                          child: defaultIconStyle(
                            context,
                            AppIcons.confirm,
                            context.theme.backgroundColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
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
                          .fetchAllExpensesWithHouseMemberId(
                            houseId: userRepository.getHouseId,
                            houseMemberId: userRepository.getMemberId,
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
                          .fetchAllExpensesWithHouseMemberId(
                            houseId: userRepository.getHouseId,
                            houseMemberId: userRepository.getMemberId,
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
                          .fetchAllExpensesWithHouseMemberId(
                            houseId: userRepository.getHouseId,
                            houseMemberId: userRepository.getMemberId,
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
                          .fetchAllExpensesWithHouseMemberId(
                            houseId: userRepository.getHouseId,
                            houseMemberId: userRepository.getMemberId,
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
      ),
    );
  }
}

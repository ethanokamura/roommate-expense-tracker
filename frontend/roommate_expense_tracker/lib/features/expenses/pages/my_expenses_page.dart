import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/cubit/expenses_cubit.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/widgets.dart';
import 'package:roommate_expense_tracker/features/users/users.dart';
import 'package:users_repository/users_repository.dart';

class ExpensesOwedPage extends StatelessWidget {
  const ExpensesOwedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    return DefaultPageView(
      title: 'Expenses I Owe',
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ExpensesCubit>(
            create: (context) => ExpensesCubit(
              expensesRepository: context.read<ExpensesRepository>(),
            )..fetchMyExpenses(
                houseId: userRepository.getHouseId,
                houseMemberId: userRepository.getMemberId,
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
                      onSelect: () async =>
                          context.read<ExpensesCubit>().fetchMyExpenses(
                                houseId: userRepository.getHouseId,
                                houseMemberId: userRepository.getMemberId,
                                token: userRepository.idToken ?? '',
                                forceRefresh: true,
                              ),
                    ),
                    DropDownItem(
                      icon: AppIcons.calendar,
                      text: 'Created At',
                      onSelect: () async =>
                          context.read<ExpensesCubit>().fetchMyExpenses(
                                houseId: userRepository.getHouseId,
                                houseMemberId: userRepository.getMemberId,
                                token: userRepository.idToken ?? '',
                                forceRefresh: true,
                              ),
                    ),
                    DropDownItem(
                      icon: AppIcons.calendar,
                      text: 'Updated At',
                      onSelect: () async =>
                          context.read<ExpensesCubit>().fetchMyExpenses(
                                houseId: userRepository.getHouseId,
                                houseMemberId: userRepository.getMemberId,
                                token: userRepository.idToken ?? '',
                                forceRefresh: true,
                              ),
                    ),
                    DropDownItem(
                      icon: AppIcons.calendar,
                      text: 'Due Date',
                      onSelect: () async =>
                          context.read<ExpensesCubit>().fetchMyExpenses(
                                houseId: userRepository.getHouseId,
                                houseMemberId: userRepository.getMemberId,
                                token: userRepository.idToken ?? '',
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

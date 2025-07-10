import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:roommate_expense_tracker/features/expenses/expenses.dart';
import 'package:roommate_expense_tracker/features/expenses/pages/expense_page.dart';
import 'package:roommate_expense_tracker/features/expenses/widgets/expense_cubit_wrapper.dart';
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
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomText(
                  text: 'Expenses Dashboard',
                  style: AppTextStyles.title,
                ),
                CustomText(
                  text:
                      'Welcome back, ${context.read<UsersRepository>().currentUser!.email}',
                  style: AppTextStyles.secondary,
                ),
                state.isLoading
                    ? const SkeletonList(lines: 5)
                    : state.expensesList.isEmpty
                        ? const CustomText(
                            text: 'No expenses have been posted',
                            style: AppTextStyles.secondary,
                          )
                        : CustomListView(
                            itemCount: state.expensesList.length,
                            itemBuilder: (context, index) {
                              final expense = state.expensesList[index];
                              final splits = context
                                  .read<ExpensesRepository>()
                                  .extractSplits(expense.splits);
                              return TransitionContainer(
                                page: ExpensePage(
                                    expense: expense, splits: splits),
                                child: DefaultContainer(
                                  child: Column(
                                    children: [
                                      CustomText(
                                        text: expense.title,
                                        style: AppTextStyles.primary,
                                      ),
                                      CustomText(
                                        text:
                                            formatCurrency(expense.totalAmount),
                                        style: AppTextStyles.primary,
                                      ),
                                      CustomText(
                                        text: 'Splits: ${splits.length}',
                                        style: AppTextStyles.primary,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ],
            ),
          );
        },
      ),
    );
  }
}

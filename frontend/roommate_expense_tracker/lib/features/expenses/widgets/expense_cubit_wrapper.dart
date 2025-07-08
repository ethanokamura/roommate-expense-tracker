import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/features/expenses/expenses.dart';
import 'package:roommate_expense_tracker/features/failures/expenses_failures.dart';

class ExpensesCubitWrapper extends StatelessWidget {
  const ExpensesCubitWrapper({
    required this.builder,
    super.key,
  });
  final Widget Function(BuildContext context, ExpensesState state) builder;

  @override
  Widget build(BuildContext context) {
    return listenForExpensesFailures<ExpensesCubit, ExpensesState>(
      failureSelector: (state) => state.failure,
      isFailureSelector: (state) => state.isFailure,
      child: BlocBuilder<ExpensesCubit, ExpensesState>(
        builder: builder,
      ),
    );
  }
}

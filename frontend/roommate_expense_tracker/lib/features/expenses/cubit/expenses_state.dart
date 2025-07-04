part of 'expenses_cubit.dart';

/// Represents the different states a post can be in.
enum ExpensesStatus {
  initial,
  loading,
  loaded,
  failure,
}

/// Represents the state of post-related operations.
final class ExpensesState extends Equatable {
  /// Private constructor for creating [ExpensesState] instances.
  const ExpensesState._({
    this.status = ExpensesStatus.initial,
    this.expenses = Expenses.empty,
    this.expensesList = const [],
    this.expenseSpits = ExpenseSpits.empty,
    this.expenseSpitsList = const [],
    this.recurringExpenses = RecurringExpenses.empty,
    this.recurringExpensesList = const [],
    this.receipts = Receipts.empty,
    this.receiptsList = const [],
    this.failure = ExpensesFailure.empty,
  });

  /// Creates an initial [ExpensesState].
  const ExpensesState.initial() : this._();

  final ExpensesStatus status;
  final Expenses expenses;
  final List<Expenses> expensesList;
  final ExpenseSpits expenseSpits;
  final List<ExpenseSpits> expenseSpitsList;
  final RecurringExpenses recurringExpenses;
  final List<RecurringExpenses> recurringExpensesList;
  final Receipts receipts;
  final List<Receipts> receiptsList;
  final ExpensesFailure failure;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        expenses,
        expensesList,
        expenseSpits,
        expenseSpitsList,
        recurringExpenses,
        recurringExpensesList,
        receipts,
        receiptsList,
        failure,
      ];

  /// Creates a new [ExpensesState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  ExpensesState copyWith({
    ExpensesStatus? status,
    Expenses? expenses,
    List<Expenses>? expensesList,
    ExpenseSpits? expenseSpits,
    List<ExpenseSpits>? expenseSpitsList,
    RecurringExpenses? recurringExpenses,
    List<RecurringExpenses>? recurringExpensesList,
    Receipts? receipts,
    List<Receipts>? receiptsList,
    ExpensesFailure? failure,
  }) {
    return ExpensesState._(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      expensesList: expensesList ?? this.expensesList,
      expenseSpits: expenseSpits ?? this.expenseSpits,
      expenseSpitsList: expenseSpitsList ?? this.expenseSpitsList,
      recurringExpenses: recurringExpenses ?? this.recurringExpenses,
      recurringExpensesList:
          recurringExpensesList ?? this.recurringExpensesList,
      receipts: receipts ?? this.receipts,
      receiptsList: receiptsList ?? this.receiptsList,
      failure: failure ?? this.failure,
    );
  }
}

/// Extension methods for convenient state checks.
extension ExpensesStateExtensions on ExpensesState {
  bool get isLoaded => status == ExpensesStatus.loaded;
  bool get isLoading => status == ExpensesStatus.loading;
  bool get isFailure => status == ExpensesStatus.failure;
}

/// Extension methods for creating new [ExpensesState] instances.
extension _ExpensesStateExtensions on ExpensesState {
  ExpensesState fromLoading() => copyWith(status: ExpensesStatus.loading);
  ExpensesState fromLoaded() => copyWith(status: ExpensesStatus.loaded);
  ExpensesState fromExpensesLoaded({required Expenses expenses}) => copyWith(
        status: ExpensesStatus.loaded,
        expenses: expenses,
      );
  ExpensesState fromExpensesListLoaded(
          {required List<Expenses> expensesList}) =>
      copyWith(
        status: ExpensesStatus.loaded,
        expensesList: expensesList,
      );
  ExpensesState fromExpenseSpitsLoaded({required ExpenseSpits expenseSpits}) =>
      copyWith(
        status: ExpensesStatus.loaded,
        expenseSpits: expenseSpits,
      );
  ExpensesState fromExpenseSpitsListLoaded(
          {required List<ExpenseSpits> expenseSpitsList}) =>
      copyWith(
        status: ExpensesStatus.loaded,
        expenseSpitsList: expenseSpitsList,
      );
  ExpensesState fromRecurringExpensesLoaded(
          {required RecurringExpenses recurringExpenses}) =>
      copyWith(
        status: ExpensesStatus.loaded,
        recurringExpenses: recurringExpenses,
      );
  ExpensesState fromRecurringExpensesListLoaded(
          {required List<RecurringExpenses> recurringExpensesList}) =>
      copyWith(
        status: ExpensesStatus.loaded,
        recurringExpensesList: recurringExpensesList,
      );
  ExpensesState fromReceiptsLoaded({required Receipts receipts}) => copyWith(
        status: ExpensesStatus.loaded,
        receipts: receipts,
      );
  ExpensesState fromReceiptsListLoaded(
          {required List<Receipts> receiptsList}) =>
      copyWith(
        status: ExpensesStatus.loaded,
        receiptsList: receiptsList,
      );

  ExpensesState fromExpensesFailure(ExpensesFailure failure) => copyWith(
        status: ExpensesStatus.failure,
        failure: failure,
      );
}

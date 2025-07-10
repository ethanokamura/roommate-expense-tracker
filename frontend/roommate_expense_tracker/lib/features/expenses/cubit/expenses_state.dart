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
    this.failure = ExpensesFailure.empty,
  });

  /// Creates an initial [ExpensesState].
  const ExpensesState.initial() : this._();

  final ExpensesStatus status;
  final Expenses expenses;
  final List<Expenses> expensesList;
  final ExpensesFailure failure;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        expenses,
        expensesList,
        failure,
      ];

  /// Creates a new [ExpensesState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  ExpensesState copyWith({
    ExpensesStatus? status,
    Expenses? expenses,
    List<Expenses>? expensesList,
    ExpensesFailure? failure,
  }) {
    return ExpensesState._(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      expensesList: expensesList ?? this.expensesList,
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
  ExpensesState fromExpensesFailure(ExpensesFailure failure) => copyWith(
        status: ExpensesStatus.failure,
        failure: failure,
      );
}

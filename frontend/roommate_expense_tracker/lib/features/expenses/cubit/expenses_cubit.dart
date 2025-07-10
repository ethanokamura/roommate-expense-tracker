import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'package:expenses_repository/expenses_repository.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  /// Creates a new instance of [ExpensesCubit].
  ///
  /// Requires a [ExpensesRepository] to handle data operations.
  ExpensesCubit({
    required ExpensesRepository expensesRepository,
  })  : _expensesRepository = expensesRepository,
        super(const ExpensesState.initial());

  final ExpensesRepository _expensesRepository;

  /// Insert [Expenses] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [Expenses].
  ///
  /// Requires the [houseId] to create the object
  /// Requires the [houseMemberId] to create the object
  /// Requires the [description] to create the object
  /// Requires the [totalAmount] to create the object
  /// Requires the [isSettled] to create the object
  Future<void> createExpenses({
    required String houseId,
    required String houseMemberId,
    required String title,
    required String description,
    required String totalAmount,
    required List<ExpenseSplit> splits,
    required String isSettled,
    required String token,
    bool forceRefresh = true,
  }) async {
    emit(state.fromLoading());
    try {
      final List<Map<String, dynamic>> mappedSplits = [];
      for (final split in splits) {
        mappedSplits.add(split.toJson());
      }
      // Retrieve new row after inserting
      final expenses = await _expensesRepository.createExpenses(
        data: {
          Expenses.houseIdConverter: houseId,
          Expenses.houseMemberIdConverter: houseMemberId,
          Expenses.titleConverter: title,
          Expenses.descriptionConverter: description,
          Expenses.splitsConverter: {"house_members": mappedSplits},
          Expenses.totalAmountConverter: totalAmount,
          Expenses.isSettledConverter: isSettled,
        },
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromExpensesLoaded(
          expenses: expenses,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [Expenses] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<void> fetchAllExpenses({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expensesList = await _expensesRepository.fetchAllExpenses(
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromExpensesListLoaded(
          expensesList: expensesList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch single() [Expenses] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Expenses].
  ///
  /// Requires the [expenseId] for lookup
  Future<void> fetchExpensesWithExpenseId({
    required String expenseId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expenses = await _expensesRepository.fetchExpensesWithExpenseId(
        expenseId: expenseId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromExpensesLoaded(
          expenses: expenses,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [Expenses] objects from Rds.
  ///
  /// Requires the [houseMemberId] for lookup
  Future<void> fetchAllExpensesWithHouseMemberId({
    required String houseMemberId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expensesList =
          await _expensesRepository.fetchAllExpensesWithHouseMemberId(
        houseMemberId: houseMemberId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromExpensesListLoaded(
          expensesList: expensesList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [Expenses] objects from Rds.
  ///
  /// Requires the [houseId] for lookup
  Future<void> fetchAllExpensesWithHouseId({
    required String houseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expensesList =
          await _expensesRepository.fetchAllExpensesWithHouseId(
        houseId: houseId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(state.fromExpensesListLoaded(
        expensesList: expensesList,
      ));
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Update the given [Expenses] in Rds.
  ///
  /// Return data if successful, or an empty instance of [Expenses].
  ///
  /// Requires the [expenseId] to update the object
  Future<void> updateExpenses({
    required String expenseId,
    required Expenses newExpensesData,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expenses = await _expensesRepository.updateExpenses(
        expenseId: expenseId,
        newExpensesData: newExpensesData,
        token: token,
      );
      emit(
        state.fromExpensesLoaded(
          expenses: expenses,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Delete the given [Expenses] from Rds.
  ///
  /// Requires the [expenseId] to delete the object
  Future<void> deleteExpenses({
    required String expenseId,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final message = await _expensesRepository.deleteExpenses(
        expenseId: expenseId,
        token: token,
      );
      debugPrint(message);
      emit(state.fromLoaded());
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }
}

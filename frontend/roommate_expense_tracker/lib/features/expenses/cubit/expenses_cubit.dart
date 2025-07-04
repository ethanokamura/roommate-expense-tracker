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
    required String description,
    required String totalAmount,
    required String isSettled,
    required String token,
    bool forceRefresh = true,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expenses = await _expensesRepository.createExpenses(
        houseId: houseId,
        houseMemberId: houseMemberId,
        description: description,
        totalAmount: totalAmount,
        isSettled: isSettled,
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

  /// Insert [ExpenseSpits] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [ExpenseSpits].
  ///
  /// Requires the [expenseId] to create the object
  /// Requires the [houseMemberId] to create the object
  /// Requires the [amountOwed] to create the object
  /// Requires the [isPaid] to create the object
  Future<void> createExpenseSpits({
    required String expenseId,
    required String houseMemberId,
    required String amountOwed,
    required String isPaid,
    required String token,
    bool forceRefresh = true,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expenseSpits = await _expensesRepository.createExpenseSpits(
        expenseId: expenseId,
        houseMemberId: houseMemberId,
        amountOwed: amountOwed,
        isPaid: isPaid,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromExpenseSpitsLoaded(
          expenseSpits: expenseSpits,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenseSpits: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Insert [RecurringExpenses] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [RecurringExpenses].
  ///
  /// Requires the [houseId] to create the object
  /// Requires the [houseMemberId] to create the object
  /// Requires the [descriptionTemplate] to create the object
  /// Requires the [amountTemplate] to create the object
  /// Requires the [frequency] to create the object
  /// Requires the [isActive] to create the object
  Future<void> createRecurringExpenses({
    required String houseId,
    required String houseMemberId,
    required String descriptionTemplate,
    required String amountTemplate,
    required String frequency,
    required String isActive,
    required String token,
    bool forceRefresh = true,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final recurringExpenses =
          await _expensesRepository.createRecurringExpenses(
        houseId: houseId,
        houseMemberId: houseMemberId,
        descriptionTemplate: descriptionTemplate,
        amountTemplate: amountTemplate,
        frequency: frequency,
        isActive: isActive,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromRecurringExpensesLoaded(
          recurringExpenses: recurringExpenses,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create recurringExpenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Insert [Receipts] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [Receipts].
  ///
  /// Requires the [expenseId] to create the object
  /// Requires the [imageUrl] to create the object
  /// Requires the [userId] to create the object
  Future<void> createReceipts({
    required String expenseId,
    required String imageUrl,
    required String userId,
    required String token,
    bool forceRefresh = true,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final receipts = await _expensesRepository.createReceipts(
        expenseId: expenseId,
        imageUrl: imageUrl,
        userId: userId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromReceiptsLoaded(
          receipts: receipts,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create receipts: $failure');
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

  /// Fetch list of all [ExpenseSpits] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<void> fetchAllExpenseSpits({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expenseSpitsList = await _expensesRepository.fetchAllExpenseSpits(
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromExpenseSpitsListLoaded(
          expenseSpitsList: expenseSpitsList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenseSpits: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch single() [ExpenseSpits] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [ExpenseSpits].
  ///
  /// Requires the [expenseSplitId] for lookup
  Future<void> fetchExpenseSpitsWithExpenseSplitId({
    required String expenseSplitId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expenseSpits =
          await _expensesRepository.fetchExpenseSpitsWithExpenseSplitId(
        expenseSplitId: expenseSplitId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromExpenseSpitsLoaded(
          expenseSpits: expenseSpits,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenseSpits: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [ExpenseSpits] objects from Rds.
  ///
  /// Requires the [expenseId] for lookup
  Future<void> fetchAllExpenseSpitsWithExpenseId({
    required String expenseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expenseSpitsList =
          await _expensesRepository.fetchAllExpenseSpitsWithExpenseId(
        expenseId: expenseId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromExpenseSpitsListLoaded(
          expenseSpitsList: expenseSpitsList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenseSpits: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [ExpenseSpits] objects from Rds.
  ///
  /// Requires the [houseMemberId] for lookup
  Future<void> fetchAllExpenseSpitsWithHouseMemberId({
    required String houseMemberId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expenseSpitsList =
          await _expensesRepository.fetchAllExpenseSpitsWithHouseMemberId(
        houseMemberId: houseMemberId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromExpenseSpitsListLoaded(
          expenseSpitsList: expenseSpitsList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenseSpits: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [RecurringExpenses] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<void> fetchAllRecurringExpenses({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final recurringExpensesList =
          await _expensesRepository.fetchAllRecurringExpenses(
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromRecurringExpensesListLoaded(
          recurringExpensesList: recurringExpensesList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create recurringExpenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch single() [RecurringExpenses] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [RecurringExpenses].
  ///
  /// Requires the [recurringExpenseId] for lookup
  Future<void> fetchRecurringExpensesWithRecurringExpenseId({
    required String recurringExpenseId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final recurringExpenses = await _expensesRepository
          .fetchRecurringExpensesWithRecurringExpenseId(
        recurringExpenseId: recurringExpenseId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromRecurringExpensesLoaded(
          recurringExpenses: recurringExpenses,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create recurringExpenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [RecurringExpenses] objects from Rds.
  ///
  /// Requires the [houseId] for lookup
  Future<void> fetchAllRecurringExpensesWithHouseId({
    required String houseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final recurringExpensesList =
          await _expensesRepository.fetchAllRecurringExpensesWithHouseId(
        houseId: houseId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromRecurringExpensesListLoaded(
          recurringExpensesList: recurringExpensesList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create recurringExpenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [RecurringExpenses] objects from Rds.
  ///
  /// Requires the [houseMemberId] for lookup
  Future<void> fetchAllRecurringExpensesWithHouseMemberId({
    required String houseMemberId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final recurringExpensesList =
          await _expensesRepository.fetchAllRecurringExpensesWithHouseMemberId(
        houseMemberId: houseMemberId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromRecurringExpensesListLoaded(
          recurringExpensesList: recurringExpensesList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create recurringExpenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [Receipts] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<void> fetchAllReceipts({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final receiptsList = await _expensesRepository.fetchAllReceipts(
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromReceiptsListLoaded(
          receiptsList: receiptsList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create receipts: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch single() [Receipts] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Receipts].
  ///
  /// Requires the [receiptId] for lookup
  Future<void> fetchReceiptsWithReceiptId({
    required String receiptId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final receipts = await _expensesRepository.fetchReceiptsWithReceiptId(
        receiptId: receiptId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromReceiptsLoaded(
          receipts: receipts,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create receipts: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [Receipts] objects from Rds.
  ///
  /// Requires the [expenseId] for lookup
  Future<void> fetchAllReceiptsWithExpenseId({
    required String expenseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final receiptsList =
          await _expensesRepository.fetchAllReceiptsWithExpenseId(
        expenseId: expenseId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromReceiptsListLoaded(
          receiptsList: receiptsList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create receipts: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch list of all [Receipts] objects from Rds.
  ///
  /// Requires the [userId] for lookup
  Future<void> fetchAllReceiptsWithUserId({
    required String userId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final receiptsList = await _expensesRepository.fetchAllReceiptsWithUserId(
        userId: userId,
        token: token,
        orderBy: orderBy,
        ascending: ascending,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromReceiptsListLoaded(
          receiptsList: receiptsList,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create receipts: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Fetch single() [Receipts] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Receipts].
  ///
  /// Requires the [expenseId] for lookup
  Future<void> fetchReceiptsWithExpenseId({
    required String expenseId,
    required String token,
    bool forceRefresh = false,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final receipts = await _expensesRepository.fetchReceiptsWithExpenseId(
        expenseId: expenseId,
        token: token,
        forceRefresh: forceRefresh,
      );
      emit(
        state.fromReceiptsLoaded(
          receipts: receipts,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create receipts: $failure');
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

  /// Update the given [ExpenseSpits] in Rds.
  ///
  /// Return data if successful, or an empty instance of [ExpenseSpits].
  ///
  /// Requires the [expenseSplitId] to update the object
  Future<void> updateExpenseSpits({
    required String expenseSplitId,
    required ExpenseSpits newExpenseSpitsData,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final expenseSpits = await _expensesRepository.updateExpenseSpits(
        expenseSplitId: expenseSplitId,
        newExpenseSpitsData: newExpenseSpitsData,
        token: token,
      );
      emit(
        state.fromExpenseSpitsLoaded(
          expenseSpits: expenseSpits,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenseSpits: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Update the given [RecurringExpenses] in Rds.
  ///
  /// Return data if successful, or an empty instance of [RecurringExpenses].
  ///
  /// Requires the [recurringExpenseId] to update the object
  Future<void> updateRecurringExpenses({
    required String recurringExpenseId,
    required RecurringExpenses newRecurringExpensesData,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final recurringExpenses =
          await _expensesRepository.updateRecurringExpenses(
        recurringExpenseId: recurringExpenseId,
        newRecurringExpensesData: newRecurringExpensesData,
        token: token,
      );
      emit(
        state.fromRecurringExpensesLoaded(
          recurringExpenses: recurringExpenses,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create recurringExpenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Update the given [Receipts] in Rds.
  ///
  /// Return data if successful, or an empty instance of [Receipts].
  ///
  /// Requires the [receiptId] to update the object
  Future<void> updateReceipts({
    required String receiptId,
    required Receipts newReceiptsData,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final receipts = await _expensesRepository.updateReceipts(
        receiptId: receiptId,
        newReceiptsData: newReceiptsData,
        token: token,
      );
      emit(
        state.fromReceiptsLoaded(
          receipts: receipts,
        ),
      );
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create receipts: $failure');
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

  /// Delete the given [ExpenseSpits] from Rds.
  ///
  /// Requires the [expenseSplitId] to delete the object
  Future<void> deleteExpenseSpits({
    required String expenseSplitId,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final message = await _expensesRepository.deleteExpenseSpits(
        expenseSplitId: expenseSplitId,
        token: token,
      );
      debugPrint(message);
      emit(state.fromLoaded());
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create expenseSpits: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Delete the given [RecurringExpenses] from Rds.
  ///
  /// Requires the [recurringExpenseId] to delete the object
  Future<void> deleteRecurringExpenses({
    required String recurringExpenseId,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final message = await _expensesRepository.deleteRecurringExpenses(
        recurringExpenseId: recurringExpenseId,
        token: token,
      );
      debugPrint(message);
      emit(state.fromLoaded());
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create recurringExpenses: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }

  /// Delete the given [Receipts] from Rds.
  ///
  /// Requires the [receiptId] to delete the object
  Future<void> deleteReceipts({
    required String receiptId,
    required String token,
  }) async {
    emit(state.fromLoading());
    try {
      // Retrieve new row after inserting
      final message = await _expensesRepository.deleteReceipts(
        receiptId: receiptId,
        token: token,
      );
      debugPrint(message);
      emit(state.fromLoaded());
    } on ExpensesFailure catch (failure) {
      debugPrint('Failure to create receipts: $failure');
      emit(state.fromExpensesFailure(failure));
    }
  }
}

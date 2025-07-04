import 'dart:convert';
import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'models/expenses.dart';
import 'models/expense_spits.dart';
import 'models/recurring_expenses.dart';
import 'models/receipts.dart';
import 'failures.dart';

/// Repository class for managing ExpensesRepository methods and data
class ExpensesRepository {
  /// Constructor for ExpensesRepository.
  ExpensesRepository({
    CacheManager? cacheManager,
  }) : _cacheManager = cacheManager ?? GetIt.instance<CacheManager>();

  final CacheManager _cacheManager;

  Expenses _expenses = Expenses.empty;
  Expenses get expenses => _expenses;

  List<Expenses> _expensesList = [];
  List<Expenses> get expensesList => _expensesList;
  ExpenseSpits _expenseSpits = ExpenseSpits.empty;
  ExpenseSpits get expenseSpits => _expenseSpits;

  List<ExpenseSpits> _expenseSpitsList = [];
  List<ExpenseSpits> get expenseSpitsList => _expenseSpitsList;
  RecurringExpenses _recurringExpenses = RecurringExpenses.empty;
  RecurringExpenses get recurringExpenses => _recurringExpenses;

  List<RecurringExpenses> _recurringExpensesList = [];
  List<RecurringExpenses> get recurringExpensesList => _recurringExpensesList;
  Receipts _receipts = Receipts.empty;
  Receipts get receipts => _receipts;

  List<Receipts> _receiptsList = [];
  List<Receipts> get receiptsList => _receiptsList;
}

extension Create on ExpensesRepository {
  /// Insert [Expenses] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [Expenses].
  ///
  /// Requires the [houseId] to create the object
  /// Requires the [houseMemberId] to create the object
  /// Requires the [description] to create the object
  /// Requires the [totalAmount] to create the object
  /// Requires the [isSettled] to create the object
  Future<Expenses> createExpenses({
    required String houseId,
    required String houseMemberId,
    required String description,
    required String totalAmount,
    required String isSettled,
    required String token,
    bool forceRefresh = true,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expenses',
      Expenses.houseIdConverter: houseId,
      Expenses.houseMemberIdConverter: houseMemberId,
      Expenses.descriptionConverter: description,
      Expenses.totalAmountConverter: totalAmount,
      Expenses.isSettledConverter: isSettled,
    });

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _expenses = Expenses.converterSingle(jsonData);
          return _expenses;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenses data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expenses/',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: {
          'house_id': houseId,
          'house_member_id': houseMemberId,
          'description': description,
          'total_amount': totalAmount,
          'is_settled': isSettled,
        },
      );
      debugPrint('Expenses post response: $response');
      if (response['status'] != '201') {
        throw ExpensesFailure.fromCreate();
      }
      // Success
      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expenses = Expenses.converterSingle(jsonData);
      return _expenses;
    } catch (e) {
      debugPrint('Failure to create expenses: $e');
      throw ExpensesFailure.fromCreate();
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
  Future<ExpenseSpits> createExpenseSpits({
    required String expenseId,
    required String houseMemberId,
    required String amountOwed,
    required String isPaid,
    required String token,
    bool forceRefresh = true,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expense_spits',
      ExpenseSpits.expenseIdConverter: expenseId,
      ExpenseSpits.houseMemberIdConverter: houseMemberId,
      ExpenseSpits.amountOwedConverter: amountOwed,
      ExpenseSpits.isPaidConverter: isPaid,
    });

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _expenseSpits = ExpenseSpits.converterSingle(jsonData);
          return _expenseSpits;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenseSpits data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expense-spits/',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: {
          'expense_id': expenseId,
          'house_member_id': houseMemberId,
          'amount_owed': amountOwed,
          'is_paid': isPaid,
        },
      );
      debugPrint('Expenses post response: $response');
      if (response['status'] != '201') {
        throw ExpensesFailure.fromCreate();
      }
      // Success
      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expenseSpits = ExpenseSpits.converterSingle(jsonData);
      return _expenseSpits;
    } catch (e) {
      debugPrint('Failure to create expenseSpits: $e');
      throw ExpensesFailure.fromCreate();
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
  Future<RecurringExpenses> createRecurringExpenses({
    required String houseId,
    required String houseMemberId,
    required String descriptionTemplate,
    required String amountTemplate,
    required String frequency,
    required String isActive,
    required String token,
    bool forceRefresh = true,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'recurring_expenses',
      RecurringExpenses.houseIdConverter: houseId,
      RecurringExpenses.houseMemberIdConverter: houseMemberId,
      RecurringExpenses.descriptionTemplateConverter: descriptionTemplate,
      RecurringExpenses.amountTemplateConverter: amountTemplate,
      RecurringExpenses.frequencyConverter: frequency,
      RecurringExpenses.isActiveConverter: isActive,
    });

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _recurringExpenses = RecurringExpenses.converterSingle(jsonData);
          return _recurringExpenses;
        } catch (e) {
          debugPrint(
              'Error decoding cached recurringExpenses data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/recurring-expenses/',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: {
          'house_id': houseId,
          'house_member_id': houseMemberId,
          'description_template': descriptionTemplate,
          'amount_template': amountTemplate,
          'frequency': frequency,
          'is_active': isActive,
        },
      );
      debugPrint('Expenses post response: $response');
      if (response['status'] != '201') {
        throw ExpensesFailure.fromCreate();
      }
      // Success
      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _recurringExpenses = RecurringExpenses.converterSingle(jsonData);
      return _recurringExpenses;
    } catch (e) {
      debugPrint('Failure to create recurringExpenses: $e');
      throw ExpensesFailure.fromCreate();
    }
  }

  /// Insert [Receipts] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [Receipts].
  ///
  /// Requires the [expenseId] to create the object
  /// Requires the [imageUrl] to create the object
  /// Requires the [userId] to create the object
  Future<Receipts> createReceipts({
    required String expenseId,
    required String imageUrl,
    required String userId,
    required String token,
    bool forceRefresh = true,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'receipts',
      Receipts.expenseIdConverter: expenseId,
      Receipts.imageUrlConverter: imageUrl,
      Receipts.userIdConverter: userId,
    });

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _receipts = Receipts.converterSingle(jsonData);
          return _receipts;
        } catch (e) {
          debugPrint(
              'Error decoding cached receipts data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/receipts/',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: {
          'expense_id': expenseId,
          'image_url': imageUrl,
          'user_id': userId,
        },
      );
      debugPrint('Expenses post response: $response');
      if (response['status'] != '201') {
        throw ExpensesFailure.fromCreate();
      }
      // Success
      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _receipts = Receipts.converterSingle(jsonData);
      return _receipts;
    } catch (e) {
      debugPrint('Failure to create receipts: $e');
      throw ExpensesFailure.fromCreate();
    }
  }
}

extension Read on ExpensesRepository {
  /// Fetch list of all [Expenses] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<List<Expenses>> fetchAllExpenses({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'object': 'expenses',
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _expensesList =
              Expenses.converter(jsonData.cast<Map<String, dynamic>>());
          return _expensesList;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = Expenses.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expenses?sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all expenses response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expensesList = Expenses.converter(jsonData.cast<Map<String, dynamic>>());
      return _expensesList;
    } catch (e) {
      debugPrint('Failure to fetch all expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch single() [Expenses] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Expenses].
  ///
  /// Requires the [expenseId] for lookup
  Future<Expenses> fetchExpensesWithExpenseId({
    required String expenseId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expenses',
      Expenses.expenseIdConverter: expenseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _expenses = Expenses.converterSingle(jsonData);
          return _expenses;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenses data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expenses/$expenseId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expenses = Expenses.converterSingle(jsonData);

      return _expenses;
    } catch (e) {
      debugPrint('Failure to fetch expenses with expenseId: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [Expenses] objects from Rds.
  ///
  /// Requires the [houseMemberId] for lookup
  Future<List<Expenses>> fetchAllExpensesWithHouseMemberId({
    required String houseMemberId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expenses',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'house_member_id': houseMemberId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _expensesList =
              Expenses.converter(jsonData.cast<Map<String, dynamic>>());
          return _expensesList;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = Expenses.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/expenses?house_member_id=$houseMemberId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all expenses response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expensesList = Expenses.converter(jsonData.cast<Map<String, dynamic>>());
      return _expensesList;
    } catch (e) {
      debugPrint('Failure to fetch all expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [Expenses] objects from Rds.
  ///
  /// Requires the [houseId] for lookup
  Future<List<Expenses>> fetchAllExpensesWithHouseId({
    required String houseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expenses',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'house_id': houseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _expensesList =
              Expenses.converter(jsonData.cast<Map<String, dynamic>>());
          return _expensesList;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = Expenses.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/expenses?house_id=$houseId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all expenses response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expensesList = Expenses.converter(jsonData.cast<Map<String, dynamic>>());
      return _expensesList;
    } catch (e) {
      debugPrint('Failure to fetch all expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [ExpenseSpits] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<List<ExpenseSpits>> fetchAllExpenseSpits({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'object': 'expense_spits',
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _expenseSpitsList =
              ExpenseSpits.converter(jsonData.cast<Map<String, dynamic>>());
          return _expenseSpitsList;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenseSpits list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = ExpenseSpits.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/expense-spits?sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all expense_spits response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expenseSpitsList =
          ExpenseSpits.converter(jsonData.cast<Map<String, dynamic>>());
      return _expenseSpitsList;
    } catch (e) {
      debugPrint('Failure to fetch all expense_spits: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch single() [ExpenseSpits] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [ExpenseSpits].
  ///
  /// Requires the [expenseSplitId] for lookup
  Future<ExpenseSpits> fetchExpenseSpitsWithExpenseSplitId({
    required String expenseSplitId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expense_spits',
      ExpenseSpits.expenseSplitIdConverter: expenseSplitId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _expenseSpits = ExpenseSpits.converterSingle(jsonData);
          return _expenseSpits;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenseSpits data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expense-spits/$expenseSplitId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expenseSpits = ExpenseSpits.converterSingle(jsonData);

      return _expenseSpits;
    } catch (e) {
      debugPrint('Failure to fetch expenseSpits with expenseSplitId: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [ExpenseSpits] objects from Rds.
  ///
  /// Requires the [expenseId] for lookup
  Future<List<ExpenseSpits>> fetchAllExpenseSpitsWithExpenseId({
    required String expenseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expense_spits',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'expense_id': expenseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _expenseSpitsList =
              ExpenseSpits.converter(jsonData.cast<Map<String, dynamic>>());
          return _expenseSpitsList;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenseSpits list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = ExpenseSpits.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/expense-spits?expense_id=$expenseId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all expense_spits response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expenseSpitsList =
          ExpenseSpits.converter(jsonData.cast<Map<String, dynamic>>());
      return _expenseSpitsList;
    } catch (e) {
      debugPrint('Failure to fetch all expense_spits: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [ExpenseSpits] objects from Rds.
  ///
  /// Requires the [houseMemberId] for lookup
  Future<List<ExpenseSpits>> fetchAllExpenseSpitsWithHouseMemberId({
    required String houseMemberId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expense_spits',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'house_member_id': houseMemberId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _expenseSpitsList =
              ExpenseSpits.converter(jsonData.cast<Map<String, dynamic>>());
          return _expenseSpitsList;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenseSpits list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = ExpenseSpits.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/expense-spits?house_member_id=$houseMemberId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all expense_spits response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _expenseSpitsList =
          ExpenseSpits.converter(jsonData.cast<Map<String, dynamic>>());
      return _expenseSpitsList;
    } catch (e) {
      debugPrint('Failure to fetch all expense_spits: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [RecurringExpenses] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<List<RecurringExpenses>> fetchAllRecurringExpenses({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'object': 'recurring_expenses',
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _recurringExpensesList = RecurringExpenses.converter(
              jsonData.cast<Map<String, dynamic>>());
          return _recurringExpensesList;
        } catch (e) {
          debugPrint(
              'Error decoding cached recurringExpenses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = RecurringExpenses.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/recurring-expenses?sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all recurring_expenses response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _recurringExpensesList =
          RecurringExpenses.converter(jsonData.cast<Map<String, dynamic>>());
      return _recurringExpensesList;
    } catch (e) {
      debugPrint('Failure to fetch all recurring_expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch single() [RecurringExpenses] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [RecurringExpenses].
  ///
  /// Requires the [recurringExpenseId] for lookup
  Future<RecurringExpenses> fetchRecurringExpensesWithRecurringExpenseId({
    required String recurringExpenseId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'recurring_expenses',
      RecurringExpenses.recurringExpenseIdConverter: recurringExpenseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _recurringExpenses = RecurringExpenses.converterSingle(jsonData);
          return _recurringExpenses;
        } catch (e) {
          debugPrint(
              'Error decoding cached recurringExpenses data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/recurring-expenses/$recurringExpenseId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _recurringExpenses = RecurringExpenses.converterSingle(jsonData);

      return _recurringExpenses;
    } catch (e) {
      debugPrint(
          'Failure to fetch recurringExpenses with recurringExpenseId: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [RecurringExpenses] objects from Rds.
  ///
  /// Requires the [houseId] for lookup
  Future<List<RecurringExpenses>> fetchAllRecurringExpensesWithHouseId({
    required String houseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'recurring_expenses',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'house_id': houseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _recurringExpensesList = RecurringExpenses.converter(
              jsonData.cast<Map<String, dynamic>>());
          return _recurringExpensesList;
        } catch (e) {
          debugPrint(
              'Error decoding cached recurringExpenses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = RecurringExpenses.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/recurring-expenses?house_id=$houseId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all recurring_expenses response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _recurringExpensesList =
          RecurringExpenses.converter(jsonData.cast<Map<String, dynamic>>());
      return _recurringExpensesList;
    } catch (e) {
      debugPrint('Failure to fetch all recurring_expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [RecurringExpenses] objects from Rds.
  ///
  /// Requires the [houseMemberId] for lookup
  Future<List<RecurringExpenses>> fetchAllRecurringExpensesWithHouseMemberId({
    required String houseMemberId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'recurring_expenses',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'house_member_id': houseMemberId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _recurringExpensesList = RecurringExpenses.converter(
              jsonData.cast<Map<String, dynamic>>());
          return _recurringExpensesList;
        } catch (e) {
          debugPrint(
              'Error decoding cached recurringExpenses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = RecurringExpenses.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/recurring-expenses?house_member_id=$houseMemberId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all recurring_expenses response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _recurringExpensesList =
          RecurringExpenses.converter(jsonData.cast<Map<String, dynamic>>());
      return _recurringExpensesList;
    } catch (e) {
      debugPrint('Failure to fetch all recurring_expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [Receipts] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<List<Receipts>> fetchAllReceipts({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'object': 'receipts',
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _receiptsList =
              Receipts.converter(jsonData.cast<Map<String, dynamic>>());
          return _receiptsList;
        } catch (e) {
          debugPrint(
              'Error decoding cached receipts list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = Receipts.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/receipts?sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all receipts response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _receiptsList = Receipts.converter(jsonData.cast<Map<String, dynamic>>());
      return _receiptsList;
    } catch (e) {
      debugPrint('Failure to fetch all receipts: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch single() [Receipts] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Receipts].
  ///
  /// Requires the [receiptId] for lookup
  Future<Receipts> fetchReceiptsWithReceiptId({
    required String receiptId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'receipts',
      Receipts.receiptIdConverter: receiptId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _receipts = Receipts.converterSingle(jsonData);
          return _receipts;
        } catch (e) {
          debugPrint(
              'Error decoding cached receipts data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/receipts/$receiptId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _receipts = Receipts.converterSingle(jsonData);

      return _receipts;
    } catch (e) {
      debugPrint('Failure to fetch receipts with receiptId: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [Receipts] objects from Rds.
  ///
  /// Requires the [expenseId] for lookup
  Future<List<Receipts>> fetchAllReceiptsWithExpenseId({
    required String expenseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'receipts',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'expense_id': expenseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _receiptsList =
              Receipts.converter(jsonData.cast<Map<String, dynamic>>());
          return _receiptsList;
        } catch (e) {
          debugPrint(
              'Error decoding cached receipts list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = Receipts.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/receipts?expense_id=$expenseId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all receipts response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _receiptsList = Receipts.converter(jsonData.cast<Map<String, dynamic>>());
      return _receiptsList;
    } catch (e) {
      debugPrint('Failure to fetch all receipts: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch list of all [Receipts] objects from Rds.
  ///
  /// Requires the [userId] for lookup
  Future<List<Receipts>> fetchAllReceiptsWithUserId({
    required String userId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'receipts',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'user_id': userId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _receiptsList =
              Receipts.converter(jsonData.cast<Map<String, dynamic>>());
          return _receiptsList;
        } catch (e) {
          debugPrint(
              'Error decoding cached receipts list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = Receipts.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/receipts?user_id=$userId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Expenses GET all receipts response: $response');
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _receiptsList = Receipts.converter(jsonData.cast<Map<String, dynamic>>());
      return _receiptsList;
    } catch (e) {
      debugPrint('Failure to fetch all receipts: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Fetch single() [Receipts] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Receipts].
  ///
  /// Requires the [expenseId] for lookup
  Future<Receipts> fetchReceiptsWithExpenseId({
    required String expenseId,
    required String token,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'receipts',
      Receipts.expenseIdConverter: expenseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _receipts = Receipts.converterSingle(jsonData);
          return _receipts;
        } catch (e) {
          debugPrint(
              'Error decoding cached receipts data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{'expense_id': expenseId};
      final queryString =
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/receipts?$queryString',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Expenses GET response: $response');

      // Failure
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      // Success
      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _receipts = Receipts.converterSingle(jsonData);

      return _receipts;
    } catch (e) {
      debugPrint('Failure to fetch receipts with unique details: $e');
      throw ExpensesFailure.fromGet();
    }
  }
}

extension Update on ExpensesRepository {
  /// Update the given [Expenses] in Rds.
  ///
  /// Return data if successful, or an empty instance of [Expenses].
  ///
  /// Requires the [expenseId] to update the object
  Future<Expenses> updateExpenses({
    required String expenseId,
    required Expenses newExpensesData,
    required String token,
  }) async {
    try {
      // Get cache key
      final cacheKey = generateCacheKey({
        'object': 'expenses',
        Expenses.expenseIdConverter: expenseId,
      });
      // Prepare data for insertion
      final data = newExpensesData.toJson();

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expenses/$expenseId',
        method: 'PATCH',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: data,
      );

      debugPrint('Expenses PATCH response: $response');

      // Failure
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      // Success
      final Map<String, dynamic>? jsonData = response['data'];
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      // Update local object
      _expenses = response['data'] != null
          ? Expenses.converterSingle(jsonData!)
          : Expenses.empty;

      // Return data
      return _expenses;
    } catch (e) {
      debugPrint('Failure to update expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Update the given [ExpenseSpits] in Rds.
  ///
  /// Return data if successful, or an empty instance of [ExpenseSpits].
  ///
  /// Requires the [expenseSplitId] to update the object
  Future<ExpenseSpits> updateExpenseSpits({
    required String expenseSplitId,
    required ExpenseSpits newExpenseSpitsData,
    required String token,
  }) async {
    try {
      // Get cache key
      final cacheKey = generateCacheKey({
        'object': 'expense_spits',
        ExpenseSpits.expenseSplitIdConverter: expenseSplitId,
      });
      // Prepare data for insertion
      final data = newExpenseSpitsData.toJson();

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expense-spits/$expenseSplitId',
        method: 'PATCH',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: data,
      );

      debugPrint('Expenses PATCH response: $response');

      // Failure
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      // Success
      final Map<String, dynamic>? jsonData = response['data'];
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      // Update local object
      _expenseSpits = response['data'] != null
          ? ExpenseSpits.converterSingle(jsonData!)
          : ExpenseSpits.empty;

      // Return data
      return _expenseSpits;
    } catch (e) {
      debugPrint('Failure to update expenseSpits: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Update the given [RecurringExpenses] in Rds.
  ///
  /// Return data if successful, or an empty instance of [RecurringExpenses].
  ///
  /// Requires the [recurringExpenseId] to update the object
  Future<RecurringExpenses> updateRecurringExpenses({
    required String recurringExpenseId,
    required RecurringExpenses newRecurringExpensesData,
    required String token,
  }) async {
    try {
      // Get cache key
      final cacheKey = generateCacheKey({
        'object': 'recurring_expenses',
        RecurringExpenses.recurringExpenseIdConverter: recurringExpenseId,
      });
      // Prepare data for insertion
      final data = newRecurringExpensesData.toJson();

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/recurring-expenses/$recurringExpenseId',
        method: 'PATCH',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: data,
      );

      debugPrint('Expenses PATCH response: $response');

      // Failure
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      // Success
      final Map<String, dynamic>? jsonData = response['data'];
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      // Update local object
      _recurringExpenses = response['data'] != null
          ? RecurringExpenses.converterSingle(jsonData!)
          : RecurringExpenses.empty;

      // Return data
      return _recurringExpenses;
    } catch (e) {
      debugPrint('Failure to update recurringExpenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Update the given [Receipts] in Rds.
  ///
  /// Return data if successful, or an empty instance of [Receipts].
  ///
  /// Requires the [receiptId] to update the object
  Future<Receipts> updateReceipts({
    required String receiptId,
    required Receipts newReceiptsData,
    required String token,
  }) async {
    try {
      // Get cache key
      final cacheKey = generateCacheKey({
        'object': 'receipts',
        Receipts.receiptIdConverter: receiptId,
      });
      // Prepare data for insertion
      final data = newReceiptsData.toJson();

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/receipts/$receiptId',
        method: 'PATCH',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: data,
      );

      debugPrint('Expenses PATCH response: $response');

      // Failure
      if (response['status'] != '200') {
        throw ExpensesFailure.fromGet();
      }

      // Success
      final Map<String, dynamic>? jsonData = response['data'];
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      // Update local object
      _receipts = response['data'] != null
          ? Receipts.converterSingle(jsonData!)
          : Receipts.empty;

      // Return data
      return _receipts;
    } catch (e) {
      debugPrint('Failure to update receipts: $e');
      throw ExpensesFailure.fromGet();
    }
  }
}

extension Delete on ExpensesRepository {
  /// Delete the given [Expenses] from Rds.
  ///
  /// Requires the [expenseId] to delete the object
  Future<String> deleteExpenses({
    required String expenseId,
    required String token,
  }) async {
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expenses/$expenseId',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Expenses DELETE response: $response');

      // Failure
      if (response['status'] != '204') {
        throw ExpensesFailure.fromDelete();
      }

      // Ensure valid response
      return response['message']!;
    } catch (e) {
      debugPrint('Failure to delete expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Delete the given [ExpenseSpits] from Rds.
  ///
  /// Requires the [expenseSplitId] to delete the object
  Future<String> deleteExpenseSpits({
    required String expenseSplitId,
    required String token,
  }) async {
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expense-spits/$expenseSplitId',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Expenses DELETE response: $response');

      // Failure
      if (response['status'] != '204') {
        throw ExpensesFailure.fromDelete();
      }

      // Ensure valid response
      return response['message']!;
    } catch (e) {
      debugPrint('Failure to delete expenseSpits: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Delete the given [RecurringExpenses] from Rds.
  ///
  /// Requires the [recurringExpenseId] to delete the object
  Future<String> deleteRecurringExpenses({
    required String recurringExpenseId,
    required String token,
  }) async {
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/recurring-expenses/$recurringExpenseId',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Expenses DELETE response: $response');

      // Failure
      if (response['status'] != '204') {
        throw ExpensesFailure.fromDelete();
      }

      // Ensure valid response
      return response['message']!;
    } catch (e) {
      debugPrint('Failure to delete recurringExpenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  /// Delete the given [Receipts] from Rds.
  ///
  /// Requires the [receiptId] to delete the object
  Future<String> deleteReceipts({
    required String receiptId,
    required String token,
  }) async {
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/receipts/$receiptId',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Expenses DELETE response: $response');

      // Failure
      if (response['status'] != '204') {
        throw ExpensesFailure.fromDelete();
      }

      // Ensure valid response
      return response['message']!;
    } catch (e) {
      debugPrint('Failure to delete receipts: $e');
      throw ExpensesFailure.fromGet();
    }
  }
}

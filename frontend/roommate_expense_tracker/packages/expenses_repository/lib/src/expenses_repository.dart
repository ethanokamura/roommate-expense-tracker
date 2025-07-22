import 'dart:convert';
import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'models/expenses.dart';
import 'failures.dart';

class ExpenseSplit {
  const ExpenseSplit({
    this.memberId = '',
    this.amountOwed = 0.0,
    this.paidOn,
  });

  final String memberId;
  final double amountOwed;
  final DateTime? paidOn;

  // JSON string equivalent for our data
  static String get memberIdConverter => 'member_id';
  static String get amountOwedConverter => 'amount_owed';
  static String get paidOnConverter => 'paid_on';

  factory ExpenseSplit.fromJson(Map<String, dynamic> json) {
    return ExpenseSplit(
      memberId: json[memberIdConverter]?.toString() ?? '',
      amountOwed: json[amountOwedConverter] != null
          ? double.tryParse(json[amountOwedConverter].toString()) ?? 0.0
          : 0.0,
      paidOn: json[paidOnConverter] != null
          ? DateTime.tryParse(json[paidOnConverter].toString())?.toUtc() ??
              DateTime.now().toUtc()
          : null,
    );
  }

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<ExpenseSplit> converter(List<Map<String, dynamic>> data) {
    return data.map(ExpenseSplit.fromJson).toList();
  }

  // Generic function to map our dart object to a JSON object
  Map<String, dynamic> toJson() {
    return _generateMap(
      memberId: memberId,
      amountOwed: amountOwed,
      paidOn: paidOn,
    );
  }

  // Generic function to generate a generic mapping between objects
  static Map<String, dynamic> _generateMap({
    String? memberId,
    double? amountOwed,
    DateTime? paidOn,
  }) =>
      {
        if (memberId != null) memberIdConverter: memberId,
        if (amountOwed != null) amountOwedConverter: amountOwed,
        if (paidOn != null) paidOnConverter: paidOn,
      };
}

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
}

extension Create on ExpensesRepository {
  /// Insert [Expenses] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [Expenses].
  ///
  /// Requires the [data] to create the object
  Future<Expenses> createExpenses({
    required Map<String, dynamic> data,
    required String token,
  }) async {
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
        payload: data,
      );
      if (response['success'] != true) {
        throw ExpensesFailure.fromCreate();
      }
      // Success
      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody =
          jsonEncode(jsonData); // Encode to string for caching

      _expenses = Expenses.converterSingle(jsonData);
      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: generateCacheKey({
          'expense_id': _expenses.expenseId!,
        }),
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      return _expenses;
    } catch (e) {
      debugPrint('Failure to create expenses: $e');
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
      if (response['success'] != true) {
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
    bool forceRefresh = false,
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
      if (response['success'] != true) {
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
      if (response['success'] != true) {
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
  /// Requires the [houseMemberId] for lookup
  /// Requires the [houseId] for lookup
  Future<List<Expenses>> fetchMyExpenses({
    required String houseMemberId,
    required String houseId,
    required String token,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expenses',
      'house_member_id': houseMemberId,
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
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/expenses/my-expenses?house_member_id=$houseMemberId&house_id=$houseId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response['success'] != true) {
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
  /// Requires the [houseMemberId] for lookup
  /// Requires the [houseId] for lookup
  Future<double> fetchMyTotalExpenses({
    required String houseMemberId,
    required String houseId,
    required String token,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'expenses',
      'house_member_id': houseMemberId,
      'house_id': houseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> response = jsonDecode(cachedData);
          final double total = double.tryParse(
                  response['total_amount_owed']?.toString() ?? '') ??
              0.0;
          return total;
        } catch (e) {
          debugPrint(
              'Error decoding cached expenses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/expenses/my-total-expenses?house_member_id=$houseMemberId&house_id=$houseId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response['success'] != true) {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> data = response['data'];

      final double total =
          double.tryParse(data.first['total_amount_owed']?.toString() ?? '') ??
              0.0;

      // Success
      final String responseBody = jsonEncode(
          {'total_amount_owed': total}); // Encode to string for caching

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      return total;
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
    bool useTestData = false,
  }) async {
    // if (useTestData) {
    //   debugPrint('Loading test data for expenses');
    //   try {
    //     const assetPath = 'assets/data/expenses.json';
    //     final String responseBody = await rootBundle.loadString(assetPath);
    //     final Map<String, dynamic> rawJsonData = jsonDecode(responseBody);
    //     if (!rawJsonData.containsKey('expenses')) {
    //       debugPrint(
    //           'Error loading test data from asset: key - "expenses" does not exist.');
    //       throw ExpensesFailure.fromGet();
    //     }
    //     final List<dynamic> jsonData = rawJsonData['expenses'];
    //     _expensesList =
    //         Expenses.converter(jsonData.cast<Map<String, dynamic>>());
    //     return _expensesList;
    //   } catch (e) {
    //     debugPrint('Error loading test data from asset: $e');
    //     throw ExpensesFailure.fromGet();
    //   }
    // }

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
      if (response['success'] != true) {
        throw ExpensesFailure.fromGet();
      }

      if (response['data'] == null) {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;
      // Success
      final String responseBody = jsonEncode(jsonData);

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
  Future<List<Map<String, dynamic>>> fetchWeeklyExpenseCategories({
    required String key,
    required String value,
    required String token,
    bool forceRefresh = false,
    bool useTestData = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'weekly_expense_categories',
      key: value,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          return jsonData.cast<Map<String, dynamic>>();
        } catch (e) {
          debugPrint(
              'Error decoding cached expenses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expenses/categories?key=$key&value=$value',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response['success'] != true) {
        throw ExpensesFailure.fromGet();
      }

      if (response['data'] == null) {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;

      // Success
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      return jsonData.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Failure to fetch all expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }

  List<ExpenseSplit> extractSplits(Map<String, dynamic> splitsJson) {
    if (!splitsJson.containsKey('member_splits')) return [];
    List<dynamic> splitList = splitsJson['member_splits'];
    return ExpenseSplit.converter(splitList.cast<Map<String, dynamic>>());
  }

  /// Fetch list of all [Expenses] objects from Rds.
  Future<List<Map<String, dynamic>>> fetchWeeklyExpenses({
    required String key,
    required String value,
    required String token,
    bool forceRefresh = false,
    bool useTestData = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'weekly_expenses',
      key: value,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          return jsonData.cast<Map<String, dynamic>>();
        } catch (e) {
          debugPrint(
              'Error decoding cached expenses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/expenses/this-week?key=$key&value=$value',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response['success'] != true) {
        throw ExpensesFailure.fromGet();
      }

      if (response['data'] == null) {
        throw ExpensesFailure.fromGet();
      }

      final List<dynamic> jsonData = response['data']!;

      // Success
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      return jsonData.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Failure to fetch all expenses: $e');
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

      // Failure
      if (response['success'] != true) {
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

      // Failure
      if (response['success'] != true) {
        throw ExpensesFailure.fromDelete();
      }

      // Ensure valid response
      return response['message']!;
    } catch (e) {
      debugPrint('Failure to delete expenses: $e');
      throw ExpensesFailure.fromGet();
    }
  }
}

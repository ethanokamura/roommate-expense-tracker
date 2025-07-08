import 'dart:convert';
import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'models/expenses.dart';
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
}

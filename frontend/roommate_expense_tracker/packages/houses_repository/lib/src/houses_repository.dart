import 'dart:convert';
import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'models/houses.dart';
import 'failures.dart';

/// Repository class for managing HousesRepository methods and data
class HousesRepository {
  /// Constructor for HousesRepository.
  HousesRepository({
    CacheManager? cacheManager,
  }) : _cacheManager = cacheManager ?? GetIt.instance<CacheManager>();

  final CacheManager _cacheManager;

  Houses _houses = Houses.empty;
  Houses get houses => _houses;

  List<Houses> _housesList = [];
  List<Houses> get housesList => _housesList;
}

extension Create on HousesRepository {
  /// Insert [Houses] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [Houses].
  ///
  /// Requires the [name] to create the object
  Future<Houses> createHouses({
    required String name,
    required String token,
    required String userId,
    bool forceRefresh = true,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'houses',
      'user_id': userId,
      Houses.nameConverter: name,
    });

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _houses = Houses.converterSingle(jsonData);
          return _houses;
        } catch (e) {
          debugPrint('Error decoding cached houses data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/houses/',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: {
          'name': name,
          'user_id': userId,
        },
      );
      if (response['success'] != true) {
        throw HousesFailure.fromCreate();
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

      _houses = Houses.converterSingle(jsonData);
      return _houses;
    } catch (e) {
      debugPrint('Failure to create houses: $e');
      throw HousesFailure.fromCreate();
    }
  }
}

extension Read on HousesRepository {
  /// Fetch list of all [Houses] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<List<Houses>> fetchAllHouses({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'object': 'houses',
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _housesList = Houses.converter(jsonData.cast<Map<String, dynamic>>());
          return _housesList;
        } catch (e) {
          debugPrint(
              'Error decoding cached houses list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = Houses.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/houses?sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response['success'] != true) {
        throw HousesFailure.fromGet();
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

      _housesList = Houses.converter(jsonData.cast<Map<String, dynamic>>());
      return _housesList;
    } catch (e) {
      debugPrint('Failure to fetch all houses: $e');
      throw HousesFailure.fromGet();
    }
  }

  /// Fetch single() [Houses] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Houses].
  ///
  /// Requires the [houseId] for lookup
  Future<Houses> fetchHousesWithHouseId({
    required String houseId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'houses',
      Houses.houseIdConverter: houseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _houses = Houses.converterSingle(jsonData);
          return _houses;
        } catch (e) {
          debugPrint('Error decoding cached houses data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/houses/$houseId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response['success'] != true) {
        throw HousesFailure.fromGet();
      }

      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _houses = Houses.converterSingle(jsonData);

      return _houses;
    } catch (e) {
      debugPrint('Failure to fetch houses with houseId: $e');
      throw HousesFailure.fromGet();
    }
  }
}

extension Update on HousesRepository {
  /// Update the given [Houses] in Rds.
  ///
  /// Return data if successful, or an empty instance of [Houses].
  ///
  /// Requires the [houseId] to update the object
  Future<Houses> updateHouses({
    required String houseId,
    required Houses newHousesData,
    required String token,
  }) async {
    try {
      // Get cache key
      final cacheKey = generateCacheKey({
        'object': 'houses',
        Houses.houseIdConverter: houseId,
      });
      // Prepare data for insertion
      final data = newHousesData.toJson();

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/houses/$houseId',
        method: 'PATCH',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: data,
      );

      // Failure
      if (response['success'] != true) {
        throw HousesFailure.fromGet();
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
      _houses = response['data'] != null
          ? Houses.converterSingle(jsonData!)
          : Houses.empty;

      // Return data
      return _houses;
    } catch (e) {
      debugPrint('Failure to update houses: $e');
      throw HousesFailure.fromGet();
    }
  }
}

extension Delete on HousesRepository {
  /// Delete the given [Houses] from Rds.
  ///
  /// Requires the [houseId] to delete the object
  Future<String> deleteHouses({
    required String houseId,
    required String token,
  }) async {
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/houses/$houseId',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Failure
      if (response['success'] != true) {
        throw HousesFailure.fromDelete();
      }

      // Ensure valid response
      return response['message']!;
    } catch (e) {
      debugPrint('Failure to delete houses: $e');
      throw HousesFailure.fromGet();
    }
  }
}

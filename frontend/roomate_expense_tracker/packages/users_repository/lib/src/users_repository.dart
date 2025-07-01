import 'dart:convert';
import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'models/users.dart';
import 'models/house_members.dart';
import 'failures.dart';

/// Repository class for managing UsersRepository methods and data
class UsersRepository {
  /// Constructor for UsersRepository.
  UsersRepository({
    CacheManager? cacheManager,
  }) : _cacheManager = cacheManager ?? GetIt.instance<CacheManager>();

  final CacheManager _cacheManager;

  Users _users = Users.empty;
  Users get users => _users;

  List<Users> _usersList = [];
  List<Users> get usersList => _usersList;
  HouseMembers _houseMembers = HouseMembers.empty;
  HouseMembers get houseMembers => _houseMembers;

  List<HouseMembers> _houseMembersList = [];
  List<HouseMembers> get houseMembersList => _houseMembersList;
}

extension Create on UsersRepository {
  /// Insert [Users] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [Users].
  ///
  /// Requires the [email] to create the object
  Future<Users> createUsers({
    required String email,
    required String token,
    bool forceRefresh = true,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'users',
      Users.emailConverter: email,
    });

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _users = Users.converterSingle(jsonData);
          return _users;
        } catch (e) {
          debugPrint('Error decoding cached users data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/users/',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: {
          'email': email,
        },
      );
      debugPrint('Users post response: $response');
      if (response['status'] != '201') {
        throw UsersFailure.fromCreate();
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

      _users = Users.converterSingle(jsonData);
      return _users;
    } catch (e) {
      debugPrint('Failure to create users: $e');
      throw UsersFailure.fromCreate();
    }
  }

  /// Insert [HouseMembers] object to Rds.
  ///
  /// Return data if successful, or an empty instance of [HouseMembers].
  ///
  /// Requires the [userId] to create the object
  /// Requires the [houseId] to create the object
  /// Requires the [isAdmin] to create the object
  /// Requires the [isActive] to create the object
  Future<HouseMembers> createHouseMembers({
    required String userId,
    required String houseId,
    required String isAdmin,
    required String isActive,
    required String token,
    bool forceRefresh = true,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'house_members',
      HouseMembers.userIdConverter: userId,
      HouseMembers.houseIdConverter: houseId,
      HouseMembers.isAdminConverter: isAdmin,
      HouseMembers.isActiveConverter: isActive,
    });

    // Check cache if not forcing refresh
    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _houseMembers = HouseMembers.converterSingle(jsonData);
          return _houseMembers;
        } catch (e) {
          debugPrint(
              'Error decoding cached houseMembers data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/house-members/',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: {
          'user_id': userId,
          'house_id': houseId,
          'is_admin': isAdmin,
          'is_active': isActive,
        },
      );
      debugPrint('Users post response: $response');
      if (response['status'] != '201') {
        throw UsersFailure.fromCreate();
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

      _houseMembers = HouseMembers.converterSingle(jsonData);
      return _houseMembers;
    } catch (e) {
      debugPrint('Failure to create houseMembers: $e');
      throw UsersFailure.fromCreate();
    }
  }
}

extension Read on UsersRepository {
  /// Fetch list of all [Users] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<List<Users>> fetchAllUsers({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'object': 'users',
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _usersList = Users.converter(jsonData.cast<Map<String, dynamic>>());
          return _usersList;
        } catch (e) {
          debugPrint(
              'Error decoding cached users list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = Users.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/users?sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Users GET all users response: $response');
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
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

      _usersList = Users.converter(jsonData.cast<Map<String, dynamic>>());
      return _usersList;
    } catch (e) {
      debugPrint('Failure to fetch all users: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Fetch single() [Users] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Users].
  ///
  /// Requires the [userId] for lookup
  Future<Users> fetchUsersWithUserId({
    required String userId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'users',
      Users.userIdConverter: userId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _users = Users.converterSingle(jsonData);
          return _users;
        } catch (e) {
          debugPrint('Error decoding cached users data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/users/$userId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Users GET response: $response');
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
      }

      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _users = Users.converterSingle(jsonData);

      return _users;
    } catch (e) {
      debugPrint('Failure to fetch users with userId: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Fetch single() [Users] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [Users].
  ///
  /// Requires the [email] for lookup
  Future<Users> fetchUsersWithEmail({
    required String email,
    required String token,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'users',
      Users.emailConverter: email,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _users = Users.converterSingle(jsonData);
          return _users;
        } catch (e) {
          debugPrint('Error decoding cached users data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{'email': email};
      final queryString =
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/users?$queryString',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Users GET response: $response');

      // Failure
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
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

      _users = Users.converterSingle(jsonData);

      return _users;
    } catch (e) {
      debugPrint('Failure to fetch users with unique details: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Fetch list of all [HouseMembers] objects from Rds.
  ///
  /// Return data if exists, or an empty list
  Future<List<HouseMembers>> fetchAllHouseMembers({
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'object': 'house_members',
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _houseMembersList =
              HouseMembers.converter(jsonData.cast<Map<String, dynamic>>());
          return _houseMembersList;
        } catch (e) {
          debugPrint(
              'Error decoding cached houseMembers list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = HouseMembers.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/house-members?sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Users GET all house_members response: $response');
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
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

      _houseMembersList =
          HouseMembers.converter(jsonData.cast<Map<String, dynamic>>());
      return _houseMembersList;
    } catch (e) {
      debugPrint('Failure to fetch all house_members: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Fetch single() [HouseMembers] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [HouseMembers].
  ///
  /// Requires the [houseMemberId] for lookup
  Future<HouseMembers> fetchHouseMembersWithHouseMemberId({
    required String houseMemberId,
    required String token,
    bool forceRefresh = false, // Added parameter to force API call
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'house_members',
      HouseMembers.houseMemberIdConverter: houseMemberId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _houseMembers = HouseMembers.converterSingle(jsonData);
          return _houseMembers;
        } catch (e) {
          debugPrint(
              'Error decoding cached houseMembers data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/house-members/$houseMemberId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Users GET response: $response');
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
      }

      final Map<String, dynamic> jsonData = response['data']!;
      final String responseBody = jsonEncode(jsonData);

      // Cache the successful response with a specific duration
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );

      _houseMembers = HouseMembers.converterSingle(jsonData);

      return _houseMembers;
    } catch (e) {
      debugPrint('Failure to fetch houseMembers with houseMemberId: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Fetch list of all [HouseMembers] objects from Rds.
  ///
  /// Requires the [userId] for lookup
  Future<List<HouseMembers>> fetchAllHouseMembersWithUserId({
    required String userId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'house_members',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'user_id': userId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _houseMembersList =
              HouseMembers.converter(jsonData.cast<Map<String, dynamic>>());
          return _houseMembersList;
        } catch (e) {
          debugPrint(
              'Error decoding cached houseMembers list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = HouseMembers.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/house-members?user_id=$userId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Users GET all house_members response: $response');
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
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

      _houseMembersList =
          HouseMembers.converter(jsonData.cast<Map<String, dynamic>>());
      return _houseMembersList;
    } catch (e) {
      debugPrint('Failure to fetch all house_members: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Fetch list of all [HouseMembers] objects from Rds.
  ///
  /// Requires the [houseId] for lookup
  Future<List<HouseMembers>> fetchAllHouseMembersWithHouseId({
    required String houseId,
    required String token,
    required String orderBy,
    required bool ascending,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'house_members',
      'order_by': orderBy,
      'ascending': ascending.toString(),
      'house_id': houseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _houseMembersList =
              HouseMembers.converter(jsonData.cast<Map<String, dynamic>>());
          return _houseMembersList;
        } catch (e) {
          debugPrint(
              'Error decoding cached houseMembers list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      if (orderBy.isEmpty) orderBy = HouseMembers.createdAtConverter;
      final ascendingQuery = ascending ? 'asc' : 'desc';
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint:
            '/house-members?house_id=$houseId&sort_by=$orderBy&sort_order=$ascendingQuery',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Users GET all house_members response: $response');
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
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

      _houseMembersList =
          HouseMembers.converter(jsonData.cast<Map<String, dynamic>>());
      return _houseMembersList;
    } catch (e) {
      debugPrint('Failure to fetch all house_members: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Fetch single() [HouseMembers] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [HouseMembers].
  ///
  /// Requires the [userId] for lookup
  Future<HouseMembers> fetchHouseMembersWithUserId({
    required String userId,
    required String token,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'house_members',
      HouseMembers.userIdConverter: userId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _houseMembers = HouseMembers.converterSingle(jsonData);
          return _houseMembers;
        } catch (e) {
          debugPrint(
              'Error decoding cached houseMembers data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{'user_id': userId};
      final queryString =
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/house-members?$queryString',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Users GET response: $response');

      // Failure
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
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

      _houseMembers = HouseMembers.converterSingle(jsonData);

      return _houseMembers;
    } catch (e) {
      debugPrint('Failure to fetch houseMembers with unique details: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Fetch single() [HouseMembers] object from Rds.
  ///
  /// Return data if exists, or an empty instance of [HouseMembers].
  ///
  /// Requires the [houseId] for lookup
  Future<HouseMembers> fetchHouseMembersWithHouseId({
    required String houseId,
    required String token,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'house_members',
      HouseMembers.houseIdConverter: houseId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _houseMembers = HouseMembers.converterSingle(jsonData);
          return _houseMembers;
        } catch (e) {
          debugPrint(
              'Error decoding cached houseMembers data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{'house_id': houseId};
      final queryString =
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/house-members?$queryString',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Users GET response: $response');

      // Failure
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
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

      _houseMembers = HouseMembers.converterSingle(jsonData);

      return _houseMembers;
    } catch (e) {
      debugPrint('Failure to fetch houseMembers with unique details: $e');
      throw UsersFailure.fromGet();
    }
  }
}

extension Update on UsersRepository {
  /// Update the given [Users] in Rds.
  ///
  /// Return data if successful, or an empty instance of [Users].
  ///
  /// Requires the [userId] to update the object
  Future<Users> updateUsers({
    required String userId,
    required Users newUsersData,
    required String token,
  }) async {
    try {
      // Get cache key
      final cacheKey = generateCacheKey({
        'object': 'users',
        Users.userIdConverter: userId,
      });
      // Prepare data for insertion
      final data = newUsersData.toJson();

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/users/$userId',
        method: 'PATCH',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: data,
      );

      debugPrint('Users PATCH response: $response');

      // Failure
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
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
      _users = response['data'] != null
          ? Users.converterSingle(jsonData!)
          : Users.empty;

      // Return data
      return _users;
    } catch (e) {
      debugPrint('Failure to update users: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Update the given [HouseMembers] in Rds.
  ///
  /// Return data if successful, or an empty instance of [HouseMembers].
  ///
  /// Requires the [houseMemberId] to update the object
  Future<HouseMembers> updateHouseMembers({
    required String houseMemberId,
    required HouseMembers newHouseMembersData,
    required String token,
  }) async {
    try {
      // Get cache key
      final cacheKey = generateCacheKey({
        'object': 'house_members',
        HouseMembers.houseMemberIdConverter: houseMemberId,
      });
      // Prepare data for insertion
      final data = newHouseMembersData.toJson();

      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/house-members/$houseMemberId',
        method: 'PATCH',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: data,
      );

      debugPrint('Users PATCH response: $response');

      // Failure
      if (response['status'] != '200') {
        throw UsersFailure.fromGet();
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
      _houseMembers = response['data'] != null
          ? HouseMembers.converterSingle(jsonData!)
          : HouseMembers.empty;

      // Return data
      return _houseMembers;
    } catch (e) {
      debugPrint('Failure to update houseMembers: $e');
      throw UsersFailure.fromGet();
    }
  }
}

extension Delete on UsersRepository {
  /// Delete the given [Users] from Rds.
  ///
  /// Requires the [userId] to delete the object
  Future<String> deleteUsers({
    required String userId,
    required String token,
  }) async {
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/users/$userId',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Users DELETE response: $response');

      // Failure
      if (response['status'] != '204') {
        throw UsersFailure.fromDelete();
      }

      // Ensure valid response
      return response['message']!;
    } catch (e) {
      debugPrint('Failure to delete users: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Delete the given [HouseMembers] from Rds.
  ///
  /// Requires the [houseMemberId] to delete the object
  Future<String> deleteHouseMembers({
    required String houseMemberId,
    required String token,
  }) async {
    try {
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/house-members/$houseMemberId',
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Users DELETE response: $response');

      // Failure
      if (response['status'] != '204') {
        throw UsersFailure.fromDelete();
      }

      // Ensure valid response
      return response['message']!;
    } catch (e) {
      debugPrint('Failure to delete houseMembers: $e');
      throw UsersFailure.fromGet();
    }
  }
}

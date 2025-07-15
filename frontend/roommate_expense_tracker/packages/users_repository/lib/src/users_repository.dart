import 'dart:convert';
import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:flutter/foundation.dart';
import 'models/users.dart';
import 'models/house_members.dart';
import 'failures.dart';

class UserHouseData {
  const UserHouseData({
    this.houseId = '',
    this.houseName = '',
    this.houseMemberId = '',
    this.isAdmin = false,
    this.memberNickName = '',
    this.houseCreatedAt,
    this.houseUpdatedAt,
    this.memberCreatedAt,
    this.memberUpdatedAt,
  });

  final String houseId;
  final String houseName;
  final String houseMemberId;
  final bool isAdmin;
  final String memberNickName;
  final DateTime? houseCreatedAt;
  final DateTime? houseUpdatedAt;
  final DateTime? memberCreatedAt;
  final DateTime? memberUpdatedAt;

  // JSON string equivalent for our data
  static String get houseIdConverter => 'house_id';
  static String get houseNameConverter => 'house_name';
  static String get houseMemberIdConverter => 'house_member_id';
  static String get isAdminConverter => 'is_admin';
  static String get memberNickNameConverter => 'member_nickname';
  static String get houseCreatedAtConverter => 'house_created_at';
  static String get houseUpdatedAtConverter => 'house_updated_at';
  static String get memberCreatedAtConverter => 'member_created_at';
  static String get memberUpdatedAtConverter => 'member_updated_at';

  // Helper function that converts a JSON object to our dart object
  factory UserHouseData.fromJson(Map<String, dynamic> json) {
    return UserHouseData(
      houseId: json[houseIdConverter]?.toString() ?? '',
      houseName: json[houseNameConverter]?.toString() ?? '',
      houseMemberId: json[houseMemberIdConverter]?.toString() ?? '',
      isAdmin: UserHouseData._parseBool(json[isAdminConverter]),
      memberNickName: json[memberNickNameConverter]?.toString() ?? '',
      houseCreatedAt: json[houseCreatedAtConverter] != null
          ? DateTime.tryParse(json[houseCreatedAtConverter].toString())
                  ?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      houseUpdatedAt: json[houseUpdatedAtConverter] != null
          ? DateTime.tryParse(json[houseUpdatedAtConverter].toString())
                  ?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      memberCreatedAt: json[memberCreatedAtConverter] != null
          ? DateTime.tryParse(json[memberCreatedAtConverter].toString())
                  ?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
      memberUpdatedAt: json[memberUpdatedAtConverter] != null
          ? DateTime.tryParse(json[memberUpdatedAtConverter].toString())
                  ?.toUtc() ??
              DateTime.now().toUtc()
          : DateTime.now().toUtc(),
    );
  }

  // Helper function that converts a list of SQL objects to a list of our dart objects
  static List<UserHouseData> converter(List<Map<String, dynamic>> data) {
    return data.map(UserHouseData.fromJson).toList();
  }

  // Helper function to safely parse boolean values, handling various input types
  static bool _parseBool(dynamic value) {
    if (value == null) {
      return false;
    }
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    if (value is int) {
      return value != 0;
    }
    return false;
  }
}

/// Repository class for managing UsersRepository methods and data
class UsersRepository {
  /// Constructor for UsersRepository.
  UsersRepository({
    CacheManager? cacheManager,
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
    Dio? dio,
  })  : _cacheManager = cacheManager ?? GetIt.instance<CacheManager>(),
        _googleSignIn = googleSignIn ?? GetIt.instance<GoogleSignIn>(),
        _firebaseAuth = firebaseAuth ?? GetIt.instance<FirebaseAuth>();
  final GoogleSignIn _googleSignIn; // Instance of Google Sign In
  final CacheManager _cacheManager; // Instance of the CacheManager
  final FirebaseAuth _firebaseAuth;

  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser;
  bool _isGoogleSignInInitialized = false;
  bool get authenticated => _currentUser != null;

  Users _users = Users.empty;
  Users get users => _users;
  UserCredential? _credentials;
  UserCredential get credentials => _credentials!;

  List<Users> _usersList = [];
  List<Users> get usersList => _usersList;
  HouseMembers _houseMembers = HouseMembers.empty;
  HouseMembers get houseMembers => _houseMembers;

  String _houseId = '';
  String get getHouseId => _houseId;

  List<HouseMembers> _houseMembersList = [];
  List<HouseMembers> get houseMembersList => _houseMembersList;

  List<UserHouseData> _userHousesList = [];
  List<UserHouseData> get userHousesList => _userHousesList;
}

extension Auth on UsersRepository {
  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      debugPrint('Failed to initialize Google Sign-In: $e');
      throw UsersFailure.fromSignIn();
    }
  }

  /// Always check Google sign in initialization before use
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      try {
        await _initializeGoogleSignIn();
      } catch (e) {
        debugPrint('Error during sign in: $e');
        throw UsersFailure.fromSignIn();
      }
    }
  }

  Future<void> signInWithGoogleFirebase() async {
    try {
      await _ensureGoogleSignInInitialized();

      // Authenticate with Google
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      // Get authorization for Firebase scopes if needed
      final authClient = _googleSignIn.authorizationClient;
      final authorization = await authClient.authorizationForScopes(['email']);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization?.accessToken,
        idToken: googleUser.authentication.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Update local state
      _currentUser = googleUser;

      // Store credentials
      _credentials = userCredential;

      if (userCredential.user != null) {
        final user = await fetchUsersWithEmail(
          email: userCredential.user!.email!,
          token: '',
        );
        debugPrint('found user: $user');
        if (user.isEmpty) {
          createUsers(
            displayName: userCredential.user!.displayName!,
            email: userCredential.user!.email!,
            token: '',
          );
        }
      }
    } catch (e) {
      debugPrint('Error during sign in: $e');
      throw UsersFailure.fromSignIn();
    }
  }

  /// Signs out the user from both Google and Firebase.
  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
      ]);
    } on Exception catch (e, st) {
      debugPrint('Error during signOut: $e, $st');
      throw UsersFailure.fromSignOut();
    }
  }
}

extension Create on UsersRepository {
  /// Insert [Users] object to Postgres.
  ///
  /// Return data if successful, or an empty instance of [Users].
  ///
  /// Requires the [email] to create the object
  Future<Users> createUsers({
    required String email,
    required String token,
    required String displayName,
    bool forceRefresh = true,
  }) async {
    debugPrint('creating a new user');
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
      debugPrint('Creating account for $displayName with email: $email');
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/users',
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $token',
        },
        payload: {
          Users.emailConverter: email,
          Users.displayNameConverter: displayName,
        },
      );
      debugPrint('Users post response: $response');
      if (response['success'] != true) {
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

  /// Insert [HouseMembers] object to Postgres.
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
  // Fetch user house ID
  Future<String> userHouseId({
    required String houseId,
    required String userId,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'user_house',
      'house_id': houseId,
      'user_id': userId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> data = jsonDecode(cachedData);
          final dynamic id = data['house_id'];
          debugPrint('House ID has been fetched from cache: $id');
          _houseId = id.toString();
          return _houseId;
        } catch (e) {
          debugPrint(
              'Error decoding cached users list data for key $cacheKey: $e');
        }
      }
    }
    final String responseBody = jsonEncode({
      'house_id': houseId,
    });

    // Cache the successful response
    await _cacheManager.cacheHttpResponse(
      key: cacheKey,
      responseBody: responseBody,
      cacheDuration: const Duration(minutes: 60),
    );
    debugPrint('House ID $houseId was cached');

    _houseId = houseId;
    return _houseId;
  }

  /// Fetch list of all [UserHouseData] objects from Postgres.
  ///
  /// Return data if exists, or an empty list
  Future<List<UserHouseData>> fetchUserHouseData({
    required String userId,
    required String token,
    bool forceRefresh = false,
  }) async {
    // Get cache key
    final cacheKey = generateCacheKey({
      'object': 'users_houses',
      'user_id': userId,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final List<dynamic> jsonData = jsonDecode(cachedData);
          _userHousesList =
              UserHouseData.converter(jsonData.cast<Map<String, dynamic>>());
          return _userHousesList;
        } catch (e) {
          debugPrint(
              'Error decoding cached users list data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      debugPrint('fetching users houses with userId $userId');
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/user-houses/$userId',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      debugPrint('Users GET all user houses response: $response');
      if (response['success'] != true) {
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

      _userHousesList =
          UserHouseData.converter(jsonData.cast<Map<String, dynamic>>());
      return _userHousesList;
    } catch (e) {
      debugPrint('Failure to fetch all user houses: $e');
      throw UsersFailure.fromGet();
    }
  }

  /// Fetch list of all [Users] objects from Postgres.
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

  /// Fetch single() [Users] object from Postgres.
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

  /// Fetch single() [Users] object from Postgres.
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
      debugPrint('finding user with email $email');
      // Retrieve new row after inserting
      final response = await dioRequest(
        dio: Dio(),
        apiEndpoint: '/users?email=$email',
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Users GET response: $response');

      // Failure
      if (response['success'] != true) {
        throw UsersFailure.fromGet();
      }

      if ((response['data']! as List<dynamic>).isEmpty) {
        return Users.empty;
      }

      // Success
      final Map<String, dynamic> jsonData =
          (response['data']! as List<dynamic>).first;
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

  /// Fetch list of all [HouseMembers] objects from Postgres.
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

  /// Fetch single() [HouseMembers] object from Postgres.
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

  /// Fetch list of all [HouseMembers] objects from Postgres.
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

  /// Fetch list of all [HouseMembers] objects from Postgres.
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

  /// Fetch single() [HouseMembers] object from Postgres.
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

  /// Fetch single() [HouseMembers] object from Postgres.
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
  /// Update the given [Users] in Postgres.
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

  /// Update the given [HouseMembers] in Postgres.
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
  /// Delete the given [Users] from Postgres.
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

  /// Delete the given [HouseMembers] from Postgres.
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

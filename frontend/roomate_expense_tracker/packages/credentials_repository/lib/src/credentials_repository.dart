import 'dart:convert'; // Import for jsonEncode and jsonDecode

import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:credentials_repository/src/models/credentials.dart';
import 'package:flutter/foundation.dart';
import 'failures.dart';

/// Repository class for managing CredentialsRepository methods and data
class CredentialsRepository {
  /// Constructor for CredentialsRepository.
  /// If [cacheManager] is not provided, use the default CacheManager instance.
  CredentialsRepository({
    CacheManager? cacheManager, // Allow injecting CacheManager for testing
    Dio? dio,
  })  : _cacheManager = cacheManager ?? GetIt.instance<CacheManager>(),
        _dio = dio ?? Dio();
  final CacheManager _cacheManager; // Instance of the CacheManager
  final Dio _dio; // Instance of the Dio

  // Private members
  Credentials _credentials = Credentials.empty;
  bool _authenticated = false;
  String _wineryId = '';
  String _userEmail = '';

  // Public getters
  String get wineryId => _wineryId;
  String get userEmail => _userEmail;
  bool get authenticated => _authenticated;
  Credentials get credentials => _credentials;

  Future<Credentials> fetchCredentials({
    required String grantType,
    required String code,
    required String redirectUri,
    bool forceRefresh = false,
  }) async {
    final cacheKey = generateCacheKey({
      'object': 'credentials',
      'grant_type': grantType,
      'code': code,
      'redirect_uri': redirectUri,
    });

    if (!forceRefresh) {
      final cachedData = await _cacheManager.getCachedHttpResponse(cacheKey);
      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          _credentials = Credentials.fromJson(jsonData);
          decodeJwtToken(token: _credentials.idToken);
          if (!_credentials.isEmpty) _authenticated = true;
          return _credentials;
        } catch (e) {
          debugPrint(
              'Error decoding cached wineClubs data for key $cacheKey: $e');
        }
      }
    }

    // No valid cache, or forceRefresh is true, fetch from API
    try {
      final response = await dioRequest(
        dio: _dio,
        apiEndpoint:
            'https://winery-app-domain.auth.us-west-2.amazoncognito.com/oauth2/token',
        method: 'POST',
        contentType: 'application/x-www-form-urlencoded',
        headers: {
          'Authorization':
              'Basic NjBpZjNhbGNkMGNqbWozZWs4Z3V2bzNzZTk6MWkwNTJubjliaDczcmI2azY0bWc4dWhhbTdxMWlmamUwcTVxb3FhdjVrazhrcm1wbTdzYw==',
        },
        payload: {
          'grant_type': grantType,
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      if (response.containsKey('failure')) {
        throw CredentialsFailure.fromGet();
      }

      final String responseBody = jsonEncode(response);

      // Cache the successful response
      await _cacheManager.cacheHttpResponse(
        key: cacheKey,
        responseBody: responseBody,
        cacheDuration: const Duration(minutes: 60),
      );
      _credentials = Credentials.fromJson(response);
      decodeJwtToken(token: _credentials.idToken);
      if (!_credentials.isEmpty) _authenticated = true;
      return _credentials;
    } catch (e) {
      throw CredentialsFailure.fromGet();
    }
  }

  /// Verifies user auth
  Future<bool> checkAuthAndAdmin() async {
    try {
      // Ensure correct response status.
      return _authenticated && !_credentials.isEmpty;
    } catch (e) {
      throw CredentialsFailure.fromAuthChanges();
    }
  }

  void decodeJwtToken({
    required String token,
  }) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    // _wineryId = decodedToken['tenant_id'];
    _wineryId = '7e470736-6dbe-400d-aba9-07851c24cdfc';
    _userEmail = decodedToken['email'];
  }
}

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'models/cached_http_response.dart';

class CacheManager {
  /// Constructor for [CacheManager]. Requires an initialized Isar instance.
  CacheManager(this._isar);

  final Isar _isar;

  // --- Configuration for Cache Durations ---
  /// Default duration for HTTP response caches.
  static const Duration _defaultHttpCacheExpiration = Duration(hours: 6);

  // --- HTTP Response Caching Methods ---

  /// Stores an HTTP response in the cache.
  /// [key]: The unique identifier for the cached response (e.g., API endpoint URL).
  /// [responseBody]: The JSON string representation of the HTTP response.
  /// [cacheDuration]: Optional. Overrides the default HTTP cache duration for this specific entry.
  Future<void> cacheHttpResponse({
    required String key,
    required String responseBody,
    Duration? cacheDuration,
  }) async {
    await _isar.writeTxn(() async {
      final cachedEntry = CachedHttpResponse.fromResponse(
        key: key,
        responseBody: responseBody,
        cacheDuration: _defaultHttpCacheExpiration,
      );
      await _isar.cachedHttpResponses.put(cachedEntry);
    });
  }

  /// Retrieves a cached HTTP response by key.
  /// Returns the data string if found and not expired, otherwise null.
  Future<String?> getCachedHttpResponse(String key) async {
    final entry =
        await _isar.cachedHttpResponses.filter().keyEqualTo(key).findFirst();

    if (entry != null) {
      final now = DateTime.now().toUtc();
      if (entry.expiresAt == null || entry.expiresAt!.isAfter(now)) {
        return entry.data;
      } else {
        await _isar.writeTxn(() async {
          await _isar.cachedHttpResponses
              .delete(entry.id); // Delete expired entry
        });
        return null;
      }
    }
    return null;
  }

  /// Deletes a specific cached HTTP response by key.
  /// Useful for invalidating cache after CUD operations (Create, Update, Delete) on the server.
  Future<void> deleteCachedHttpResponse(String key) async {
    await _isar.writeTxn(() async {
      final count =
          await _isar.cachedHttpResponses.filter().keyEqualTo(key).deleteAll();
      if (count > 0) {
        debugPrint(
            'CacheManager: Deleted $count cached HTTP response(s) for key: $key');
      } else {
        debugPrint(
            'CacheManager: No cached HTTP response found to delete for key: $key');
      }
    });
  }

  // --- General Cache Cleanup (only for CachedHttpResponse) ---

  /// Performs cleanup on the CachedHttpResponse collection.
  /// It removes entries older than their configured HTTP cache duration or past their explicit `expiresAt`.
  /// This should ideally be called periodically (e.g., app start, background fetch).
  Future<void> cleanupAllCaches() async {
    final httpThreshold =
        DateTime.now().toUtc().subtract(_defaultHttpCacheExpiration);

    try {
      await _isar.writeTxn(() async {
        // final httpCacheCount =
        await _isar.cachedHttpResponses
            .filter()
            .cachedAtLessThan(httpThreshold)
            .or()
            .expiresAtLessThan(DateTime.now().toUtc())
            .deleteAll();
      });
    } catch (e) {
      debugPrint('CacheManager: Error during overall cache cleanup: $e');
    }
  }

  /// Clears ALL data from ALL Isar collections. Use with extreme caution!
  /// In your case, this will only clear the CachedHttpResponse collection.
  Future<void> clearAllData() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.cachedHttpResponses.clear();
      });
      debugPrint('CacheManager: All Isar data cleared.');
    } catch (e) {
      debugPrint('CacheManager: Error clearing all Isar data: $e');
    }
  }
}

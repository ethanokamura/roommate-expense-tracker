import 'package:flutter/foundation.dart';

String generateCacheKey(Map<String, String> keys) {
  String cacheKey = '${keys.keys.toList()[0]}_${keys.values.toList()[0]}';
  for (int i = 1; i < keys.length; i++) {
    cacheKey += '_${keys.keys.toList()[i]}_${keys.values.toList()[i]}';
  }
  debugPrint('cacheKey: $cacheKey');
  return cacheKey;
}

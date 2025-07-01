import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Custom Exception for structured errors from the backend.
/// This allows you to differentiate between network errors and
/// known backend application errors.
class BackendException implements Exception {
  final String message;
  final int? statusCode;
  final String? code; // Optional: A specific error code from your backend

  BackendException(this.message, {this.statusCode, this.code});

  @override
  String toString() {
    String status = statusCode != null ? ' (Status: $statusCode)' : '';
    String errorCode = code != null ? ' (Code: $code)' : '';
    return 'BackendException: $message$status$errorCode';
  }
}

/// Executes an HTTP request to the backend using Dio.
///
/// Throws:
/// - `BackendException`: For errors where the server responded with a non-2xx
///   status code, and the error details could be parsed from the response body.
/// - `DioException`: For network errors (e.g., connection issues, timeouts),
///   or unparsable server responses.
/// - `ArgumentError`: If an unsupported HTTP method is provided.
///
/// Returns:
/// - `Future<Map<String, dynamic>>`: The parsed JSON response data on success.
Future<Map<String, dynamic>> dioRequest({
  required Dio dio,
  required String method,
  required String apiEndpoint,
  String? contentType,
  Map<String, String> headers = const {}, // Renamed from 'head' for clarity
  Map<String, dynamic>?
      payload, // Made nullable as payload might not always be needed (e.g. GET without params)
}) async {
  // Use 'required' for payload if it's strictly needed for all methods.
  // For GET, queryParameters handles it; for POST/DELETE, 'data' handles it.
  // Using const {} for default payload can cause issues if it's modified.
  // It's better to default to null and handle it.
  payload ??=
      {}; // Initialize if null for safety, especially with queryParameters

  const host = String.fromEnvironment('HOST', defaultValue: 'localhost:3001');
  final url =
      apiEndpoint.contains('http://') || apiEndpoint.contains('https://')
          ? apiEndpoint
          : 'http://$host$apiEndpoint';

  // Combine default and provided headers
  final Map<String, String> requestHeaders = {
    'Content-Type': contentType ?? 'application/json; charset=UTF-8',
  };
  requestHeaders.addAll(headers);

  // Dio options for timeouts and headers
  final Options requestOptions = Options(
    headers: requestHeaders,
    sendTimeout: const Duration(seconds: 10), // Adjust as needed
    receiveTimeout: const Duration(seconds: 30), // Adjust as needed
  );

  try {
    Response<dynamic> response;
    // Use uppercase method names for strict matching and clarity
    switch (method.toUpperCase()) {
      case 'GET':
        response = await dio.get(
          url,
          queryParameters: payload, // GET uses queryParameters
          options: requestOptions,
        );
        break; // Added break
      case 'POST':
        response = await dio.post(
          url,
          data: payload, // POST uses data
          options: requestOptions,
        );
        break; // Added break
      case 'DELETE':
        response = await dio.delete(
          url,
          data: payload, // DELETE often uses data for body
          options: requestOptions,
        );
        break; // Added break
      case 'PUT': // Added PUT for completeness, often used in REST
        response = await dio.put(
          url,
          data: payload,
          options: requestOptions,
        );
        break;
      case 'PATCH': // Added PATCH for completeness
        response = await dio.patch(
          url,
          data: payload,
          options: requestOptions,
        );
        break;
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }

    // Dio typically throws for non-2xx status codes by default.
    // If it reaches here, it implies a 2xx status code.
    if (response.data is Map<String, dynamic>) {
      // You can add a check here if your backend always returns {'success': true, ...} for 2xx responses
      // and {'success': false, 'error': ...} for specific application-level errors even with 200 OK.
      // If your backend *can* return a success status (e.g., 200) but indicate an *application error*
      // within the body (e.g., {'success': false, 'message': 'Validation failed'}),
      // you should handle that here and throw a BackendException.
      if (response.data.containsKey('success') &&
          response.data['success'] == false) {
        throw BackendException(
          response.data['message'] ?? 'An unknown backend error occurred.',
          statusCode: response.statusCode,
          code: response.data['code']
              as String?, // Assuming 'code' might be a key
        );
      }
      return response.data as Map<String, dynamic>;
    } else {
      // Handle cases where response.data is not a Map (e.g., String, List, null)
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Unexpected response data format: ${response.data.runtimeType}',
        message: 'Response data is not a JSON object.',
      );
    }
  } on DioException catch (e) {
    // --- Specific Dio error handling ---
    String errorMessage;
    if (e.response != null) {
      // Server responded with a status code other than 2xx
      debugPrint(
          'Dio Bad Response Error: Status ${e.response?.statusCode}, Data: ${e.response?.data}');
      // Attempt to parse structured error from backend
      try {
        final errorData = e.response!.data as Map<String, dynamic>?;
        if (errorData != null && errorData.containsKey('message')) {
          errorMessage = errorData['message']
              as String; // Assuming 'message' is the key for error string
        } else if (errorData != null && errorData.containsKey('error')) {
          errorMessage = errorData['error'] as String; // Common alternative key
        } else {
          errorMessage = e.response!.statusMessage ??
              'Server responded with status ${e.response!.statusCode}';
        }
        // Throw a specific BackendException if it's a structured error from your app
        throw BackendException(
          errorMessage,
          statusCode: e.response!.statusCode,
          // You might add an 'error_code' from your backend here if applicable
          // code: errorData?['code'] as String?,
        );
      } catch (parseError) {
        // Fallback if response data is not a Map or unexpected
        errorMessage =
            'Server error (${e.response!.statusCode}): ${e.response!.statusMessage ?? 'Unknown error'}. Raw response: ${e.response!.data}';
      }
    } else {
      // Network errors (no response from server)
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          errorMessage = 'Connection timed out. Please check your network.';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'No internet connection. Please check your network.';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request cancelled.';
          break;
        default:
          errorMessage = 'An unexpected network error occurred: ${e.message}';
          break;
      }
    }
    // Re-throw the original DioException or a custom exception wrapping it
    // so the caller can handle it specifically.
    // If you want all errors to be `BackendException` and hide `DioException`:
    // throw BackendException(errorMessage, statusCode: e.response?.statusCode);
    // Otherwise, rethrow the DioException
    rethrow; // Re-throwing the DioException for specific handling by the caller
  } catch (e) {
    // Catch any other unexpected errors (e.g., Dart runtime errors)
    debugPrint('Unhandled error in dioRequest: $e');
    throw Exception('An unexpected error occurred: $e');
  }
}

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

/// Define a typedef for your dioRequest function signature.
/// This is crucial for mocking the function itself.
typedef DioRequestFunction = Future<Map<String, dynamic>> Function({
  required Dio dio,
  required String apiEndpoint,
  required String method,
  String? contentType,
  Map<String, String> headers,
  Map<String, dynamic>? payload,
});

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
  Map<String, String> headers = const {},
  Map<String, dynamic>? payload,
}) async {
  payload ??= {};

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
          queryParameters: payload,
          options: requestOptions,
        );
        break;
      case 'POST':
        response = await dio.post(
          url,
          data: payload,
          options: requestOptions,
        );
        break;
      case 'DELETE':
        response = await dio.delete(
          url,
          data: payload,
          options: requestOptions,
        );
        break;
      case 'PUT':
        response = await dio.put(
          url,
          data: payload,
          options: requestOptions,
        );
        break;
      case 'PATCH':
        response = await dio.patch(
          url,
          data: payload,
          options: requestOptions,
        );
        break;
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }
    if (response.data is Map<String, dynamic>) {
      if (response.data.containsKey('success') &&
          response.data['success'] == false) {
        throw BackendException(
          response.data['message'] ?? 'An unknown backend error occurred.',
          statusCode: response.statusCode,
          code: response.data['code'] as String?,
        );
      }
      return response.data as Map<String, dynamic>;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Unexpected response data format: ${response.data.runtimeType}',
        message: 'Response data is not a JSON object.',
      );
    }
  } on DioException catch (e) {
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
    rethrow;
  } catch (e) {
    debugPrint('Unhandled error in dioRequest: $e');
    throw Exception('An unexpected error occurred: $e');
  }
}

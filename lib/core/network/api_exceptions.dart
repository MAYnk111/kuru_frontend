import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: 'Connection timed out. Please check if the FastAPI server is running.',
          statusCode: 408,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Send timed out. Please check your network connection.',
          statusCode: 408,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Receive timed out waiting for server response.',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        final statusCode = dioException.response?.statusCode;
        final responseData = dioException.response?.data;
        String errorMessage = 'Server responded with status $statusCode';

        if (responseData is Map && responseData.containsKey('detail')) {
          errorMessage = responseData['detail'].toString();
        } else if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'].toString();
        }

        return ApiException(
          message: errorMessage,
          statusCode: statusCode,
          data: responseData,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled.');
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Cannot reach backend server. Ensure the FastAPI backend is running.',
          statusCode: 503,
        );
      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: dioException.message ?? 'An unexpected network error occurred.',
        );
    }
  }

  @override
  String toString() => message;
}

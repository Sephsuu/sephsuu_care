import 'api_exception.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
  });

  factory ApiResponse.fromJson(
    dynamic json,
    T Function(dynamic data) fromData,
  ) {
    if (json is! Map<String, dynamic>) {
      throw const ApiException(message: 'Invalid API response');
    }

    return ApiResponse<T>(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] == null ? null : fromData(json['data']),
      errors: _parseErrors(json['errors']),
    );
  }

  T requireData({int? statusCode}) {
    if (!success) {
      throw ApiException(
        message: message.isEmpty ? 'Request failed' : message,
        statusCode: statusCode,
        errors: errors,
      );
    }

    final responseData = data;
    if (responseData == null) {
      throw ApiException(
        message: message.isEmpty ? 'Response data is missing' : message,
        statusCode: statusCode,
        errors: errors,
      );
    }

    return responseData;
  }

  static Map<String, dynamic>? _parseErrors(dynamic errors) {
    if (errors is Map<String, dynamic>) return errors;
    if (errors is Map) return Map<String, dynamic>.from(errors);
    return null;
  }
}

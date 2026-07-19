import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_exception.dart';
import 'api_response.dart';

enum RequestMethod { get, post, put, patch, delete }

class ApiClient {
  static const String defaultBaseUrl = String.fromEnvironment(
    'FASTAPI_API_URL',
    defaultValue: 'https://r0kpvj1t-8000.asse.devtunnels.ms/api',
  );

  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  ApiClient({Dio? dio, FlutterSecureStorage? secureStorage})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: _normalizeBaseUrl(defaultBaseUrl),
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
            ),
          ),
      _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<T> request<T>({
    required String path,
    required RequestMethod method,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool withAuth = true,
    T Function(dynamic data)? fromJson,
    Future<void> Function()? onUnauthorized,
    Future<void> Function()? onForbidden,
  }) async {
    try {
      final requestHeaders = <String, dynamic>{...?headers};
      final requestMethod = _methodToString(method);

      if (withAuth) {
        final accessToken = await _secureStorage.read(key: 'access_token');

        if (accessToken != null && accessToken.isNotEmpty) {
          requestHeaders['Authorization'] = 'Bearer $accessToken';
        }
      }

      final resolvedPath = _resolvePath(path);

      _logRequest(
        path: resolvedPath,
        method: requestMethod,
        body: body,
        headers: requestHeaders,
        queryParameters: queryParameters,
      );

      final response = await _dio.request(
        resolvedPath,
        data: body,
        queryParameters: queryParameters,
        options: Options(method: requestMethod, headers: requestHeaders),
      );

      _logResponse(response);

      if (fromJson != null) {
        return fromJson(response.data);
      }

      return response.data as T;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      _logErrorResponse(error);

      if (statusCode == 401) {
        if (onUnauthorized != null) {
          await onUnauthorized();
        }

        throw ApiException(
          message: 'Unauthorized',
          statusCode: 401,
          payload: data,
        );
      }

      if (statusCode == 403) {
        if (onForbidden != null) {
          await onForbidden();
        }

        throw ApiException(
          message: 'Forbidden',
          statusCode: 403,
          payload: data,
        );
      }

      throw ApiException(
        message: _getDioErrorMessage(error),
        statusCode: statusCode,
        payload: data,
        errors: _getErrors(data),
      );
    }
  }

  Future<T> requestData<T>({
    required String path,
    required RequestMethod method,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool withAuth = true,
    required T Function(dynamic data) fromJson,
    Future<void> Function()? onUnauthorized,
    Future<void> Function()? onForbidden,
  }) async {
    final response = await request<ApiResponse<T>>(
      path: path,
      method: method,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      withAuth: withAuth,
      fromJson: (data) => ApiResponse<T>.fromJson(data, fromJson),
      onUnauthorized: onUnauthorized,
      onForbidden: onForbidden,
    );

    return response.requireData();
  }

  Future<T> graphql<T>({
    required String query,
    Map<String, dynamic>? variables,
    Map<String, dynamic>? headers,
    bool withAuth = true,
    required T Function(dynamic data) fromJson,
    Future<void> Function()? onUnauthorized,
    Future<void> Function()? onForbidden,
  }) async {
    final body = <String, dynamic>{'query': query};
    if (variables != null) body['variables'] = variables;

    final response = await request<Map<String, dynamic>>(
      path: '',
      method: RequestMethod.post,
      body: body,
      headers: headers,
      withAuth: withAuth,
      fromJson: (data) => Map<String, dynamic>.from(data as Map),
      onUnauthorized: onUnauthorized,
      onForbidden: onForbidden,
    );

    final errors = response['errors'];
    if (errors is List && errors.isNotEmpty) {
      throw ApiException(
        message: _getGraphqlErrorMessage(errors),
        statusCode: 200,
        payload: response,
        errors: {'graphql': errors},
      );
    }

    final data = response['data'];
    if (data == null) {
      throw ApiException(
        message: 'GraphQL response data is missing',
        statusCode: 200,
        payload: response,
      );
    }

    return fromJson(data);
  }

  String _methodToString(RequestMethod method) {
    switch (method) {
      case RequestMethod.get:
        return 'GET';
      case RequestMethod.post:
        return 'POST';
      case RequestMethod.put:
        return 'PUT';
      case RequestMethod.patch:
        return 'PATCH';
      case RequestMethod.delete:
        return 'DELETE';
    }
  }

  String _resolvePath(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return path.startsWith('/') ? path.substring(1) : path;
  }

  static String _normalizeBaseUrl(String baseUrl) {
    final uri = Uri.parse(baseUrl);

    if (uri.hasScheme && uri.path.isEmpty) {
      return uri.replace(path: '/api/').toString();
    }

    return baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
  }

  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
    String? tokenType,
    int? expiresIn,
  }) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);

    if (tokenType != null) {
      await _secureStorage.write(key: 'token_type', value: tokenType);
    }

    if (expiresIn != null) {
      await _secureStorage.write(
        key: 'expires_in',
        value: expiresIn.toString(),
      );
    }
  }

  Future<void> clearAuthTokens() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    await _secureStorage.delete(key: 'token_type');
    await _secureStorage.delete(key: 'expires_in');
  }

  void _logRequest({
    required String path,
    required String method,
    dynamic body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    final uri = _dio.options.baseUrl.isEmpty
        ? Uri.parse(path)
        : Uri.parse(_dio.options.baseUrl).resolve(path);
    final resolvedUri = queryParameters == null || queryParameters.isEmpty
        ? uri
        : uri.replace(
            queryParameters: {
              ...uri.queryParameters,
              ...queryParameters.map(
                (key, value) => MapEntry(key, value?.toString()),
              ),
            },
          );

    debugPrint('API URL: $resolvedUri');
    debugPrint('API METHOD: $method');
    debugPrint('API HEADERS: $headers');
    debugPrint('API BODY: $body');
  }

  void _logResponse(Response<dynamic> response) {
    debugPrint('API STATUS: ${response.statusCode}');
    debugPrint('API RES: ${response.data}');
  }

  void _logErrorResponse(DioException error) {
    debugPrint('API ERROR TYPE: ${error.type}');
    debugPrint('API ERROR MESSAGE: ${error.message}');
    debugPrint('API STATUS: ${error.response?.statusCode}');
    debugPrint('API RES: ${error.response?.data}');
  }

  String _getErrorMessage(dynamic data, int? statusCode) {
    if (data is Map<String, dynamic>) {
      if (data['detail'] != null) {
        return data['detail'].toString();
      }

      if (data['message'] != null) {
        return data['message'].toString();
      }
    }

    return 'Request failed${statusCode != null ? ' ($statusCode)' : ''}';
  }

  String _getDioErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data != null) return _getErrorMessage(data, statusCode);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Unable to connect to the server. Check if the API is running and reachable from this device.';
      case DioExceptionType.receiveTimeout:
        return 'The server took too long to respond.';
      case DioExceptionType.sendTimeout:
        return 'The request took too long to send.';
      case DioExceptionType.transformTimeout:
        return 'The response took too long to process.';
      case DioExceptionType.connectionError:
        return 'Network connection failed. Check the API URL and your connection.';
      case DioExceptionType.badCertificate:
        return 'Server certificate is invalid.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return error.message ?? 'Request failed';
    }
  }

  Map<String, dynamic>? _getErrors(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) return errors;
      if (errors is Map) return Map<String, dynamic>.from(errors);
    }

    return null;
  }

  String _getGraphqlErrorMessage(List<dynamic> errors) {
    final firstError = errors.first;

    if (firstError is Map<String, dynamic>) {
      final message = firstError['message'];
      if (message != null) return message.toString();
    }

    return 'GraphQL request failed';
  }
}

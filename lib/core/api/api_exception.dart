class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic payload;
  final Map<String, dynamic>? errors;

  const ApiException({
    required this.message,
    this.statusCode,
    this.payload,
    this.errors,
  });

  @override
  String toString() {
    return message;
  }
}

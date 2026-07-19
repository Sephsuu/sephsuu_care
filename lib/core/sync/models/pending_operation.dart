class PendingOperation {
  final String id;
  final String type;
  final String method;
  final String endpoint;
  final Map<String, dynamic> body;
  final DateTime createdAt;

  PendingOperation({
    required this.id,
    required this.type,
    required this.method,
    required this.endpoint,
    required this.body,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'method': method,
      'endpoint': endpoint,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PendingOperation.fromJson(Map<String, dynamic> json) {
    return PendingOperation(
      id: json['id'],
      type: json['type'],
      method: json['method'],
      endpoint: json['endpoint'],
      body: Map<String, dynamic>.from(json['body']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
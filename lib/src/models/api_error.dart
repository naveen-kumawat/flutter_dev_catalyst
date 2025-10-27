import 'package:equatable/equatable.dart';

/// API Error model
class ApiError extends Equatable {
  final String message;
  final String? code;
  final int? statusCode;
  final Map<String, dynamic>? details;
  final DateTime timestamp;

  const ApiError({
    required this.message,
    this.code,
    this.statusCode,
    this.details,
    required this.timestamp,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['message'] ?? json['error'] ?? 'Unknown error',
      code: json['code'],
      statusCode: json['statusCode'] ?? json['status_code'],
      details: json['details'],
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      'statusCode': statusCode,
      'details': details,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [message, code, statusCode, details, timestamp];

  @override
  String toString() {
    return 'ApiError(message: $message, code: $code, statusCode: $statusCode)';
  }
}

import 'package:equatable/equatable.dart';

/// Generic API Response wrapper
class ApiResponse<T> extends Equatable {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool success;
  final dynamic error;
  final Map<String, dynamic>? metadata;

  const ApiResponse({
    this.data,
    this.message,
    this.statusCode,
    required this.success,
    this.error,
    this.metadata,
  });

  /// Success response
  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      data: data,
      message: message ?? 'Success',
      statusCode: statusCode ?? 200,
      success: true,
      metadata: metadata,
    );
  }

  /// Error response
  factory ApiResponse.error({
    String? message,
    int? statusCode,
    dynamic error,
    Map<String, dynamic>? metadata,
  }) {
    return ApiResponse<T>(
      message: message ?? 'An error occurred',
      statusCode: statusCode ?? 500,
      success: false,
      error: error,
      metadata: metadata,
    );
  }

  /// Check if response has data
  bool get hasData => data != null;

  /// Check if response is error
  bool get isError => !success;

  @override
  List<Object?> get props => [
    data,
    message,
    statusCode,
    success,
    error,
    metadata,
  ];

  @override
  String toString() {
    return 'ApiResponse(success: $success, statusCode: $statusCode, message: $message, data: $data)';
  }
}

/// Pagination meta data
class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'] ?? json['current_page'] ?? 1,
      totalPages: json['totalPages'] ?? json['total_pages'] ?? 1,
      totalItems: json['totalItems'] ?? json['total_items'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? json['items_per_page'] ?? 10,
      hasNextPage: json['hasNextPage'] ?? json['has_next_page'] ?? false,
      hasPreviousPage:
          json['hasPreviousPage'] ?? json['has_previous_page'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }
}

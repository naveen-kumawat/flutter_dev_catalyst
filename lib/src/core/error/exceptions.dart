/// Base exception class
class CatalystException implements Exception {
  final String message;
  final String? code;
  final dynamic details;
  final StackTrace? stackTrace;

  CatalystException({
    required this.message,
    this.code,
    this.details,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'CatalystException: $message ${code != null ? '(Code: $code)' : ''}';
  }
}

/// Network Exception
class NetworkException extends CatalystException {
  NetworkException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

/// Server Exception
class ServerException extends CatalystException {
  final int? statusCode;

  ServerException({
    required super.message,
    this.statusCode,
    super.code,
    super.details,
    super.stackTrace,
  });

  @override
  String toString() {
    return 'ServerException: $message ${statusCode != null ? '(Status: $statusCode)' : ''} ${code != null ? '(Code: $code)' : ''}';
  }
}

/// Cache Exception
class CacheException extends CatalystException {
  CacheException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

/// Storage Exception
class StorageException extends CatalystException {
  StorageException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

/// Authentication Exception
class AuthenticationException extends CatalystException {
  AuthenticationException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

/// Authorization Exception
class AuthorizationException extends CatalystException {
  AuthorizationException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

/// Validation Exception
class ValidationException extends CatalystException {
  final Map<String, List<String>>? errors;

  ValidationException({
    required super.message,
    this.errors,
    super.code,
    super.details,
    super.stackTrace,
  });

  @override
  String toString() {
    return 'ValidationException: $message ${errors != null ? '\nErrors: $errors' : ''}';
  }
}

/// Timeout Exception
class TimeoutException extends CatalystException {
  TimeoutException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

/// Parse Exception
class ParseException extends CatalystException {
  ParseException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

/// Not Found Exception
class NotFoundException extends CatalystException {
  NotFoundException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

/// Conflict Exception
class ConflictException extends CatalystException {
  ConflictException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

/// Rate Limit Exception
class RateLimitException extends CatalystException {
  final DateTime? retryAfter;

  RateLimitException({
    required super.message,
    this.retryAfter,
    super.code,
    super.details,
    super.stackTrace,
  });

  @override
  String toString() {
    return 'RateLimitException: $message ${retryAfter != null ? '(Retry after: $retryAfter)' : ''}';
  }
}

/// Unknown Exception
class UnknownException extends CatalystException {
  UnknownException({
    required super.message,
    super.code,
    super.details,
    super.stackTrace,
  });
}

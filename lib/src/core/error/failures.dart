import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure({required this.message, this.code, this.details});

  @override
  List<Object?> get props => [message, code, details];
}

/// Server Failure
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, statusCode, code, details];
}

/// Network Failure
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code, super.details});
}

/// Cache Failure
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code, super.details});
}

/// Storage Failure
class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code, super.details});
}

/// Validation Failure
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    required super.message,
    this.errors,
    super.code,
    super.details,
  });

  @override
  List<Object?> get props => [message, errors, code, details];
}

/// Authentication Failure
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Authorization Failure
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Not Found Failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code, super.details});
}

/// Timeout Failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message, super.code, super.details});
}

/// Unknown Failure
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.code, super.details});
}

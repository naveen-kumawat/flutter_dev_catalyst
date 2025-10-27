import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';
import '../../utils/logger/catalyst_logger.dart';

/// Error Handler for converting exceptions to failures
class ErrorHandler {
  static final CatalystLogger _logger = CatalystLogger();

  /// Handle error and convert to failure
  static Failure handleError(dynamic error) {
    _logger.error('Handling error: $error');

    if (error is CatalystException) {
      return _handleCatalystException(error);
    } else if (error is DioException) {
      return _handleDioException(error);
    } else {
      return UnknownFailure(message: error.toString(), details: error);
    }
  }

  /// Handle Catalyst exceptions
  static Failure _handleCatalystException(CatalystException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is CacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is StorageException) {
      return StorageFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is AuthenticationException) {
      return AuthenticationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is AuthorizationException) {
      return AuthorizationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        errors: exception.errors,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else if (exception is NotFoundException) {
      return NotFoundFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    } else {
      return UnknownFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    }
  }

  /// Handle Dio exceptions
  static Failure _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure(
          message: 'Request timeout. Please try again.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);

      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request cancelled');

      case DioExceptionType.connectionError:
        return const NetworkFailure(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badCertificate:
        return const NetworkFailure(message: 'SSL certificate error');

      case DioExceptionType.unknown:
      default:
        return UnknownFailure(
          message: exception.message ?? 'An unexpected error occurred',
          details: exception,
        );
    }
  }

  /// Handle bad response
  static Failure _handleBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;

    String message = 'An error occurred';

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
    }

    switch (statusCode) {
      case 400:
        return ValidationFailure(message: message, code: '400');
      case 401:
        return AuthenticationFailure(message: message, code: '401');
      case 403:
        return AuthorizationFailure(message: message, code: '403');
      case 404:
        return NotFoundFailure(message: message, code: '404');
      case 409:
        return ServerFailure(message: message, statusCode: 409, code: '409');
      case 429:
        return ServerFailure(
          message: 'Too many requests. Please try again later.',
          statusCode: 429,
          code: '429',
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailure(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
          code: statusCode.toString(),
        );
      default:
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          code: statusCode?.toString(),
        );
    }
  }

  /// Get user-friendly error message
  static String getUserMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Please check your internet connection and try again.';
    } else if (failure is ServerFailure) {
      return 'Something went wrong on our end. Please try again later.';
    } else if (failure is AuthenticationFailure) {
      return 'Please log in to continue.';
    } else if (failure is AuthorizationFailure) {
      return 'You don\'t have permission to perform this action.';
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is TimeoutFailure) {
      return 'Request timed out. Please try again.';
    } else if (failure is NotFoundFailure) {
      return 'The requested resource was not found.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}

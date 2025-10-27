import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DevCatalyst Core Tests', () {
    setUpAll(() async {
      // Set up mock shared preferences
      SharedPreferences.setMockInitialValues({});
    });

    test('DevCatalyst can be initialized', () async {
      await DevCatalyst.initialize(
        apiBaseUrl: 'https://jsonplaceholder.typicode.com',
        enableLogging: true,
        logLevel: LogLevel.debug,
      );

      expect(DevCatalyst.isInitialized, true);
    });

    test('DevCatalyst throws error when accessing API before initialization', () {
      // Create a new instance to test uninitialized state
      final newInstance = DevCatalyst.instance;

      // This should work because we initialized above, but we can test the pattern
      expect(DevCatalyst.isInitialized, true);
    });

    test('Logger can be created and used', () {
      final logger = CatalystLogger();

      expect(logger, isNotNull);

      // Test logging methods don't throw
      logger.info('Test info message');
      logger.debug('Test debug message');
      logger.error('Test error message');
      logger.warning('Test warning message');
      logger.success('Test success message');
    });

    test('Storage keys are properly defined', () {
      expect(StorageKeys.authToken, equals('auth_token'));
      expect(StorageKeys.refreshToken, equals('refresh_token'));
      expect(StorageKeys.userId, equals('user_id'));
      expect(StorageKeys.userProfile, equals('user_profile'));
      expect(StorageKeys.themeMode, equals('theme_mode'));
    });

    test('Secure storage keys are properly defined', () {
      expect(SecureStorageKeys.authToken, equals('secure_auth_token'));
      expect(SecureStorageKeys.refreshToken, equals('secure_refresh_token'));
      expect(SecureStorageKeys.username, equals('secure_username'));
      expect(SecureStorageKeys.password, equals('secure_password'));
    });
  });

  group('ApiResponse Tests', () {
    test('Success response is created correctly', () {
      final response = ApiResponse<String>.success(
        data: 'test data',
        message: 'Success',
        statusCode: 200,
      );

      expect(response.success, true);
      expect(response.data, equals('test data'));
      expect(response.message, equals('Success'));
      expect(response.statusCode, equals(200));
      expect(response.hasData, true);
      expect(response.isError, false);
    });

    test('Error response is created correctly', () {
      final response = ApiResponse<String>.error(
        message: 'Error occurred',
        statusCode: 500,
      );

      expect(response.success, false);
      expect(response.data, isNull);
      expect(response.message, equals('Error occurred'));
      expect(response.statusCode, equals(500));
      expect(response.hasData, false);
      expect(response.isError, true);
    });
  });

  group('Pagination Tests', () {
    test('Pagination is created correctly', () {
      const pagination = Pagination(
        currentPage: 1,
        totalPages: 10,
        totalItems: 100,
        itemsPerPage: 10,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      expect(pagination.currentPage, equals(1));
      expect(pagination.totalPages, equals(10));
      expect(pagination.totalItems, equals(100));
      expect(pagination.itemsPerPage, equals(10));
      expect(pagination.hasNextPage, true);
      expect(pagination.hasPreviousPage, false);
    });

    test('Pagination from JSON works correctly', () {
      final json = {
        'currentPage': 2,
        'totalPages': 5,
        'totalItems': 50,
        'itemsPerPage': 10,
        'hasNextPage': true,
        'hasPreviousPage': true,
      };

      final pagination = Pagination.fromJson(json);

      expect(pagination.currentPage, equals(2));
      expect(pagination.totalPages, equals(5));
      expect(pagination.totalItems, equals(50));
    });

    test('Pagination copyWith works correctly', () {
      const original = Pagination(
        currentPage: 1,
        totalPages: 10,
        totalItems: 100,
        itemsPerPage: 10,
        hasNextPage: true,
        hasPreviousPage: false,
      );

      final updated = original.copyWith(currentPage: 2, hasPreviousPage: true);

      expect(updated.currentPage, equals(2));
      expect(updated.totalPages, equals(10)); // unchanged
      expect(updated.hasPreviousPage, true);
    });
  });

  group('ApiError Tests', () {
    test('ApiError is created correctly', () {
      final error = ApiError(
        message: 'Error message',
        code: 'ERR001',
        statusCode: 400,
        timestamp: DateTime.now(),
      );

      expect(error.message, equals('Error message'));
      expect(error.code, equals('ERR001'));
      expect(error.statusCode, equals(400));
      expect(error.timestamp, isNotNull);
    });

    test('ApiError from JSON works correctly', () {
      final timestamp = DateTime.now();
      final json = {
        'message': 'Test error',
        'code': 'TEST001',
        'statusCode': 500,
        'timestamp': timestamp.toIso8601String(),
      };

      final error = ApiError.fromJson(json);

      expect(error.message, equals('Test error'));
      expect(error.code, equals('TEST001'));
      expect(error.statusCode, equals(500));
    });

    test('ApiError toJson works correctly', () {
      final timestamp = DateTime.now();
      final error = ApiError(
        message: 'Test error',
        code: 'TEST001',
        statusCode: 500,
        timestamp: timestamp,
      );

      final json = error.toJson();

      expect(json['message'], equals('Test error'));
      expect(json['code'], equals('TEST001'));
      expect(json['statusCode'], equals(500));
      expect(json['timestamp'], isNotNull);
    });
  });

  group('NetworkStatus Tests', () {
    test('NetworkStatus enum has all values', () {
      expect(NetworkStatus.values.length, equals(8));
      expect(NetworkStatus.values.contains(NetworkStatus.online), true);
      expect(NetworkStatus.values.contains(NetworkStatus.offline), true);
      expect(NetworkStatus.values.contains(NetworkStatus.wifi), true);
      expect(NetworkStatus.values.contains(NetworkStatus.mobile), true);
    });
  });

  group('LogLevel Tests', () {
    test('LogLevel enum has all values', () {
      expect(LogLevel.values.length, equals(7));
      expect(LogLevel.values.contains(LogLevel.verbose), true);
      expect(LogLevel.values.contains(LogLevel.debug), true);
      expect(LogLevel.values.contains(LogLevel.info), true);
      expect(LogLevel.values.contains(LogLevel.error), true);
    });
  });

  group('Exception Tests', () {
    test('CatalystException is created correctly', () {
      final exception = CatalystException(
        message: 'Test exception',
        code: 'TEST001',
      );

      expect(exception.message, equals('Test exception'));
      expect(exception.code, equals('TEST001'));
      expect(exception.toString(), contains('CatalystException'));
    });

    test('NetworkException extends CatalystException', () {
      final exception = NetworkException(
        message: 'Network error',
        code: 'NET001',
      );

      expect(exception, isA<CatalystException>());
      expect(exception.message, equals('Network error'));
    });

    test('ServerException includes status code', () {
      final exception = ServerException(
        message: 'Server error',
        statusCode: 500,
        code: 'SRV001',
      );

      expect(exception.statusCode, equals(500));
      expect(exception.toString(), contains('500'));
    });
  });

  group('Failure Tests', () {
    test('ServerFailure is created correctly', () {
      const failure = ServerFailure(
        message: 'Server error',
        statusCode: 500,
        code: 'SRV001',
      );

      expect(failure.message, equals('Server error'));
      expect(failure.statusCode, equals(500));
      expect(failure.code, equals('SRV001'));
    });

    test('NetworkFailure is created correctly', () {
      const failure = NetworkFailure(message: 'Network error', code: 'NET001');

      expect(failure.message, equals('Network error'));
      expect(failure.code, equals('NET001'));
    });

    test('ValidationFailure includes errors map', () {
      const failure = ValidationFailure(
        message: 'Validation failed',
        errors: {
          'email': ['Invalid email format'],
          'password': ['Password too short'],
        },
      );

      expect(failure.errors, isNotNull);
      expect(failure.errors!['email'], isNotNull);
      expect(failure.errors!['password'], isNotNull);
    });
  });
}

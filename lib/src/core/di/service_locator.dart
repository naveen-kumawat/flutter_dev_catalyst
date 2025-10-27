import 'package:get_it/get_it.dart';
import '../api/api_client.dart';
import '../storage/storage_service.dart';
import '../storage/secure_storage_service.dart';
import '../network/connectivity_service.dart';
import '../../utils/logger/catalyst_logger.dart';

/// Service Locator for Dependency Injection
class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;
  static final CatalystLogger _logger = CatalystLogger();

  /// Get instance of GetIt
  static GetIt get instance => _getIt;

  /// Setup all services
  static Future<void> setup() async {
    _logger.info('Setting up Service Locator...');

    // Register Logger
    _getIt.registerLazySingleton<CatalystLogger>(() => CatalystLogger());

    // Register Storage Services
    _getIt.registerLazySingleton<StorageService>(() => StorageService());
    _getIt.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(),
    );

    // Register Network Services
    _getIt.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService(),
    );

    _logger.info('✅ Service Locator setup complete');
  }

  /// Register API Client
  static void registerApiClient(ApiClient apiClient) {
    if (_getIt.isRegistered<ApiClient>()) {
      _getIt.unregister<ApiClient>();
    }
    _getIt.registerLazySingleton<ApiClient>(() => apiClient);
    _logger.debug('API Client registered');
  }

  /// Register custom service
  static void registerService<T extends Object>(
    T instance, {
    String? instanceName,
  }) {
    if (_getIt.isRegistered<T>(instanceName: instanceName)) {
      _getIt.unregister<T>(instanceName: instanceName);
    }
    _getIt.registerLazySingleton<T>(() => instance, instanceName: instanceName);
    _logger.debug('Service registered: $T');
  }

  /// Register factory
  static void registerFactory<T extends Object>(
    T Function() factory, {
    String? instanceName,
  }) {
    if (_getIt.isRegistered<T>(instanceName: instanceName)) {
      _getIt.unregister<T>(instanceName: instanceName);
    }
    _getIt.registerFactory<T>(factory, instanceName: instanceName);
    _logger.debug('Factory registered: $T');
  }

  /// Get service
  static T get<T extends Object>({String? instanceName}) {
    return _getIt.get<T>(instanceName: instanceName);
  }

  /// Check if service is registered
  static bool isRegistered<T extends Object>({String? instanceName}) {
    return _getIt.isRegistered<T>(instanceName: instanceName);
  }

  /// Unregister service
  static Future<void> unregister<T extends Object>({
    String? instanceName,
  }) async {
    if (_getIt.isRegistered<T>(instanceName: instanceName)) {
      await _getIt.unregister<T>(instanceName: instanceName);
      _logger.debug('Service unregistered: $T');
    }
  }

  /// Reset all services
  static Future<void> reset() async {
    await _getIt.reset();
    _logger.info('Service Locator reset');
  }
}

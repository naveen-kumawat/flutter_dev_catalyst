import 'package:flutter/material.dart';
import 'core/api/api_client.dart';
import 'core/storage/storage_service.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/network/connectivity_service.dart';
import 'core/di/service_locator.dart';
import 'ui/theme/theme_manager.dart';
import 'utils/logger/catalyst_logger.dart';

/// Main DevCatalyst class - Entry point for all plugin features
class DevCatalyst {
  static DevCatalyst? _instance;
  static DevCatalyst get instance => _instance ??= DevCatalyst._internal();

  DevCatalyst._internal();

  // Services
  static late ApiClient _apiClient;
  static late StorageService _storage;
  static late SecureStorageService _secureStorage;
  static late ConnectivityService _connectivity;
  static late ThemeManager _themeManager;
  static final CatalystLogger _logger =
      CatalystLogger(); // Changed: not late, initialize immediately

  bool _isInitialized = false;

  /// Initialize DevCatalyst with configuration
  static Future<void> initialize({
    required String apiBaseUrl,
    Map<String, String>? defaultHeaders,
    Duration? connectionTimeout,
    bool enableLogging = true,
    LogLevel logLevel = LogLevel.debug,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
  }) async {
    if (instance._isInitialized) {
      _logger.warning(
        'DevCatalyst already initialized',
      ); // Changed: Use _logger directly (static)
      return;
    }

    // Initialize Logger
    _logger.init(
      // Changed: Call init() method instead of constructor
      isEnabled: enableLogging,
      logLevel: logLevel,
    );
    _logger.info('🚀 Initializing DevCatalyst...');

    // Setup Service Locator
    await ServiceLocator.setup();

    // Initialize Services
    _apiClient = ApiClient(
      baseUrl: apiBaseUrl,
      defaultHeaders: defaultHeaders,
      connectionTimeout: connectionTimeout ?? const Duration(seconds: 30),
    );

    _storage = StorageService();
    await _storage.init();

    _secureStorage = SecureStorageService();
    await _secureStorage.init();

    _connectivity = ConnectivityService();
    await _connectivity.initialize();

    _themeManager = ThemeManager(lightTheme: lightTheme, darkTheme: darkTheme);

    instance._isInitialized = true;
    _logger.success('✅ DevCatalyst initialized successfully');
  }

  /// Check if DevCatalyst is initialized
  static bool get isInitialized => instance._isInitialized;

  /// Access API Client
  static ApiClient get api {
    _checkInitialization();
    return _apiClient;
  }

  /// Access Storage Service
  static StorageService get storage {
    _checkInitialization();
    return _storage;
  }

  /// Access Secure Storage Service
  static SecureStorageService get secureStorage {
    _checkInitialization();
    return _secureStorage;
  }

  /// Access Connectivity Service
  static ConnectivityService get connectivity {
    _checkInitialization();
    return _connectivity;
  }

  /// Access Theme Manager
  static ThemeManager get theme {
    _checkInitialization();
    return _themeManager;
  }

  /// Access Logger
  static CatalystLogger get logger {
    return _logger;
  }

  /// Check if initialized
  static void _checkInitialization() {
    if (!instance._isInitialized) {
      throw StateError(
        'DevCatalyst not initialized. Call DevCatalyst.initialize() first.',
      );
    }
  }

  /// Dispose all services
  static Future<void> dispose() async {
    if (!instance._isInitialized) return;

    _logger.info('🔄 Disposing DevCatalyst...');

    await _connectivity.dispose();
    await _storage.clear();
    _logger.close(); // Added: Close the logger

    instance._isInitialized = false;
    _logger.info('✅ DevCatalyst disposed');
  }
}

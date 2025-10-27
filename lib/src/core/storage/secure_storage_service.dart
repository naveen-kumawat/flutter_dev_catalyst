import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../utils/logger/catalyst_logger.dart';

/// Secure Storage Service for sensitive data
class SecureStorageService {
  late FlutterSecureStorage _secureStorage;
  final CatalystLogger _logger = CatalystLogger();

  /// Initialize secure storage
  Future<void> init() async {
    _secureStorage = FlutterSecureStorage();
    _logger.info('✅ Secure Storage Service initialized');
  }

  // ═══════════════════════════════════════════════════════════════
  // WRITE OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Write secure data
  Future<void> write(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      _logger.debug('Secure write: $key');
    } catch (e) {
      _logger.error('Error writing secure data: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // READ OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Read secure data
  Future<String?> read(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      _logger.debug('Secure read: $key');
      return value;
    } catch (e) {
      _logger.error('Error reading secure data: $e');
      return null;
    }
  }

  /// Read all secure data
  Future<Map<String, String>> readAll() async {
    try {
      final data = await _secureStorage.readAll();
      _logger.debug('Secure read all');
      return data;
    } catch (e) {
      _logger.error('Error reading all secure data: $e');
      return {};
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // DELETE OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Delete secure data
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key: key);
      _logger.debug('Secure delete: $key');
    } catch (e) {
      _logger.error('Error deleting secure data: $e');
      rethrow;
    }
  }

  /// Delete all secure data
  Future<void> deleteAll() async {
    try {
      await _secureStorage.deleteAll();
      _logger.info('All secure data deleted');
    } catch (e) {
      _logger.error('Error deleting all secure data: $e');
      rethrow;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // UTILITY OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      _logger.error('Error checking key existence: $e');
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // TOKEN MANAGEMENT
  // ═══════════════════════════════════════════════════════════════

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    await write(SecureStorageKeys.authToken, token);
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    return await read(SecureStorageKeys.authToken);
  }

  /// Delete authentication token
  Future<void> deleteAuthToken() async {
    await delete(SecureStorageKeys.authToken);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await write(SecureStorageKeys.refreshToken, token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await read(SecureStorageKeys.refreshToken);
  }

  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    await delete(SecureStorageKeys.refreshToken);
  }

  /// Save credentials
  Future<void> saveCredentials({
    required String username,
    required String password,
  }) async {
    await write(SecureStorageKeys.username, username);
    await write(SecureStorageKeys.password, password);
  }

  /// Get credentials
  Future<Map<String, String?>> getCredentials() async {
    return {
      'username': await read(SecureStorageKeys.username),
      'password': await read(SecureStorageKeys.password),
    };
  }

  /// Delete credentials
  Future<void> deleteCredentials() async {
    await delete(SecureStorageKeys.username);
    await delete(SecureStorageKeys.password);
  }
}

/// Secure Storage Keys - Predefined keys for sensitive data
class SecureStorageKeys {
  static const String authToken = 'secure_auth_token';
  static const String refreshToken = 'secure_refresh_token';
  static const String username = 'secure_username';
  static const String password = 'secure_password';
  static const String apiKey = 'secure_api_key';
  static const String privateKey = 'secure_private_key';
  static const String biometricKey = 'secure_biometric_key';
}

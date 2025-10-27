import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/logger/catalyst_logger.dart';

/// Storage Service for managing local data persistence
class StorageService {
  SharedPreferences? _prefs;
  final CatalystLogger _logger = CatalystLogger();

  /// Initialize storage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _logger.info('✅ Storage Service initialized');
  }

  /// Ensure preferences is initialized
  void _ensureInitialized() {
    if (_prefs == null) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // STRING OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Save string value
  Future<bool> saveString(String key, String value) async {
    _ensureInitialized();
    try {
      final result = await _prefs!.setString(key, value);
      _logger.debug('Saved string: $key');
      return result;
    } catch (e) {
      _logger.error('Error saving string: $e');
      return false;
    }
  }

  /// Get string value
  String? getString(String key, {String? defaultValue}) {
    _ensureInitialized();
    return _prefs!.getString(key) ?? defaultValue;
  }

  // ═══════════════════════════════════════════════════════════════
  // INTEGER OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Save integer value
  Future<bool> saveInt(String key, int value) async {
    _ensureInitialized();
    try {
      final result = await _prefs!.setInt(key, value);
      _logger.debug('Saved int: $key');
      return result;
    } catch (e) {
      _logger.error('Error saving int: $e');
      return false;
    }
  }

  /// Get integer value
  int? getInt(String key, {int? defaultValue}) {
    _ensureInitialized();
    return _prefs!.getInt(key) ?? defaultValue;
  }

  // ═══════════════════════════════════════════════════════════════
  // BOOLEAN OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Save boolean value
  Future<bool> saveBool(String key, bool value) async {
    _ensureInitialized();
    try {
      final result = await _prefs!.setBool(key, value);
      _logger.debug('Saved bool: $key');
      return result;
    } catch (e) {
      _logger.error('Error saving bool: $e');
      return false;
    }
  }

  /// Get boolean value
  bool? getBool(String key, {bool? defaultValue}) {
    _ensureInitialized();
    return _prefs!.getBool(key) ?? defaultValue;
  }

  // ═══════════════════════════════════════════════════════════════
  // DOUBLE OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Save double value
  Future<bool> saveDouble(String key, double value) async {
    _ensureInitialized();
    try {
      final result = await _prefs!.setDouble(key, value);
      _logger.debug('Saved double: $key');
      return result;
    } catch (e) {
      _logger.error('Error saving double: $e');
      return false;
    }
  }

  /// Get double value
  double? getDouble(String key, {double? defaultValue}) {
    _ensureInitialized();
    return _prefs!.getDouble(key) ?? defaultValue;
  }

  // ═══════════════════════════════════════════════════════════════
  // LIST OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Save string list
  Future<bool> saveStringList(String key, List<String> value) async {
    _ensureInitialized();
    try {
      final result = await _prefs!.setStringList(key, value);
      _logger.debug('Saved string list: $key');
      return result;
    } catch (e) {
      _logger.error('Error saving string list: $e');
      return false;
    }
  }

  /// Get string list
  List<String>? getStringList(String key) {
    _ensureInitialized();
    return _prefs!.getStringList(key);
  }

  // ═══════════════════════════════════════════════════════════════
  // OBJECT OPERATIONS (JSON)
  // ═══════════════════════════════════════════════════════════════

  /// Save object as JSON
  Future<bool> saveObject(String key, Map<String, dynamic> value) async {
    _ensureInitialized();
    try {
      final jsonString = jsonEncode(value);
      final result = await _prefs!.setString(key, jsonString);
      _logger.debug('Saved object: $key');
      return result;
    } catch (e) {
      _logger.error('Error saving object: $e');
      return false;
    }
  }

  /// Get object from JSON
  Map<String, dynamic>? getObject(String key) {
    _ensureInitialized();
    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      _logger.error('Error getting object: $e');
      return null;
    }
  }

  /// Save list of objects
  Future<bool> saveObjectList(
    String key,
    List<Map<String, dynamic>> value,
  ) async {
    _ensureInitialized();
    try {
      final jsonString = jsonEncode(value);
      final result = await _prefs!.setString(key, jsonString);
      _logger.debug('Saved object list: $key');
      return result;
    } catch (e) {
      _logger.error('Error saving object list: $e');
      return false;
    }
  }

  /// Get list of objects
  List<Map<String, dynamic>>? getObjectList(String key) {
    _ensureInitialized();
    try {
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) return null;
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      _logger.error('Error getting object list: $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // UTILITY OPERATIONS
  // ═══════════════════════════════════════════════════════════════

  /// Check if key exists
  bool containsKey(String key) {
    _ensureInitialized();
    return _prefs!.containsKey(key);
  }

  /// Remove value by key
  Future<bool> remove(String key) async {
    _ensureInitialized();
    try {
      final result = await _prefs!.remove(key);
      _logger.debug('Removed key: $key');
      return result;
    } catch (e) {
      _logger.error('Error removing key: $e');
      return false;
    }
  }

  /// Clear all data
  Future<bool> clear() async {
    _ensureInitialized();
    try {
      final result = await _prefs!.clear();
      _logger.info('Storage cleared');
      return result;
    } catch (e) {
      _logger.error('Error clearing storage: $e');
      return false;
    }
  }

  /// Get all keys
  Set<String> getAllKeys() {
    _ensureInitialized();
    return _prefs!.getKeys();
  }

  /// Reload preferences
  Future<void> reload() async {
    _ensureInitialized();
    await _prefs!.reload();
    _logger.debug('Storage reloaded');
  }
}

/// Storage Keys - Predefined keys for common use cases
class StorageKeys {
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userProfile = 'user_profile';
  static const String language = 'language';
  static const String themeMode = 'theme_mode';
  static const String isFirstLaunch = 'is_first_launch';
  static const String lastSyncTime = 'last_sync_time';
  static const String notificationEnabled = 'notification_enabled';
  static const String onboardingCompleted = 'onboarding_completed';
}

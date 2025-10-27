import 'package:flutter/material.dart';
import '../../core/storage/storage_service.dart';
import '../../utils/logger/catalyst_logger.dart';
import 'app_theme.dart';

/// Theme Mode enum
enum AppThemeMode { light, dark, system }

/// Theme Manager for managing app themes
class ThemeManager extends ChangeNotifier {
  final CatalystLogger _logger = CatalystLogger();
  final StorageService _storage = StorageService();

  ThemeData _lightTheme;
  ThemeData _darkTheme;
  AppThemeMode _themeMode = AppThemeMode.system;

  ThemeManager({
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    AppThemeMode? initialMode,
  }) : _lightTheme = lightTheme ?? AppTheme.lightTheme,
       _darkTheme = darkTheme ?? AppTheme.darkTheme {
    if (initialMode != null) {
      _themeMode = initialMode;
    }
    _loadThemeMode();
  }

  // ═══════════════════════════════════════════════════════════════
  // GETTERS
  // ═══════════════════════════════════════════════════════════════

  /// Get light theme
  ThemeData get lightTheme => _lightTheme;

  /// Get dark theme
  ThemeData get darkTheme => _darkTheme;

  /// Get current theme mode
  AppThemeMode get themeMode => _themeMode;

  /// Get current theme based on mode
  ThemeData get currentTheme {
    switch (_themeMode) {
      case AppThemeMode.light:
        return _lightTheme;
      case AppThemeMode.dark:
        return _darkTheme;
      case AppThemeMode.system:
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark ? _darkTheme : _lightTheme;
    }
  }

  /// Check if dark mode is active
  bool get isDarkMode {
    switch (_themeMode) {
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.light:
        return false;
      case AppThemeMode.system:
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SETTERS
  // ═══════════════════════════════════════════════════════════════

  /// Set light theme
  void setLightTheme(ThemeData theme) {
    _lightTheme = theme;
    _logger.info('Light theme updated');
    notifyListeners();
  }

  /// Set dark theme
  void setDarkTheme(ThemeData theme) {
    _darkTheme = theme;
    _logger.info('Dark theme updated');
    notifyListeners();
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _saveThemeMode();
    _logger.info('Theme mode changed to: $mode');
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════════

  /// Toggle between light and dark mode
  Future<void> toggle() async {
    if (_themeMode == AppThemeMode.light) {
      await setThemeMode(AppThemeMode.dark);
    } else {
      await setThemeMode(AppThemeMode.light);
    }
  }

  /// Set to light mode
  Future<void> setLightMode() async {
    await setThemeMode(AppThemeMode.light);
  }

  /// Set to dark mode
  Future<void> setDarkMode() async {
    await setThemeMode(AppThemeMode.dark);
  }

  /// Set to system mode
  Future<void> setSystemMode() async {
    await setThemeMode(AppThemeMode.system);
  }

  // ═══════════════════════════════════════════════════════════════
  // PERSISTENCE
  // ═══════════════════════════════════════════════════════════════

  /// Load theme mode from storage
  Future<void> _loadThemeMode() async {
    try {
      await _storage.init();
      final modeString = _storage.getString(StorageKeys.themeMode);

      if (modeString != null) {
        _themeMode = AppThemeMode.values.firstWhere(
          (mode) => mode.toString() == modeString,
          orElse: () => AppThemeMode.system,
        );
        _logger.debug('Theme mode loaded: $_themeMode');
        notifyListeners();
      }
    } catch (e) {
      _logger.error('Error loading theme mode: $e');
    }
  }

  /// Save theme mode to storage
  Future<void> _saveThemeMode() async {
    try {
      await _storage.saveString(StorageKeys.themeMode, _themeMode.toString());
      _logger.debug('Theme mode saved: $_themeMode');
    } catch (e) {
      _logger.error('Error saving theme mode: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // CUSTOM THEMES
  // ═══════════════════════════════════════════════════════════════

  /// Set custom themes
  void setCustomThemes({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
  }) {
    _lightTheme = lightTheme;
    _darkTheme = darkTheme;
    _logger.info('Custom themes set');
    notifyListeners();
  }

  /// Reset to default themes
  void resetToDefaultThemes() {
    _lightTheme = AppTheme.lightTheme;
    _darkTheme = AppTheme.darkTheme;
    _logger.info('Reset to default themes');
    notifyListeners();
  }
}

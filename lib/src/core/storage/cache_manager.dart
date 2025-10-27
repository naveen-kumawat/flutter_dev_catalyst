import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../utils/logger/catalyst_logger.dart';

/// Cache Manager for handling file and image caching
class CatalystCacheManager {
  static final CatalystCacheManager _instance =
      CatalystCacheManager._internal();
  factory CatalystCacheManager() => _instance;
  CatalystCacheManager._internal();

  final CatalystLogger _logger = CatalystLogger();

  late final CacheManager _cacheManager;

  /// Initialize cache manager
  void init({
    String? cacheKey,
    Duration? stalePeriod,
    int? maxNrOfCacheObjects,
  }) {
    _cacheManager = CacheManager(
      Config(
        cacheKey ?? 'dev_catalyst_cache',
        stalePeriod: stalePeriod ?? const Duration(days: 7),
        maxNrOfCacheObjects: maxNrOfCacheObjects ?? 200,
      ),
    );
    _logger.info('✅ Cache Manager initialized');
  }

  /// Get cache manager instance
  CacheManager get instance => _cacheManager;

  /// Get file from cache or download
  Future<FileInfo> getFile(
    String url, {
    Map<String, String>? headers,
    bool force = false,
  }) async {
    try {
      if (force) {
        await _cacheManager.removeFile(url);
      }

      final file = await _cacheManager.getSingleFile(url, headers: headers);

      _logger.debug('File cached: $url');
      return FileInfo(
        file,
        FileSource.Cache,
        DateTime.now().add(const Duration(days: 7)),
        url,
      );
    } catch (e) {
      _logger.error('Error caching file: $e');
      rethrow;
    }
  }

  /// Get file from cache only
  Future<FileInfo?> getFileFromCache(String url) async {
    try {
      return await _cacheManager.getFileFromCache(url);
    } catch (e) {
      _logger.error('Error getting file from cache: $e');
      return null;
    }
  }

  /// Download file to cache
  Stream<FileResponse> downloadFile(
    String url, {
    Map<String, String>? headers,
    bool force = false,
  }) {
    try {
      if (force) {
        _cacheManager.removeFile(url);
      }

      return _cacheManager.getFileStream(url, headers: headers);
    } catch (e) {
      _logger.error('Error downloading file: $e');
      rethrow;
    }
  }

  /// Remove file from cache
  Future<void> removeFile(String url) async {
    try {
      await _cacheManager.removeFile(url);
      _logger.debug('File removed from cache: $url');
    } catch (e) {
      _logger.error('Error removing file: $e');
    }
  }

  /// Clear all cache
  Future<void> emptyCache() async {
    try {
      await _cacheManager.emptyCache();
      _logger.info('Cache cleared');
    } catch (e) {
      _logger.error('Error clearing cache: $e');
    }
  }
}

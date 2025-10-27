import 'package:dio/dio.dart';
import '../../utils/logger/catalyst_logger.dart';

/// API Interceptor for handling requests, responses, and errors
class ApiInterceptor extends Interceptor {
  final CatalystLogger _logger = CatalystLogger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.info('''
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🌐 REQUEST
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    URI: ${options.uri}
    METHOD: ${options.method}
    HEADERS: ${options.headers}
    DATA: ${options.data}
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ''');

    // Add timestamp to request
    options.extra['request_time'] = DateTime.now().millisecondsSinceEpoch;

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestTime = response.requestOptions.extra['request_time'] as int?;
    final responseTime = DateTime.now().millisecondsSinceEpoch;
    final duration = requestTime != null ? responseTime - requestTime : 0;

    _logger.info('''
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ✅ RESPONSE
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    URI: ${response.requestOptions.uri}
    STATUS CODE: ${response.statusCode}
    DURATION: ${duration}ms
    DATA: ${response.data}
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ''');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.error('''
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ❌ ERROR
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    URI: ${err.requestOptions.uri}
    TYPE: ${err.type}
    MESSAGE: ${err.message}
    RESPONSE: ${err.response?.data}
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ''');

    super.onError(err, handler);
  }
}

/// Retry Interceptor for automatic retries on failure
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final CatalystLogger _logger = CatalystLogger();

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = err.requestOptions.extra['retry_attempt'] as int? ?? 0;

    if (attempt >= maxRetries) {
      _logger.warning('Max retries reached for ${err.requestOptions.uri}');
      return super.onError(err, handler);
    }

    if (_shouldRetry(err)) {
      _logger.info(
        'Retrying request (${attempt + 1}/$maxRetries): ${err.requestOptions.uri}',
      );

      await Future.delayed(retryDelay * (attempt + 1));

      err.requestOptions.extra['retry_attempt'] = attempt + 1;

      try {
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        return super.onError(e, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}

/// Cache Interceptor for caching GET requests
class CacheInterceptor extends Interceptor {
  final Map<String, CacheEntry> _cache = {};
  final Duration cacheDuration;
  final CatalystLogger _logger = CatalystLogger();

  CacheInterceptor({this.cacheDuration = const Duration(minutes: 5)});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method != 'GET') {
      return super.onRequest(options, handler);
    }

    final cacheKey = _getCacheKey(options);
    final cachedEntry = _cache[cacheKey];

    if (cachedEntry != null && !cachedEntry.isExpired) {
      _logger.info('Cache HIT: ${options.uri}');
      return handler.resolve(
        Response(
          requestOptions: options,
          data: cachedEntry.data,
          statusCode: 200,
          headers: Headers.fromMap({
            'x-cache': ['HIT'],
          }),
        ),
      );
    }

    _logger.info('Cache MISS: ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method == 'GET' && response.statusCode == 200) {
      final cacheKey = _getCacheKey(response.requestOptions);
      _cache[cacheKey] = CacheEntry(
        data: response.data,
        timestamp: DateTime.now(),
        duration: cacheDuration,
      );
      _logger.debug('Cached response: $cacheKey');
    }

    super.onResponse(response, handler);
  }

  String _getCacheKey(RequestOptions options) {
    return '${options.uri}${options.queryParameters}';
  }

  void clearCache() {
    _cache.clear();
    _logger.info('Cache cleared');
  }

  void removeCacheEntry(String key) {
    _cache.remove(key);
    _logger.debug('Cache entry removed: $key');
  }
}

/// Cache Entry model
class CacheEntry {
  final dynamic data;
  final DateTime timestamp;
  final Duration duration;

  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  bool get isExpired {
    return DateTime.now().difference(timestamp) > duration;
  }
}

/// API Configuration class
class ApiConfig {
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final Duration connectionTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final bool enableRetry;
  final int maxRetries;
  final bool enableCaching;
  final Duration cacheDuration;

  const ApiConfig({
    required this.baseUrl,
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    this.connectionTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.enableRetry = true,
    this.maxRetries = 3,
    this.enableCaching = true,
    this.cacheDuration = const Duration(minutes: 5),
  });

  ApiConfig copyWith({
    String? baseUrl,
    Map<String, String>? defaultHeaders,
    Duration? connectionTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    bool? enableRetry,
    int? maxRetries,
    bool? enableCaching,
    Duration? cacheDuration,
  }) {
    return ApiConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      connectionTimeout: connectionTimeout ?? this.connectionTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      sendTimeout: sendTimeout ?? this.sendTimeout,
      enableRetry: enableRetry ?? this.enableRetry,
      maxRetries: maxRetries ?? this.maxRetries,
      enableCaching: enableCaching ?? this.enableCaching,
      cacheDuration: cacheDuration ?? this.cacheDuration,
    );
  }
}

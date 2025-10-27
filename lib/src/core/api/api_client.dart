import 'package:dio/dio.dart';
import 'api_response.dart';
import 'api_config.dart';
import 'api_interceptor.dart';
import '../../utils/logger/catalyst_logger.dart';

/// Main API Client for handling all HTTP requests
class ApiClient {
  late final Dio _dio;
  final ApiConfig config;
  final CatalystLogger _logger = CatalystLogger();

  ApiClient({
    required String baseUrl,
    Map<String, String>? defaultHeaders,
    Duration? connectionTimeout,
  }) : config = ApiConfig(
         baseUrl: baseUrl,
         defaultHeaders:
             defaultHeaders ??
             const {
               'Content-Type': 'application/json',
               'Accept': 'application/json',
             },
         connectionTimeout: connectionTimeout ?? const Duration(seconds: 30),
       ) {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectionTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        headers: config.defaultHeaders,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(ApiInterceptor());

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => _logger.debug(obj.toString()),
      ),
    );
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      _logger.info('GET: $endpoint');

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      _logger.info('POST: $endpoint');

      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      _logger.info('PUT: $endpoint');

      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      _logger.info('PATCH: $endpoint');

      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? parser,
  }) async {
    try {
      _logger.info('DELETE: $endpoint');

      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Upload file
  Future<ApiResponse<T>> uploadFile<T>(
    String endpoint,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? parser,
  }) async {
    try {
      _logger.info('UPLOAD: $endpoint');

      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        ...?additionalData,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
      );

      return _handleResponse<T>(response, parser);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  /// Download file
  Future<ApiResponse<String>> downloadFile(
    String endpoint,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      _logger.info('DOWNLOAD: $endpoint');

      await _dio.download(
        endpoint,
        savePath,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
      );

      return ApiResponse.success(
        data: savePath,
        message: 'File downloaded successfully',
      );
    } catch (e) {
      return _handleError<String>(e);
    }
  }

  /// Handle response
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? parser,
  ) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      T? parsedData;

      if (parser != null && response.data != null) {
        parsedData = parser(response.data);
      } else if (response.data is T) {
        parsedData = response.data as T;
      }

      return ApiResponse.success(
        data: parsedData,
        statusCode: response.statusCode,
        message: response.statusMessage,
        metadata: response.headers.map,
      );
    } else {
      return ApiResponse.error(
        statusCode: response.statusCode,
        message: response.statusMessage ?? 'Request failed',
      );
    }
  }

  /// Handle errors
  ApiResponse<T> _handleError<T>(dynamic error) {
    _logger.error('API Error: $error');

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiResponse.error(
            message: 'Connection timeout. Please try again.',
            statusCode: 408,
            error: error,
          );

        case DioExceptionType.badResponse:
          return ApiResponse.error(
            message:
                error.response?.data?['message'] ?? 'Server error occurred',
            statusCode: error.response?.statusCode ?? 500,
            error: error,
          );

        case DioExceptionType.cancel:
          return ApiResponse.error(
            message: 'Request cancelled',
            statusCode: 499,
            error: error,
          );

        case DioExceptionType.connectionError:
          return ApiResponse.error(
            message: 'No internet connection',
            statusCode: 503,
            error: error,
          );

        default:
          return ApiResponse.error(
            message: 'An unexpected error occurred',
            statusCode: 500,
            error: error,
          );
      }
    }

    return ApiResponse.error(
      message: error.toString(),
      statusCode: 500,
      error: error,
    );
  }

  /// Set authorization token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _logger.info('Authorization token set');
  }

  /// Remove authorization token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
    _logger.info('Authorization token removed');
  }

  /// Update base URL
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
    _logger.info('Base URL updated: $newBaseUrl');
  }

  /// Add custom header
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
    _logger.info('Header added: $key');
  }

  /// Remove header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
    _logger.info('Header removed: $key');
  }

  /// Clear all headers
  void clearHeaders() {
    _dio.options.headers.clear();
    _logger.info('All headers cleared');
  }

  /// Get current headers
  Map<String, dynamic> get headers => _dio.options.headers;
}

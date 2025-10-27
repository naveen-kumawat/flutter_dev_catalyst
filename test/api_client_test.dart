import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';

void main() {
  setUpAll(() {
    // Initialize logger for all tests
    CatalystLogger().init(
      isEnabled: false,
    ); // Disable for tests to reduce noise
  });

  group('ApiClient Tests', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient(baseUrl: 'https://jsonplaceholder.typicode.com');
    });

    test('GET request returns success response', () async {
      final response = await apiClient.get('/posts/1');

      expect(response.success, true);
      expect(response.statusCode, 200);
      expect(response.data, isNotNull);
    });

    test('POST request returns success response', () async {
      final response = await apiClient.post(
        '/posts',
        data: {'title': 'Test', 'body': 'Test body', 'userId': 1},
      );

      expect(response.success, true);
      expect(response.statusCode, 201);
    });

    test('Invalid endpoint returns error response', () async {
      final response = await apiClient.get('/invalid-endpoint');

      expect(response.success, false);
      expect(response.statusCode, 404);
    });

    test('Set auth token adds Authorization header', () {
      const token = 'test_token_123';
      apiClient.setAuthToken(token);

      expect(apiClient.headers['Authorization'], 'Bearer $token');
    });

    test('Remove auth token removes Authorization header', () {
      apiClient.setAuthToken('test_token');
      apiClient.removeAuthToken();

      expect(apiClient.headers.containsKey('Authorization'), false);
    });
  });
}

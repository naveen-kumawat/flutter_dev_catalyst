import 'package:flutter/material.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';

class ApiDemoScreen extends StatefulWidget {
  const ApiDemoScreen({super.key});

  @override
  State<ApiDemoScreen> createState() => _ApiDemoScreenState();
}

class _ApiDemoScreenState extends State<ApiDemoScreen> {
  bool _isLoading = false;
  String? _result;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Client Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          _buildActionButton(
            'GET Request',
            Icons.download,
            () => _performGetRequest(),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'POST Request',
            Icons.upload,
            () => _performPostRequest(),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'PUT Request',
            Icons.edit,
            () => _performPutRequest(),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'DELETE Request',
            Icons.delete,
            () => _performDeleteRequest(),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'Error Handling',
            Icons.error,
            () => _performErrorRequest(),
          ),
          const SizedBox(height: 24),
          if (_isLoading)
            const Center(child: CatalystLoading(message: 'Loading...')),
          if (_error != null) ...[
            CatalystErrorWidget.detailed(
              title: 'Error Occurred',
              message: _error!,
              onRetry: () {
                setState(() {
                  _error = null;
                });
              },
            ),
          ],
          if (_result != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Response',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Text(
                        _result!,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'API Demo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Test various HTTP methods with automatic error handling, retries, and response parsing.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return CatalystButton.elevated(
      text: label,
      icon: icon,
      onPressed: _isLoading ? null : onPressed,
      isFullWidth: true,
      isLoading: _isLoading,
    );
  }

  Future<void> _performGetRequest() async {
    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      final response = await DevCatalyst.api.get<Map<String, dynamic>>(
        '/posts/1',
      );

      if (response.success) {
        setState(() {
          _result = 'Success!\n\nData: ${response.data}';
        });
      } else {
        setState(() {
          _error = response.message ?? 'Request failed';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performPostRequest() async {
    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      final response = await DevCatalyst.api.post<Map<String, dynamic>>(
        '/posts',
        data: {
          'title': 'DevCatalyst Test',
          'body': 'Testing POST request',
          'userId': 1,
        },
      );

      if (response.success) {
        setState(() {
          _result = 'Success!\n\nData: ${response.data}';
        });
      } else {
        setState(() {
          _error = response.message ?? 'Request failed';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performPutRequest() async {
    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      final response = await DevCatalyst.api.put<Map<String, dynamic>>(
        '/posts/1',
        data: {
          'id': 1,
          'title': 'Updated Title',
          'body': 'Updated body',
          'userId': 1,
        },
      );

      if (response.success) {
        setState(() {
          _result = 'Success!\n\nData: ${response.data}';
        });
      } else {
        setState(() {
          _error = response.message ?? 'Request failed';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performDeleteRequest() async {
    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      final response = await DevCatalyst.api.delete<Map<String, dynamic>>(
        '/posts/1',
      );

      if (response.success) {
        setState(() {
          _result = 'Success!\n\nPost deleted successfully';
        });
      } else {
        setState(() {
          _error = response.message ?? 'Request failed';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performErrorRequest() async {
    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      final response = await DevCatalyst.api.get<Map<String, dynamic>>(
        '/posts/99999', // This will return 404
      );

      if (response.success) {
        setState(() {
          _result = 'Success!\n\nData: ${response.data}';
        });
      } else {
        setState(() {
          _error =
              'Error: ${response.message}\nStatus Code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

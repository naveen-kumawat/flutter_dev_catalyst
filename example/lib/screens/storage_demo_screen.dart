import 'package:flutter/material.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';

class StorageDemoScreen extends StatefulWidget {
  const StorageDemoScreen({super.key});

  @override
  State<StorageDemoScreen> createState() => _StorageDemoScreenState();
}

class _StorageDemoScreenState extends State<StorageDemoScreen> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  String? _retrievedValue;
  List<String> _allKeys = [];

  @override
  void initState() {
    super.initState();
    _loadAllKeys();
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _loadAllKeys() {
    setState(() {
      _allKeys = DevCatalyst.storage.getAllKeys().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearAllStorage,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          _buildStorageSection(),
          const SizedBox(height: 24),
          _buildSecureStorageSection(),
          const SizedBox(height: 24),
          _buildStoredKeysSection(),
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
                  Icons.storage,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Storage Demo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Test local storage and secure storage features.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Local Storage',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CatalystTextField(
              controller: _keyController,
              label: 'Key',
              hint: 'Enter storage key',
              prefixIcon: Icons.key,
            ),
            const SizedBox(height: 12),
            CatalystTextField(
              controller: _valueController,
              label: 'Value',
              hint: 'Enter value to store',
              prefixIcon: Icons.text_fields,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CatalystButton.elevated(
                    text: 'Save',
                    icon: Icons.save,
                    onPressed: _saveToStorage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CatalystButton.outlined(
                    text: 'Retrieve',
                    icon: Icons.download,
                    onPressed: _retrieveFromStorage,
                  ),
                ),
              ],
            ),
            if (_retrievedValue != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Retrieved: $_retrievedValue',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSecureStorageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Secure Storage',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CatalystButton.elevated(
              text: 'Save Auth Token',
              icon: Icons.security,
              onPressed: _saveAuthToken,
              isFullWidth: true,
            ),
            const SizedBox(height: 12),
            CatalystButton.outlined(
              text: 'Get Auth Token',
              icon: Icons.vpn_key,
              onPressed: _getAuthToken,
              isFullWidth: true,
            ),
            const SizedBox(height: 12),
            CatalystButton.outlined(
              text: 'Delete Auth Token',
              icon: Icons.delete,
              onPressed: _deleteAuthToken,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoredKeysSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stored Keys (${_allKeys.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadAllKeys,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_allKeys.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No keys stored'),
                ),
              )
            else
              ..._allKeys.map(
                (key) => ListTile(
                  leading: const Icon(Icons.key),
                  title: Text(key),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteKey(key),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToStorage() async {
    final key = _keyController.text.trim();
    final value = _valueController.text.trim();

    if (key.isEmpty || value.isEmpty) {
      if (mounted) context.showErrorSnackBar('Please enter both key and value');
      return;
    }

    await DevCatalyst.storage.saveString(key, value);
    if (mounted) context.showSuccessSnackBar('Saved successfully');
    _loadAllKeys();
    _valueController.clear();
  }

  Future<void> _retrieveFromStorage() async {
    final key = _keyController.text.trim();

    if (key.isEmpty) {
      context.showErrorSnackBar('Please enter a key');
      return;
    }

    final value = DevCatalyst.storage.getString(key);

    if (value != null) {
      setState(() {
        _retrievedValue = value;
      });
      context.showSuccessSnackBar('Value retrieved');
    } else {
      context.showErrorSnackBar('Key not found');
    }
  }

  Future<void> _saveAuthToken() async {
    await DevCatalyst.secureStorage.saveAuthToken('sample_token_123456');
    context.showSuccessSnackBar('Auth token saved securely');
  }

  Future<void> _getAuthToken() async {
    final token = await DevCatalyst.secureStorage.getAuthToken();

    if (token != null) {
      context.showSuccessSnackBar('Token: $token');
    } else {
      context.showErrorSnackBar('No auth token found');
    }
  }

  Future<void> _deleteAuthToken() async {
    await DevCatalyst.secureStorage.deleteAuthToken();
    context.showSuccessSnackBar('Auth token deleted');
  }

  Future<void> _deleteKey(String key) async {
    await DevCatalyst.storage.remove(key);
    context.showSuccessSnackBar('Key deleted');
    _loadAllKeys();
  }

  Future<void> _clearAllStorage() async {
    final confirmed = await context.showAlertDialog(
      title: 'Clear All Storage',
      message: 'Are you sure you want to clear all stored data?',
      confirmText: 'Clear',
      cancelText: 'Cancel',
    );

    if (confirmed == true) {
      await DevCatalyst.storage.clear();
      context.showSuccessSnackBar('All storage cleared');
      _loadAllKeys();
      setState(() {
        _retrievedValue = null;
      });
    }
  }
}

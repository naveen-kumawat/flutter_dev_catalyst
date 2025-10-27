# Flutter Dev Catalyst 🚀

[![pub package](https://img.shields.io/pub/v/flutter_dev_catalyst.svg)](https://pub.dev/packages/flutter_dev_catalyst)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter plugin that accelerates development with smart automation, reducing boilerplate code and development time by **60%**.

## Features ✨

- 🌐 **API Client** - Built-in HTTP client with error handling and retries
- 💾 **Storage** - Local and secure storage services
- ✅ **Validators** - 20+ built-in form validators
- 🎨 **UI Components** - Ready-to-use widgets
- 🎭 **Theme Manager** - Easy light/dark mode switching
- 📐 **Responsive** - Built-in responsive utilities
- 🛠️ **Extensions** - 40+ helpful extensions

## Installation 📦

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_dev_catalyst: ^1.0.0
```
Then run:

```bash
flutter pub get
```

Quick Start 🚀
Initialize
```dart
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DevCatalyst.initialize(
    apiBaseUrl: 'https://api.example.com',
    enableLogging: true,
  );
  
  runApp(MyApp());
}
```

Use API Client
```dart

// GET request
// GET request
final response = await DevCatalyst.api.get('/users');
if (response.success) {
print(response.data);
}

// POST request
await DevCatalyst.api.post('/users', data: {'name': 'John'});
```
Storage
```dart
// Save data
await DevCatalyst.storage.saveString('key', 'value');

// Get data
final value = DevCatalyst.storage.getString('key');

// Secure storage
await DevCatalyst.secureStorage.saveAuthToken('token');
```

UI Components
```dart
CatalystButton.elevated(
  text: 'Submit',
  onPressed: () {},
)

CatalystTextField(
  label: 'Email',
  validators: [Validators.email],
)

```

Documentation 📚
For detailed documentation, see the API reference.

Example 💡
Check out the example app for complete usage examples.

Contributing 🤝
Contributions are welcome! Please read our contributing guidelines first.

License 📄
This project is licensed under the MIT License - see the LICENSE file for details.

Support ❤️
If you find this package helpful, please give it a ⭐ on GitHub!
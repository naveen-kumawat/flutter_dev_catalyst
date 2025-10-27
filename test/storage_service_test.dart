import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    // Initialize logger for all tests
    CatalystLogger().init(isEnabled: false); // Disable for tests
  });

  group('StorageService Tests', () {
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = StorageService();
      await storageService.init();
    });

    test('Save and retrieve string', () async {
      const key = 'test_key';
      const value = 'test_value';

      await storageService.saveString(key, value);
      final retrieved = storageService.getString(key);

      expect(retrieved, value);
    });

    test('Save and retrieve integer', () async {
      const key = 'test_int';
      const value = 42;

      await storageService.saveInt(key, value);
      final retrieved = storageService.getInt(key);

      expect(retrieved, value);
    });

    test('Save and retrieve boolean', () async {
      const key = 'test_bool';
      const value = true;

      await storageService.saveBool(key, value);
      final retrieved = storageService.getBool(key);

      expect(retrieved, value);
    });

    test('Save and retrieve object', () async {
      const key = 'test_object';
      final value = {'name': 'Test', 'age': 25};

      await storageService.saveObject(key, value);
      final retrieved = storageService.getObject(key);

      expect(retrieved, value);
    });

    test('Contains key returns true for existing key', () async {
      const key = 'existing_key';
      await storageService.saveString(key, 'value');

      expect(storageService.containsKey(key), true);
    });

    test('Contains key returns false for non-existing key', () {
      expect(storageService.containsKey('non_existing_key'), false);
    });

    test('Remove key deletes value', () async {
      const key = 'remove_key';
      await storageService.saveString(key, 'value');
      await storageService.remove(key);

      expect(storageService.containsKey(key), false);
    });

    test('Clear removes all keys', () async {
      await storageService.saveString('key1', 'value1');
      await storageService.saveString('key2', 'value2');
      await storageService.clear();

      expect(storageService.getAllKeys().isEmpty, true);
    });

    test('Get all keys returns correct count', () async {
      await storageService.saveString('key1', 'value1');
      await storageService.saveString('key2', 'value2');
      await storageService.saveString('key3', 'value3');

      expect(storageService.getAllKeys().length, 3);
    });
  });
}

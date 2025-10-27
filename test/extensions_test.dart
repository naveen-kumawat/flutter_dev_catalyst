import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';

void main() {
  setUpAll(() {
    // Initialize logger
    CatalystLogger().init(isEnabled: false);
  });

  group('String Extensions Tests', () {
    test('capitalize works correctly', () {
      expect('hello'.capitalize, 'Hello');
      expect('HELLO'.capitalize, 'Hello');
      expect('hELLO'.capitalize, 'Hello');
    });

    test('capitalizeWords works correctly', () {
      expect('hello world'.capitalizeWords, 'Hello World');
      expect('hello WORLD'.capitalizeWords, 'Hello World');
    });

    test('toCamelCase works correctly', () {
      expect('hello_world'.toCamelCase, 'helloWorld');
      expect('hello-world'.toCamelCase, 'helloWorld');
      expect('hello world'.toCamelCase, 'helloWorld');
    });

    test('toSnakeCase works correctly', () {
      expect('helloWorld'.toSnakeCase, 'hello_world');
      expect('HelloWorld'.toSnakeCase, 'hello_world');
    });

    test('toKebabCase works correctly', () {
      expect('helloWorld'.toKebabCase, 'hello-world');
      expect('HelloWorld'.toKebabCase, 'hello-world');
    });

    test('isEmail works correctly', () {
      expect('test@example.com'.isEmail, true);
      expect('invalid'.isEmail, false);
    });

    test('isPhoneNumber works correctly', () {
      expect('+12345678901'.isPhoneNumber, true);
      expect('abc123'.isPhoneNumber, false);
    });

    test('isUrl works correctly', () {
      expect('https://example.com'.isUrl, true);
      expect('invalid'.isUrl, false);
    });

    test('isNumeric works correctly', () {
      expect('123'.isNumeric, true);
      expect('123.45'.isNumeric, true);
      expect('abc'.isNumeric, false);
    });

    test('truncate works correctly', () {
      expect('Hello World'.truncate(5), 'Hello...');
      expect('Hi'.truncate(5), 'Hi');
    });

    test('reverse works correctly', () {
      expect('hello'.reverse, 'olleh');
      expect('12345'.reverse, '54321');
    });

    test('isPalindrome works correctly', () {
      expect('racecar'.isPalindrome, true);
      expect('hello'.isPalindrome, false);
      expect('A man a plan a canal Panama'.isPalindrome, true);
    });

    test('initials works correctly', () {
      expect('John Doe'.initials, 'JD');
      expect('John'.initials, 'J');
      expect('John Michael Doe'.initials, 'JM');
    });

    test('slugify works correctly', () {
      expect('Hello World!'.slugify, 'hello-world');
      expect('This is a test'.slugify, 'this-is-a-test');
    });
  });
}

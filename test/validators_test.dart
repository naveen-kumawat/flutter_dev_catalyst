import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';

void main() {
  group('Validators Tests', () {
    group('Email Validator', () {
      test('Valid email returns null', () {
        expect(Validators.email('test@example.com'), null);
        expect(Validators.email('user.name@example.co.uk'), null);
        expect(Validators.email('user+tag@example.com'), null);
      });

      test('Invalid email returns error', () {
        expect(Validators.email('invalid'), isNotNull);
        expect(Validators.email('invalid@'), isNotNull);
        expect(Validators.email('@example.com'), isNotNull);
        expect(Validators.email('invalid@.com'), isNotNull);
      });

      test('Empty email returns error', () {
        expect(Validators.email(''), isNotNull);
        expect(Validators.email(null), isNotNull);
      });
    });

    group('Required Validator', () {
      test('Non-empty value returns null', () {
        expect(Validators.required('test'), null);
      });

      test('Empty value returns error', () {
        expect(Validators.required(''), isNotNull);
        expect(Validators.required('   '), isNotNull);
        expect(Validators.required(null), isNotNull);
      });
    });

    group('Password Validator', () {
      test('Valid password returns null', () {
        expect(Validators.password('Password123!'), null);
        expect(Validators.password('MyP@ssw0rd'), null);
      });

      test('Short password returns error', () {
        expect(Validators.password('Pass1!'), isNotNull);
      });

      test('Password without uppercase returns error', () {
        expect(Validators.password('password123!'), isNotNull);
      });

      test('Password without lowercase returns error', () {
        expect(Validators.password('PASSWORD123!'), isNotNull);
      });

      test('Password without number returns error', () {
        expect(Validators.password('Password!'), isNotNull);
      });

      test('Password without special char returns error', () {
        expect(Validators.password('Password123'), isNotNull);
      });
    });

    group('Phone Validator', () {
      test('Valid phone returns null', () {
        expect(Validators.phone('1234567890'), null);
        expect(Validators.phone('+12345678901'), null);
      });

      test('Invalid phone returns error', () {
        expect(Validators.phone('123'), isNotNull); // Too short
        expect(Validators.phone(''), isNotNull); // Empty
      });
    });

    group('URL Validator', () {
      test('Valid URL returns null', () {
        expect(Validators.url('https://example.com'), null);
        expect(Validators.url('http://www.example.com'), null);
        expect(Validators.url('https://example.com/path'), null);
      });

      test('Invalid URL returns error', () {
        expect(Validators.url('example.com'), isNotNull);
        expect(Validators.url('ftp://example.com'), isNotNull);
        expect(Validators.url('invalid'), isNotNull);
      });
    });

    group('MinLength Validator', () {
      test('Valid length returns null', () {
        expect(Validators.minLength('test', 4), null);
        expect(Validators.minLength('testing', 5), null);
      });

      test('Too short returns error', () {
        expect(Validators.minLength('test', 5), isNotNull);
      });
    });

    group('MaxLength Validator', () {
      test('Valid length returns null', () {
        expect(Validators.maxLength('test', 5), null);
        expect(Validators.maxLength('test', 4), null);
      });

      test('Too long returns error', () {
        expect(Validators.maxLength('testing', 5), isNotNull);
      });
    });

    group('Number Validators', () {
      test('Valid number returns null', () {
        expect(Validators.number('123'), null);
        expect(Validators.number('123.45'), null);
      });

      test('Invalid number returns error', () {
        expect(Validators.number('abc'), isNotNull);
      });

      test('Valid integer returns null', () {
        expect(Validators.integer('123'), null);
      });

      test('Invalid integer returns error', () {
        expect(Validators.integer('123.45'), isNotNull);
        expect(Validators.integer('abc'), isNotNull);
      });
    });

    group('Min/Max Value Validators', () {
      test('Valid min value returns null', () {
        expect(Validators.minValue('10', 5), null);
        expect(Validators.minValue('5', 5), null);
      });

      test('Invalid min value returns error', () {
        expect(Validators.minValue('3', 5), isNotNull);
      });

      test('Valid max value returns null', () {
        expect(Validators.maxValue('5', 10), null);
        expect(Validators.maxValue('10', 10), null);
      });

      test('Invalid max value returns error', () {
        expect(Validators.maxValue('15', 10), isNotNull);
      });
    });

    group('Confirm Password Validator', () {
      test('Matching passwords return null', () {
        expect(Validators.confirmPassword('password123', 'password123'), null);
      });

      test('Non-matching passwords return error', () {
        expect(
          Validators.confirmPassword('password123', 'password456'),
          isNotNull,
        );
      });
    });
  });
}

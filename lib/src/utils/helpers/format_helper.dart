import 'package:intl/intl.dart';

/// Format helper for common formatting operations
class FormatHelper {
  /// Format number with thousand separators
  static String number(
    num value, {
    int decimalDigits = 0,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.decimalPattern(locale);
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(value);
  }

  /// Format as currency
  static String currency(
    num value, {
    String symbol = '\$',
    int decimalDigits = 2,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
      locale: locale,
    );
    return formatter.format(value);
  }

  /// Format as percentage
  static String percentage(
    num value, {
    int decimalDigits = 0,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.percentPattern(locale);
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(value / 100);
  }

  /// Format as compact number (1K, 1M, etc.)
  static String compactNumber(num value, {String locale = 'en_US'}) {
    final formatter = NumberFormat.compact(locale: locale);
    return formatter.format(value);
  }

  /// Format bytes to human readable size
  static String bytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';

    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    final i = (bytes.bitLength - 1) ~/ 10;
    final value = bytes / (1 << (i * 10));

    return '${value.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Format duration
  static String duration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Format phone number
  static String phone(String phone, {String format = '(###) ###-####'}) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }

    return phone;
  }

  /// Format credit card number
  static String creditCard(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  /// Mask credit card (show last 4 digits)
  static String maskCreditCard(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return cardNumber;

    return '**** **** **** ${digits.substring(digits.length - 4)}';
  }

  /// Mask email
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email;

    final visibleChars = username.substring(0, 2);
    final maskedPart = '*' * (username.length - 2);

    return '$visibleChars$maskedPart@$domain';
  }

  /// Mask phone number
  static String maskPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return phone;

    final lastFour = digits.substring(digits.length - 4);
    return '***-***-$lastFour';
  }

  /// Format name (capitalize each word)
  static String name(String name) {
    return name
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  /// Format distance
  static String distance(double meters, {bool useMetric = true}) {
    if (useMetric) {
      if (meters < 1000) {
        return '${meters.toStringAsFixed(0)} m';
      } else {
        return '${(meters / 1000).toStringAsFixed(2)} km';
      }
    } else {
      final feet = meters * 3.28084;
      if (feet < 5280) {
        return '${feet.toStringAsFixed(0)} ft';
      } else {
        return '${(feet / 5280).toStringAsFixed(2)} mi';
      }
    }
  }

  /// Format temperature
  static String temperature(double celsius, {bool useCelsius = true}) {
    if (useCelsius) {
      return '${celsius.toStringAsFixed(1)}°C';
    } else {
      final fahrenheit = (celsius * 9 / 5) + 32;
      return '${fahrenheit.toStringAsFixed(1)}°F';
    }
  }

  /// Format ordinal numbers (1st, 2nd, 3rd, etc.)
  static String ordinal(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }

    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  /// Truncate string
  static String truncate(
    String text,
    int maxLength, {
    String ellipsis = '...',
  }) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}$ellipsis';
  }

  /// Format list as comma-separated string
  static String list(List<String> items, {String? lastSeparator}) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items[0];

    final separator = lastSeparator ?? 'and';
    final allButLast = items.sublist(0, items.length - 1).join(', ');
    return '$allButLast $separator ${items.last}';
  }

  /// Pluralize word
  static String pluralize(String word, int count, {String? plural}) {
    if (count == 1) return word;
    return plural ?? '${word}s';
  }

  /// Format as initials
  static String initials(String name, {int maxLength = 2}) {
    final words = name.trim().split(RegExp(r'\s+'));
    return words
        .take(maxLength)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }
}

import 'package:intl/intl.dart';

/// Extension methods for String to provide useful utilities
extension StringExtensions on String {
  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Capitalize first letter of string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(
      ' ',
    ).map((word) => word.isEmpty ? word : word.capitalize).join(' ');
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Remove extra whitespace (multiple spaces become single space)
  String get removeExtraWhitespace => replaceAll(RegExp(r'\s+'), ' ').trim();

  /// Check if string is a valid email
  bool get isEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if string is a valid phone number
  bool get isPhoneNumber {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isUrl {
    return RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    ).hasMatch(this);
  }

  /// Check if string contains only numbers
  bool get isNumeric {
    return RegExp(r'^-?[0-9]+$').hasMatch(this);
  }

  /// Check if string contains only alphabetic characters
  bool get isAlphabetic {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  }

  /// Check if string contains only alphanumeric characters
  bool get isAlphanumeric {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  }

  /// Convert string to double (returns 0.0 if invalid)
  double get toDouble {
    return double.tryParse(this) ?? 0.0;
  }

  /// Convert string to int (returns 0 if invalid)
  int get toInt {
    return int.tryParse(this) ?? 0;
  }

  /// Convert string to DateTime (returns null if invalid)
  DateTime? get toDateTime {
    return DateTime.tryParse(this);
  }

  /// Mask email (show first 2 chars and domain)
  String get maskEmail {
    if (!isEmail) return this;
    final parts = split('@');
    if (parts.length != 2) return this;
    final username = parts[0];
    final domain = parts[1];
    if (username.length <= 2) return this;
    return '${username.substring(0, 2)}${'*' * (username.length - 2)}@$domain';
  }

  /// Mask phone number (show last 4 digits)
  String get maskPhone {
    if (length < 4) return this;
    return '${'*' * (length - 4)}${substring(length - 4)}';
  }

  /// Convert to slug (URL-friendly string)
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[-\s]+'), '-')
        .trim();
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Parse currency string to double
  double get parseCurrency {
    // Remove currency symbols and parse
    final cleanString = replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(cleanString) ?? 0.0;
  }

  /// Format as currency
  String formatAsCurrency({
    String symbol = '\$',
    int decimalDigits = 2,
    String locale = 'en_US',
  }) {
    final number = toDouble;
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
      locale: locale,
    );
    return formatter.format(number);
  }

  /// Format as percentage
  String formatAsPercentage({int decimalDigits = 1}) {
    final number = toDouble;
    final formatter = NumberFormat.percentPattern()
      ..maximumFractionDigits = decimalDigits;
    return formatter.format(number);
  }

  /// Extract numbers from string
  String get extractNumbers {
    return replaceAll(RegExp(r'[^\d]'), '');
  }

  /// Extract letters from string
  String get extractLetters {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  /// Count words in string
  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }

  /// Reverse string
  String get reverse {
    return split('').reversed.join('');
  }

  /// Convert to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '_${match.group(1)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert to camelCase
  String get toCamelCase {
    final words = split(RegExp(r'[-_\s]+'));
    if (words.isEmpty) return this;

    final first = words.first.toLowerCase();
    final rest = words.skip(1).map((word) => word.capitalize);

    return '$first${rest.join('')}';
  }

  /// Convert to PascalCase
  String get toPascalCase {
    return split(RegExp(r'[-_\s]+')).map((word) => word.capitalize).join('');
  }

  /// Check if string is a strong password
  bool get isStrongPassword {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special char
    return length >= 8 &&
        contains(RegExp(r'[A-Z]')) &&
        contains(RegExp(r'[a-z]')) &&
        contains(RegExp(r'[0-9]')) &&
        contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  /// Validate password strength (returns score 0-4)
  int get passwordStrength {
    int score = 0;

    if (length >= 8) score++;
    if (contains(RegExp(r'[A-Z]'))) score++;
    if (contains(RegExp(r'[a-z]'))) score++;
    if (contains(RegExp(r'[0-9]'))) score++;
    if (contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    return score;
  }

  /// Remove HTML tags
  String get removeHtmlTags {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Encode for URL
  String get urlEncode {
    return Uri.encodeComponent(this);
  }

  /// Decode from URL
  String get urlDecode {
    return Uri.decodeComponent(this);
  }
}

/// Extension for nullable strings
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Get string or default value
  String orDefault(String defaultValue) => this ?? defaultValue;

  /// Get string or empty string
  String get orEmpty => this ?? '';
}

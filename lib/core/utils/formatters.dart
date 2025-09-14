import 'package:intl/intl.dart';
import 'constants.dart';
import '../extensions/date_extensions.dart';
import '../extensions/string_extensions.dart';

/// Formatting utilities for the application
class AppFormatters {
  AppFormatters._();

  // Number formatters
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrencyFormatter =
      NumberFormat.compactCurrency(symbol: '\$', decimalDigits: 0);

  static final NumberFormat _percentFormatter = NumberFormat.percentPattern();

  static final NumberFormat _decimalFormatter = NumberFormat('#,##0.00');

  static final NumberFormat _integerFormatter = NumberFormat('#,##0');

  // Date formatters
  static final DateFormat _dateFormatter = DateFormat(AppConstants.dateFormat);
  static final DateFormat _timeFormatter = DateFormat(AppConstants.timeFormat);
  static final DateFormat _dateTimeFormatter = DateFormat(
    AppConstants.dateTimeFormat,
  );
  static final DateFormat _apiDateFormatter = DateFormat(
    AppConstants.apiDateFormat,
  );
  static final DateFormat _apiDateTimeFormatter = DateFormat(
    AppConstants.apiDateTimeFormat,
  );
  static final DateFormat _monthYearFormatter = DateFormat('MMM yyyy');
  static final DateFormat _dayMonthFormatter = DateFormat('dd MMM');
  static final DateFormat _fullDateFormatter = DateFormat(
    'EEEE, MMMM dd, yyyy',
  );

  /// Format currency amount
  static String currency(
    double amount, {
    String? symbol,
    int? decimalDigits,
    String? locale,
  }) {
    if (symbol != null || decimalDigits != null || locale != null) {
      final formatter = NumberFormat.currency(
        symbol: symbol ?? '\$',
        decimalDigits: decimalDigits ?? 2,
        locale: locale,
      );
      return formatter.format(amount);
    }
    return _currencyFormatter.format(amount);
  }

  /// Format currency with specific symbol
  static String currencyWithSymbol(double amount, String currencyCode) {
    final symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'INR': '₹',
      'KRW': '₩',
      'RUB': '₽',
      'BRL': 'R\$',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CHF': 'CHF',
      'SEK': 'kr',
      'NOK': 'kr',
      'DKK': 'kr',
      'PLN': 'zł',
      'CZK': 'Kč',
      'HUF': 'Ft',
      'RON': 'lei',
      'BGN': 'лв',
      'HRK': 'kn',
      'TRY': '₺',
      'AED': 'د.إ',
      'SAR': 'ر.س',
      'QAR': 'ر.ق',
      'KWD': 'د.ك',
      'BHD': 'د.ب',
      'OMR': 'ر.ع',
      'JOD': 'د.ا',
      'LBP': 'ل.ل',
      'EGP': 'ج.م',
      'MAD': 'د.م',
      'TND': 'د.ت',
      'DZD': 'د.ج',
      'LYD': 'د.ل',
      'ZAR': 'R',
      'NGN': '₦',
      'GHS': '₵',
      'KES': 'KSh',
      'UGX': 'USh',
      'TZS': 'TSh',
      'ETB': 'Br',
      'RWF': 'FRw',
      'BWP': 'P',
      'ZMW': 'ZK',
      'AOA': 'Kz',
    };

    final symbol = symbols[currencyCode] ?? currencyCode;
    return currency(amount, symbol: symbol);
  }

  /// Format compact currency (e.g., $1.2K, $5.6M)
  static String compactCurrency(double amount) {
    return _compactCurrencyFormatter.format(amount);
  }

  /// Format percentage
  static String percentage(
    double value, {
    int decimalDigits = 1,
    bool showSign = false,
  }) {
    final formatter = NumberFormat.percentPattern()
      ..maximumFractionDigits = decimalDigits
      ..minimumFractionDigits = decimalDigits;

    final formatted = formatter.format(value);

    if (showSign && value > 0) {
      return '+$formatted';
    }

    return formatted;
  }

  /// Format decimal number
  static String decimal(double value, {int decimalDigits = 2}) {
    if (decimalDigits == 0) {
      return _integerFormatter.format(value);
    }

    final formatter = NumberFormat('#,##0.${'0' * decimalDigits}');
    return formatter.format(value);
  }

  /// Format integer
  static String integer(int value) {
    return _integerFormatter.format(value);
  }

  /// Format date
  static String date(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Format time
  static String time(DateTime time) {
    return _timeFormatter.format(time);
  }

  /// Format date and time
  static String dateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  /// Format date for API
  static String apiDate(DateTime date) {
    return _apiDateFormatter.format(date);
  }

  /// Format date time for API
  static String apiDateTime(DateTime dateTime) {
    return _apiDateTimeFormatter.format(dateTime);
  }

  /// Format month and year
  static String monthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  /// Format day and month
  static String dayMonth(DateTime date) {
    return _dayMonthFormatter.format(date);
  }

  /// Format full date
  static String fullDate(DateTime date) {
    return _fullDateFormatter.format(date);
  }

  /// Format relative date (e.g., "2 days ago", "Today", "Tomorrow")
  static String relativeDate(DateTime date) {
    if (date.isToday) return 'Today';
    if (date.isYesterday) return 'Yesterday';
    if (date.isTomorrow) return 'Tomorrow';

    return date.relativeTime;
  }

  /// Format date range
  static String dateRange(DateTime startDate, DateTime endDate) {
    if (startDate.year == endDate.year) {
      if (startDate.month == endDate.month) {
        // Same month and year
        return '${DateFormat('MMM d').format(startDate)} - ${DateFormat('d, yyyy').format(endDate)}';
      } else {
        // Same year, different months
        return '${DateFormat('MMM d').format(startDate)} - ${DateFormat('MMM d, yyyy').format(endDate)}';
      }
    } else {
      // Different years
      return '${DateFormat('MMM d, yyyy').format(startDate)} - ${DateFormat('MMM d, yyyy').format(endDate)}';
    }
  }

  /// Format file size
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format duration
  static String duration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours == 1 ? '' : 's'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes == 1 ? '' : 's'}';
    } else {
      return '${duration.inSeconds} second${duration.inSeconds == 1 ? '' : 's'}';
    }
  }

  /// Format phone number
  static String phoneNumber(String phone) {
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length == 10) {
      // US format: (XXX) XXX-XXXX
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      // US format with country code: +1 (XXX) XXX-XXXX
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }

    // Return original if format not recognized
    return phone;
  }

  /// Format card number
  static String formatCardNumber(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    return buffer.toString();
  }

  /// Mask card number (show only last 4 digits)
  static String maskCardNumber(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length < 4) return cardNumber;

    final masked =
        '*' * (digits.length - 4) + digits.substring(digits.length - 4);
    return formatCardNumber(masked);
  }

  /// Format account number (mask middle digits)
  static String maskAccountNumber(String accountNumber) {
    if (accountNumber.length <= 6) return accountNumber;

    final start = accountNumber.substring(0, 3);
    final end = accountNumber.substring(accountNumber.length - 3);
    final middle = '*' * (accountNumber.length - 6);

    return '$start$middle$end';
  }

  /// Format list as comma-separated string
  static String list(List<String> items, {String? lastSeparator}) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first;
    if (items.length == 2) {
      return '${items.first} ${lastSeparator ?? 'and'} ${items.last}';
    }

    final allButLast = items.take(items.length - 1).join(', ');
    return '$allButLast, ${lastSeparator ?? 'and'} ${items.last}';
  }

  /// Format ordinal numbers (1st, 2nd, 3rd, etc.)
  static String ordinal(int number) {
    final suffix = _getOrdinalSuffix(number);
    return '$number$suffix';
  }

  static String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) return 'th';

    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Format initials from name
  static String initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '';

    final buffer = StringBuffer();
    for (final word in words.take(2)) {
      if (word.isNotEmpty) {
        buffer.write(word[0].toUpperCase());
      }
    }

    return buffer.toString();
  }

  /// Format budget status
  static String budgetStatus(double spent, double budget) {
    final percentage = (spent / budget) * 100;

    if (percentage >= 100) {
      return 'Over Budget';
    } else if (percentage >= 90) {
      return 'Nearly Exceeded';
    } else if (percentage >= 75) {
      return 'On Track';
    } else if (percentage >= 50) {
      return 'Good Progress';
    } else {
      return 'Just Started';
    }
  }

  /// Format transaction type
  static String transactionType(String type) {
    switch (type.toLowerCase()) {
      case 'income':
        return 'Income';
      case 'expense':
        return 'Expense';
      default:
        return type.capitalize;
    }
  }

  /// Format currency code
  static String currencyCode(String code) {
    return code.toUpperCase();
  }

  /// Format amount with sign
  static String amountWithSign(double amount, String type) {
    final formattedAmount = currency(amount.abs());

    switch (type.toLowerCase()) {
      case 'income':
        return '+$formattedAmount';
      case 'expense':
        return '-$formattedAmount';
      default:
        return formattedAmount;
    }
  }

  /// Format change amount with sign and color indication
  static String changeAmount(double amount) {
    final formattedAmount = currency(amount.abs());

    if (amount > 0) {
      return '+$formattedAmount';
    } else if (amount < 0) {
      return '-$formattedAmount';
    } else {
      return formattedAmount;
    }
  }
}

import 'package:intl/intl.dart';

/// Extension methods for DateTime to provide useful utilities
extension DateTimeExtensions on DateTime {
  /// Format date as dd/MM/yyyy
  String get formatAsDate => DateFormat('dd/MM/yyyy').format(this);

  /// Format time as HH:mm
  String get formatAsTime => DateFormat('HH:mm').format(this);

  /// Format as dd/MM/yyyy HH:mm
  String get formatAsDateTime => DateFormat('dd/MM/yyyy HH:mm').format(this);

  /// Format as MMM dd, yyyy (e.g., Jan 15, 2024)
  String get formatAsReadableDate => DateFormat('MMM dd, yyyy').format(this);

  /// Format as full date (e.g., Monday, January 15, 2024)
  String get formatAsFullDate => DateFormat('EEEE, MMMM dd, yyyy').format(this);

  /// Format with custom pattern
  String format(String pattern) => DateFormat(pattern).format(this);

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is this year
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  /// Get start of day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    final daysToSubtract = weekday - 1;
    return subtract(Duration(days: daysToSubtract)).startOfDay;
  }

  /// Get end of week (Sunday)
  DateTime get endOfWeek {
    final daysToAdd = 7 - weekday;
    return add(Duration(days: daysToAdd)).endOfDay;
  }

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get start of year
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Get end of year
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  /// Get relative time (e.g., "2 hours ago", "in 3 days")
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      // Future date
      final futureDiff = this.difference(now);
      if (futureDiff.inDays > 0) {
        return 'in ${futureDiff.inDays} day${futureDiff.inDays == 1 ? '' : 's'}';
      } else if (futureDiff.inHours > 0) {
        return 'in ${futureDiff.inHours} hour${futureDiff.inHours == 1 ? '' : 's'}';
      } else if (futureDiff.inMinutes > 0) {
        return 'in ${futureDiff.inMinutes} minute${futureDiff.inMinutes == 1 ? '' : 's'}';
      } else {
        return 'in a moment';
      }
    } else {
      // Past date
      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'just now';
      }
    }
  }

  /// Get time ago in short format (e.g., "2h", "3d")
  String get timeAgoShort {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  /// Get age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Add business days (excluding weekends)
  DateTime addBusinessDays(int days) {
    DateTime result = this;
    int addedDays = 0;

    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        addedDays++;
      }
    }

    return result;
  }

  /// Check if date is weekend
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Check if date is weekday
  bool get isWeekday => !isWeekend;

  /// Get quarter of year (1-4)
  int get quarter {
    return ((month - 1) / 3).floor() + 1;
  }

  /// Get week of year
  int get weekOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    final dayOfYear = difference(firstDayOfYear).inDays + 1;
    final firstWeekday = firstDayOfYear.weekday;

    return ((dayOfYear + firstWeekday - 2) / 7).floor() + 1;
  }

  /// Check if year is leap year
  bool get isLeapYear {
    return (year % 4 == 0) && (year % 100 != 0 || year % 400 == 0);
  }

  /// Get days in month
  int get daysInMonth {
    return DateTime(year, month + 1, 0).day;
  }

  /// Get name of month
  String get monthName => DateFormat('MMMM').format(this);

  /// Get abbreviated month name
  String get monthAbbr => DateFormat('MMM').format(this);

  /// Get name of weekday
  String get weekdayName => DateFormat('EEEE').format(this);

  /// Get abbreviated weekday name
  String get weekdayAbbr => DateFormat('E').format(this);

  /// Copy with specific components
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// Convert to UTC if not already
  DateTime get utc => isUtc ? this : toUtc();

  /// Convert to local if not already
  DateTime get local => isUtc ? toLocal() : this;

  /// Get Unix timestamp (seconds since epoch)
  int get unixTimestamp => millisecondsSinceEpoch ~/ 1000;

  /// Check if date is between two dates (inclusive)
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start.subtract(const Duration(milliseconds: 1))) &&
        isBefore(end.add(const Duration(milliseconds: 1)));
  }

  /// Get the difference in business days
  int businessDaysDifference(DateTime other) {
    final start = isBefore(other) ? this : other;
    final end = isBefore(other) ? other : this;

    int count = 0;
    DateTime current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (current.isWeekday) {
        count++;
      }
      current = current.add(const Duration(days: 1));
    }

    return count;
  }
}

/// Extension for nullable DateTime
extension NullableDateTimeExtensions on DateTime? {
  /// Check if date is null
  bool get isNull => this == null;

  /// Check if date is not null
  bool get isNotNull => this != null;

  /// Get date or default value
  DateTime orDefault(DateTime defaultValue) => this ?? defaultValue;

  /// Get date or current time
  DateTime get orNow => this ?? DateTime.now();

  /// Format with null safety
  String formatOrEmpty(String pattern) {
    return this?.format(pattern) ?? '';
  }

  /// Get relative time with null safety
  String get relativeTimeOrEmpty => this?.relativeTime ?? '';
}

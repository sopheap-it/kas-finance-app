import 'constants.dart';

/// Form validation utilities
class Validators {
  Validators._();

  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be no more than ${AppConstants.maxPasswordLength} characters';
    }

    return null;
  }

  /// Strong password validation
  static String? strongPassword(String? value) {
    final basicValidation = password(value);
    if (basicValidation != null) return basicValidation;

    if (value == null) return null;

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Name validation
  static String? name(String? value, [String? fieldName]) {
    final requiredCheck = required(value, fieldName);
    if (requiredCheck != null) return requiredCheck;

    if (value!.length < 2) {
      return '${fieldName ?? 'Name'} must be at least 2 characters';
    }

    if (value.length > 50) {
      return '${fieldName ?? 'Name'} must be no more than 50 characters';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return '${fieldName ?? 'Name'} can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  /// Phone number validation
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Amount validation
  static String? amount(String? value, {double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(value.replaceAll(RegExp(r'[^\d.-]'), ''));
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than zero';
    }

    if (min != null && amount < min) {
      return 'Amount must be at least \$${min.toStringAsFixed(2)}';
    }

    if (max != null && amount > max) {
      return 'Amount must be no more than \$${max.toStringAsFixed(2)}';
    }

    return null;
  }

  /// Transaction amount validation
  static String? transactionAmount(String? value) {
    return amount(
      value,
      min: AppConstants.minTransactionAmount,
      max: AppConstants.maxTransactionAmount,
    );
  }

  /// Budget amount validation
  static String? budgetAmount(String? value) {
    return amount(
      value,
      min: AppConstants.minBudgetAmount,
      max: AppConstants.maxBudgetAmount,
    );
  }

  /// Transaction title validation
  static String? transactionTitle(String? value) {
    final requiredCheck = required(value, 'Transaction title');
    if (requiredCheck != null) return requiredCheck;

    if (value!.length > AppConstants.maxTransactionTitleLength) {
      return 'Title must be no more than ${AppConstants.maxTransactionTitleLength} characters';
    }

    return null;
  }

  /// Transaction description validation
  static String? transactionDescription(String? value) {
    if (value != null &&
        value.length > AppConstants.maxTransactionDescriptionLength) {
      return 'Description must be no more than ${AppConstants.maxTransactionDescriptionLength} characters';
    }

    return null;
  }

  /// Budget name validation
  static String? budgetName(String? value) {
    final requiredCheck = required(value, 'Budget name');
    if (requiredCheck != null) return requiredCheck;

    if (value!.length > AppConstants.maxBudgetNameLength) {
      return 'Budget name must be no more than ${AppConstants.maxBudgetNameLength} characters';
    }

    return null;
  }

  /// Budget description validation
  static String? budgetDescription(String? value) {
    if (value != null &&
        value.length > AppConstants.maxBudgetDescriptionLength) {
      return 'Description must be no more than ${AppConstants.maxBudgetDescriptionLength} characters';
    }

    return null;
  }

  /// Category name validation
  static String? categoryName(String? value) {
    final requiredCheck = required(value, 'Category name');
    if (requiredCheck != null) return requiredCheck;

    if (value!.length > AppConstants.maxCategoryNameLength) {
      return 'Category name must be no more than ${AppConstants.maxCategoryNameLength} characters';
    }

    return null;
  }

  /// PIN validation
  static String? pin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }

    if (value.length != 4 && value.length != 6) {
      return 'PIN must be 4 or 6 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'PIN can only contain numbers';
    }

    // Check for simple patterns
    if (RegExp(r'^(\d)\1+$').hasMatch(value)) {
      return 'PIN cannot be all the same digit';
    }

    if (value == '1234' || value == '0000' || value == '1111') {
      return 'PIN is too simple';
    }

    return null;
  }

  /// Date validation
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return 'Please enter a valid date';
    }

    return null;
  }

  /// Future date validation
  static String? futureDate(String? value) {
    final dateCheck = date(value);
    if (dateCheck != null) return dateCheck;

    final dateValue = DateTime.parse(value!);
    if (dateValue.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }

    return null;
  }

  /// Past date validation
  static String? pastDate(String? value) {
    final dateCheck = date(value);
    if (dateCheck != null) return dateCheck;

    final dateValue = DateTime.parse(value!);
    if (dateValue.isAfter(DateTime.now())) {
      return 'Date must be in the past';
    }

    return null;
  }

  /// Date range validation
  static String? dateRange(String? startDate, String? endDate) {
    if (startDate == null || endDate == null) {
      return 'Both start and end dates are required';
    }

    final start = DateTime.tryParse(startDate);
    final end = DateTime.tryParse(endDate);

    if (start == null || end == null) {
      return 'Please enter valid dates';
    }

    if (start.isAfter(end)) {
      return 'Start date must be before end date';
    }

    return null;
  }

  /// URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Custom length validation
  static String? length(String? value, int min, int max, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.length < min) {
      return '${fieldName ?? 'This field'} must be at least $min characters';
    }

    if (value.length > max) {
      return '${fieldName ?? 'This field'} must be no more than $max characters';
    }

    return null;
  }

  /// Combine multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}

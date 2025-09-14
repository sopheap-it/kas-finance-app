/// Application constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'KAS Finance';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Personal Finance Management App';

  // API Configuration
  static const String baseUrl = 'https://api.kasfinance.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int apiRetryAttempts = 3;

  // Database Configuration
  static const String databaseName = 'kas_finance.db';
  static const int databaseVersion = 1;

  // Local Storage Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String currencyKey = 'default_currency';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String pinEnabledKey = 'pin_enabled';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String guestModeKey = 'guest_mode';

  // Secure Storage Keys
  static const String userPinKey = 'user_pin';
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  static const double circleBorderRadius = 50.0;

  static const double defaultElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double highElevation = 8.0;

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Currency Configuration
  static const String defaultCurrency = 'USD';
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'SEK',
    'NZD',
    'MXN',
    'SGD',
    'HKD',
    'NOK',
    'TRY',
    'RUB',
    'INR',
    'BRL',
    'ZAR',
    'KRW',
    'DKK',
    'PLN',
    'TWD',
    'THB',
    'MYR',
    'IDR',
    'PHP',
    'VND',
    'AED',
    'SAR',
    'EGP',
    'KES',
    'NGN',
    'GHS',
    'MAD',
    'TND',
    'DZD',
    'LYD',
    'ETB',
    'UGX',
    'TZS',
    'RWF',
    'BWP',
    'ZMW',
    'AOA',
  ];

  // Date & Time Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';

  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const int maxTransactionTitleLength = 100;
  static const int maxTransactionDescriptionLength = 500;
  static const int maxBudgetNameLength = 50;
  static const int maxBudgetDescriptionLength = 200;
  static const int maxCategoryNameLength = 30;

  // Numeric Limits
  static const double maxTransactionAmount = 999999999.99;
  static const double minTransactionAmount = 0.01;
  static const double maxBudgetAmount = 999999999.99;
  static const double minBudgetAmount = 0.01;

  // File Configuration
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
  ];
  static const List<String> allowedDocumentExtensions = [
    'pdf',
    'doc',
    'docx',
    'txt',
  ];

  // Notification Configuration
  static const String notificationChannelId = 'kas_finance_notifications';
  static const String notificationChannelName = 'KAS Finance Notifications';
  static const String notificationChannelDescription =
      'Notifications for budget alerts and reminders';

  // Firebase Configuration
  static const String firebaseCollectionUsers = 'users';
  static const String firebaseCollectionTransactions = 'transactions';
  static const String firebaseCollectionBudgets = 'budgets';
  static const String firebaseCollectionCategories = 'categories';

  // Error Messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'Please check your internet connection and try again.';
  static const String authErrorMessage =
      'Authentication failed. Please sign in again.';
  static const String permissionErrorMessage =
      'Permission denied. Please grant the required permissions.';

  // Success Messages
  static const String transactionAddedMessage =
      'Transaction added successfully!';
  static const String transactionUpdatedMessage =
      'Transaction updated successfully!';
  static const String transactionDeletedMessage =
      'Transaction deleted successfully!';
  static const String budgetCreatedMessage = 'Budget created successfully!';
  static const String budgetUpdatedMessage = 'Budget updated successfully!';
  static const String budgetDeletedMessage = 'Budget deleted successfully!';

  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableCloudSync = true;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableGuestMode = true;
  static const bool enableExportFeature = true;
  static const bool enableReceiptScanning = false; // Future feature

  // Chart Configuration
  static const int maxChartDataPoints = 365; // One year of daily data
  static const int defaultChartDataPoints = 30; // One month
  static const double chartAnimationDuration = 1.5; // seconds

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Configuration
  static const Duration cacheValidityDuration = Duration(hours: 1);
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB

  // Security Configuration
  static const int maxFailedLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration pinTimeout = Duration(minutes: 5);

  // Export Configuration
  static const List<String> exportFormats = ['CSV', 'PDF', 'Excel'];
  static const String defaultExportFormat = 'CSV';
  static const int maxExportRecords = 10000;

  // Backup Configuration
  static const Duration autoBackupInterval = Duration(days: 7);
  static const int maxBackupFiles = 5;
  static const String backupFileExtension = '.kasbackup';
}

/// Environment-specific constants
class EnvironmentConfig {
  EnvironmentConfig._();

  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';

  static String get apiBaseUrl {
    switch (environment) {
      case 'production':
        return 'https://api.kasfinance.com';
      case 'staging':
        return 'https://staging-api.kasfinance.com';
      default:
        return 'https://dev-api.kasfinance.com';
    }
  }

  static bool get enableLogging => !isProduction;
  static bool get enableDebugMode => isDevelopment;
}

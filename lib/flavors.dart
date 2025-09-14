/// App flavors configuration for different environments
enum Flavor { development, staging, production }

class FlavorValues {
  final String baseUrl;
  final String appName;
  final String packageName;
  final bool showDebugBanner;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool enableCrashReporting;

  const FlavorValues({
    required this.baseUrl,
    required this.appName,
    required this.packageName,
    required this.showDebugBanner,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.enableCrashReporting,
  });
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final FlavorValues values;

  static FlavorConfig? _instance;

  factory FlavorConfig({required Flavor flavor, required FlavorValues values}) {
    _instance = FlavorConfig._internal(flavor, flavor.name, values);
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.name, this.values);

  static FlavorConfig get instance => _instance ?? _createDefault();

  static FlavorConfig _createDefault() {
    return FlavorConfig(
      flavor: Flavor.development,
      values: const FlavorValues(
        baseUrl: 'https://dev-api.kasfinance.com',
        appName: 'KAS Finance Dev',
        packageName: 'com.kasfinance.app.dev',
        showDebugBanner: true,
        enableLogging: true,
        enableAnalytics: false,
        enableCrashReporting: false,
      ),
    );
  }

  static bool get isProduction => _instance?.flavor == Flavor.production;
  static bool get isStaging => _instance?.flavor == Flavor.staging;
  static bool get isDevelopment => _instance?.flavor == Flavor.development;
}

/// Flavor configurations for each environment
class FlavorConfigs {
  static const FlavorValues development = FlavorValues(
    baseUrl: 'https://dev-api.kasfinance.com',
    appName: 'KAS Finance Dev',
    packageName: 'com.kasfinance.app.dev',
    showDebugBanner: true,
    enableLogging: true,
    enableAnalytics: false,
    enableCrashReporting: false,
  );

  static const FlavorValues staging = FlavorValues(
    baseUrl: 'https://staging-api.kasfinance.com',
    appName: 'KAS Finance Staging',
    packageName: 'com.kasfinance.app.staging',
    showDebugBanner: true,
    enableLogging: true,
    enableAnalytics: true,
    enableCrashReporting: true,
  );

  static const FlavorValues production = FlavorValues(
    baseUrl: 'https://api.kasfinance.com',
    appName: 'KAS Finance',
    packageName: 'com.kasfinance.app',
    showDebugBanner: false,
    enableLogging: false,
    enableAnalytics: true,
    enableCrashReporting: true,
  );
}

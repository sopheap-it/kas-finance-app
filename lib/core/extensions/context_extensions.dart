import 'package:flutter/material.dart';

/// Extension methods for BuildContext to provide easy access to common properties
extension ContextExtensions on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);

  /// Get the current color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get the current text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get screen padding
  EdgeInsets get padding => mediaQuery.padding;

  /// Get view insets (keyboard height)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Get safe area padding
  EdgeInsets get safePadding => mediaQuery.padding;

  /// Check if device is in dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Check if device is in light mode
  bool get isLightMode => !isDarkMode;

  /// Get device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Check if device is a tablet (width > 768)
  bool get isTablet => screenWidth > 768;

  /// Check if device is a phone
  bool get isPhone => !isTablet;

  /// Get orientation
  Orientation get orientation => mediaQuery.orientation;

  /// Check if device is in landscape mode
  bool get isLandscape => orientation == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait => orientation == Orientation.portrait;

  /// Get the navigator
  NavigatorState get navigator => Navigator.of(this);

  /// Get the scaffold messenger
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Get the focus scope
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Show a snackbar with message
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(message, backgroundColor: colorScheme.error);
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }

  /// Show warning snackbar
  void showWarningSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.orange);
  }

  /// Unfocus current focus node
  void unfocus() {
    focusScope.unfocus();
  }

  /// Pop the current route
  void pop<T>([T? result]) {
    navigator.pop(result);
  }

  /// Push a new route
  Future<T?> push<T>(Widget page) {
    return navigator.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  /// Push and replace the current route
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return navigator.pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push and remove all previous routes
  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return navigator.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Show a modal bottom sheet
  Future<T?> showAppModalBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => child,
    );
  }

  /// Show a dialog
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => child,
    );
  }
}

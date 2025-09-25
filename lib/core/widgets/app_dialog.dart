import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

/// A customizable dialog widget with easy-to-use API
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.content,
    this.icon,
    this.actions,
    this.contentWidget,
    this.barrierDismissible = true,
    this.backgroundColor,
    this.elevation = 24,
    this.borderRadius = 24,
    this.titleStyle,
    this.contentStyle,
    this.maxWidth = 400,
  });

  final String title;
  final String? content;
  final Widget? contentWidget;
  final IconData? icon;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final Color? backgroundColor;
  final double elevation;
  final double borderRadius;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? context.colorScheme.surface,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          // Prevent overflow on small screens by limiting height
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                if (icon != null) ...[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Icon(
                      icon,
                      color: context.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Title
                Text(
                  title,
                  style:
                      titleStyle ??
                      context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                // Content
                if (content != null || contentWidget != null) ...[
                  const SizedBox(height: 16),
                  if (contentWidget != null)
                    contentWidget!
                  else
                    Text(
                      content!,
                      style:
                          contentStyle ??
                          context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurface.withOpacity(
                              0.7,
                            ),
                          ),
                      textAlign: TextAlign.center,
                    ),
                ],

                // Actions
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Show a confirmation dialog
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? confirmColor,
    bool isDangerous = false,
  }) {
    return context.showAppDialog<bool>(
      barrierDismissible: false,
      child: AppDialog(
        title: title,
        content: message,
        icon: icon ?? (isDangerous ? Icons.warning : Icons.help_outline),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(cancelText),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous
                  ? context.colorScheme.error
                  : confirmColor ?? context.colorScheme.primary,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show an information dialog
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
  }) {
    return context.showAppDialog<void>(
      child: AppDialog(
        title: title,
        content: message,
        icon: icon ?? Icons.info_outline,
        actions: [
          ElevatedButton(
            onPressed: () => context.pop<void>(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Show an error dialog
  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return context.showAppDialog<void>(
      child: AppDialog(
        title: title,
        content: message,
        icon: Icons.error_outline,
        actions: [
          ElevatedButton(
            onPressed: () => context.pop<void>(),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Show a success dialog
  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'Great!',
  }) {
    return context.showAppDialog<void>(
      child: AppDialog(
        title: title,
        content: message,
        icon: Icons.check_circle_outline,
        actions: [
          ElevatedButton(
            onPressed: () => context.pop<void>(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Show a loading dialog
  static Future<void> showLoading(
    BuildContext context, {
    String title = 'Loading...',
    String? message,
  }) {
    return context.showAppDialog<void>(
      barrierDismissible: false,
      child: AppDialog(
        title: title,
        contentWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Show a custom form dialog
  static Future<T?> showForm<T>(
    BuildContext context, {
    required String title,
    required Widget form,
    List<Widget>? actions,
    IconData? icon,
  }) {
    return context.showAppDialog<T>(
      child: AppDialog(
        title: title,
        icon: icon,
        contentWidget: form,
        actions: actions,
      ),
    );
  }
}

/// Easy access methods for dialogs
extension DialogExtensions on BuildContext {
  /// Show confirmation dialog
  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? confirmColor,
    bool isDangerous = false,
  }) {
    return AppDialog.showConfirmation(
      this,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      confirmColor: confirmColor,
      isDangerous: isDangerous,
    );
  }

  /// Show info dialog
  Future<void> showInfoDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
  }) {
    return AppDialog.showInfo(
      this,
      title: title,
      message: message,
      buttonText: buttonText,
      icon: icon,
    );
  }

  /// Show error dialog
  Future<void> showErrorDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return AppDialog.showError(
      this,
      title: title,
      message: message,
      buttonText: buttonText,
    );
  }

  /// Show success dialog
  Future<void> showSuccessDialog({
    required String title,
    required String message,
    String buttonText = 'Great!',
  }) {
    return AppDialog.showSuccess(
      this,
      title: title,
      message: message,
      buttonText: buttonText,
    );
  }

  /// Show loading dialog
  Future<void> showLoadingDialog({
    String title = 'Loading...',
    String? message,
  }) {
    return AppDialog.showLoading(this, title: title, message: message);
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    pop<void>();
  }
}

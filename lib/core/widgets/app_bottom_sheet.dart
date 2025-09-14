import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

/// A customizable bottom sheet widget with easy-to-use API
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.showHandle = true,
    this.isScrollControlled = true,
    this.backgroundColor,
    this.maxHeight,
    this.padding = const EdgeInsets.all(24),
    this.titleStyle,
    this.showCloseButton = false,
  });

  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final bool showHandle;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? maxHeight;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight!)
          : BoxConstraints(maxHeight: context.screenHeight * 0.9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          if (showHandle)
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.outline.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          // Header
          if (title != null || showCloseButton)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style:
                            titleStyle ??
                            context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  if (showCloseButton)
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: context.colorScheme.surfaceVariant,
                        foregroundColor: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),

          // Content
          Flexible(
            child: SingleChildScrollView(padding: padding, child: child),
          ),

          // Actions
          if (actions != null && actions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .expand((action) => [action, const SizedBox(width: 8)])
                    .take(actions!.length * 2 - 1)
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  /// Show a bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool showHandle = true,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? maxHeight,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    TextStyle? titleStyle,
    bool showCloseButton = false,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        title: title,
        child: child,
        actions: actions,
        showHandle: showHandle,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
        maxHeight: maxHeight,
        padding: padding,
        titleStyle: titleStyle,
        showCloseButton: showCloseButton,
      ),
    );
  }

  /// Show a confirmation bottom sheet
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
    return show<bool>(
      context,
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDangerous
                    ? context.colorScheme.error.withOpacity(0.1)
                    : context.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                icon,
                color: isDangerous
                    ? context.colorScheme.error
                    : context.colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(cancelText),
        ),
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
    );
  }

  /// Show a form bottom sheet
  static Future<T?> showForm<T>(
    BuildContext context, {
    required String title,
    required Widget form,
    List<Widget>? actions,
    bool showCloseButton = true,
  }) {
    return show<T>(
      context,
      title: title,
      child: form,
      actions: actions,
      showCloseButton: showCloseButton,
    );
  }

  /// Show a list bottom sheet
  static Future<T?> showList<T>(
    BuildContext context, {
    required String title,
    required List<AppBottomSheetItem<T>> items,
    Widget? header,
    Widget? footer,
  }) {
    return show<T>(
      context,
      title: title,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) ...[
            Padding(padding: const EdgeInsets.all(24), child: header),
            Divider(height: 1, color: context.colorScheme.outline),
          ],
          ...items.map(
            (item) => ListTile(
              leading: item.icon != null ? Icon(item.icon) : null,
              title: Text(item.title),
              subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
              trailing: item.trailing,
              onTap: () => context.pop(item.value),
              enabled: item.enabled,
            ),
          ),
          if (footer != null) ...[
            Divider(height: 1, color: context.colorScheme.outline),
            Padding(padding: const EdgeInsets.all(24), child: footer),
          ],
        ],
      ),
    );
  }

  /// Show an action sheet
  static Future<T?> showActionSheet<T>(
    BuildContext context, {
    String? title,
    String? message,
    required List<AppBottomSheetAction<T>> actions,
    bool showCancel = true,
    String cancelText = 'Cancel',
  }) {
    return show<T>(
      context,
      title: title,
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ...actions.map(
            (action) => ListTile(
              leading: action.icon != null
                  ? Icon(
                      action.icon,
                      color: action.isDestructive
                          ? context.colorScheme.error
                          : null,
                    )
                  : null,
              title: Text(
                action.title,
                style: TextStyle(
                  color: action.isDestructive
                      ? context.colorScheme.error
                      : null,
                  fontWeight: action.isDestructive ? FontWeight.w600 : null,
                ),
              ),
              onTap: () => context.pop(action.value),
              enabled: action.enabled,
            ),
          ),
          if (showCancel) ...[
            Divider(height: 1, color: context.colorScheme.outline),
            ListTile(
              title: Text(
                cancelText,
                style: const TextStyle(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              onTap: () => context.pop(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Item for list bottom sheet
class AppBottomSheetItem<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final T value;
  final bool enabled;

  const AppBottomSheetItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    required this.value,
    this.enabled = true,
  });
}

/// Action for action sheet
class AppBottomSheetAction<T> {
  final String title;
  final IconData? icon;
  final T value;
  final bool isDestructive;
  final bool enabled;

  const AppBottomSheetAction({
    required this.title,
    this.icon,
    required this.value,
    this.isDestructive = false,
    this.enabled = true,
  });
}

/// Easy access methods for bottom sheets
extension BottomSheetExtensions on BuildContext {
  /// Show bottom sheet
  Future<T?> showBottomSheet<T>({
    String? title,
    required Widget child,
    List<Widget>? actions,
    bool showHandle = true,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? maxHeight,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    TextStyle? titleStyle,
    bool showCloseButton = false,
  }) {
    return AppBottomSheet.show<T>(
      this,
      title: title,
      child: child,
      actions: actions,
      showHandle: showHandle,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      maxHeight: maxHeight,
      padding: padding,
      titleStyle: titleStyle,
      showCloseButton: showCloseButton,
    );
  }

  /// Show confirmation bottom sheet
  Future<bool?> showConfirmationBottomSheet({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? confirmColor,
    bool isDangerous = false,
  }) {
    return AppBottomSheet.showConfirmation(
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

  /// Show action sheet
  Future<T?> showActionSheet<T>({
    String? title,
    String? message,
    required List<AppBottomSheetAction<T>> actions,
    bool showCancel = true,
    String cancelText = 'Cancel',
  }) {
    return AppBottomSheet.showActionSheet<T>(
      this,
      title: title,
      message: message,
      actions: actions,
      showCancel: showCancel,
      cancelText: cancelText,
    );
  }
}

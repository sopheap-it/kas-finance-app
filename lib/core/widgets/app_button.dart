import 'package:flutter/material.dart';

/// A customizable button widget with consistent styling
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.elevation,
    this.padding,
    this.textStyle,
    this.loadingColor,
    this.disabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final AppButtonType type;
  final AppButtonSize size;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? loadingColor;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get size configuration
    final sizeConfig = _getSizeConfig();

    // Get type configuration
    final typeConfig = _getTypeConfig(colorScheme);

    final effectiveOnPressed = (disabled || isLoading) ? null : onPressed;

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? typeConfig.backgroundColor,
            foregroundColor: foregroundColor ?? typeConfig.foregroundColor,
            elevation: elevation ?? typeConfig.elevation,
            padding: padding ?? sizeConfig.padding,
            minimumSize: isExpanded ? const Size(double.infinity, 0) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? sizeConfig.borderRadius,
              ),
            ),
            textStyle: textStyle ?? sizeConfig.textStyle,
          ),
          child: _buildContent(sizeConfig),
        );
        break;

      case AppButtonType.secondary:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? typeConfig.foregroundColor,
            backgroundColor: backgroundColor ?? typeConfig.backgroundColor,
            side: BorderSide(
              color:
                  borderColor ??
                  typeConfig.borderColor ??
                  typeConfig.foregroundColor,
            ),
            padding: padding ?? sizeConfig.padding,
            minimumSize: isExpanded ? const Size(double.infinity, 0) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? sizeConfig.borderRadius,
              ),
            ),
            textStyle: textStyle ?? sizeConfig.textStyle,
          ),
          child: _buildContent(sizeConfig),
        );
        break;

      case AppButtonType.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? typeConfig.foregroundColor,
            backgroundColor: backgroundColor ?? typeConfig.backgroundColor,
            padding: padding ?? sizeConfig.padding,
            minimumSize: isExpanded ? const Size(double.infinity, 0) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? sizeConfig.borderRadius,
              ),
            ),
            textStyle: textStyle ?? sizeConfig.textStyle,
          ),
          child: _buildContent(sizeConfig),
        );
        break;
    }

    return button;
  }

  Widget _buildContent(_SizeConfig sizeConfig) {
    if (isLoading) {
      return SizedBox(
        height: sizeConfig.iconSize,
        width: sizeConfig.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            loadingColor ?? Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: sizeConfig.iconSize),
          SizedBox(width: sizeConfig.spacing),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  _SizeConfig _getSizeConfig() {
    switch (size) {
      case AppButtonSize.small:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: 8,
          iconSize: 16,
          spacing: 6,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        );
      case AppButtonSize.medium:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          borderRadius: 12,
          iconSize: 18,
          spacing: 8,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        );
      case AppButtonSize.large:
        return _SizeConfig(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          borderRadius: 16,
          iconSize: 20,
          spacing: 10,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        );
    }
  }

  _TypeConfig _getTypeConfig(ColorScheme colorScheme) {
    switch (type) {
      case AppButtonType.primary:
        return _TypeConfig(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
        );
      case AppButtonType.secondary:
        return _TypeConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          borderColor: colorScheme.outline,
          elevation: 0,
        );
      case AppButtonType.text:
        return _TypeConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          elevation: 0,
        );
    }
  }
}

enum AppButtonType { primary, secondary, text }

enum AppButtonSize { small, medium, large }

class _SizeConfig {
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double iconSize;
  final double spacing;
  final TextStyle textStyle;

  _SizeConfig({
    required this.padding,
    required this.borderRadius,
    required this.iconSize,
    required this.spacing,
    required this.textStyle,
  });
}

class _TypeConfig {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double elevation;

  _TypeConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    required this.elevation,
  });
}

/// Quick access button widgets
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.size = AppButtonSize.medium,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isExpanded: isExpanded,
      type: AppButtonType.primary,
      size: size,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.size = AppButtonSize.medium,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isExpanded: isExpanded,
      type: AppButtonType.secondary,
      size: size,
    );
  }
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.size = AppButtonSize.medium,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isExpanded: isExpanded,
      type: AppButtonType.text,
      size: size,
    );
  }
}

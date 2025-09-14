import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final EdgeInsets? padding;
  final bool enabled;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.decoration,
    this.padding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        padding: padding ?? EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: enabled
              ? (textColor ?? theme.colorScheme.primary)
              : (textColor ?? theme.colorScheme.primary).withOpacity(0.5),
          fontWeight: fontWeight ?? FontWeight.w600,
          fontSize: fontSize ?? 16,
          decoration: decoration,
        ),
      ),
    );
  }
}

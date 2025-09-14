import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final String text;
  final Color? color;
  final double? thickness;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const CustomDivider({
    super.key,
    required this.text,
    this.color,
    this.thickness,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: thickness ?? 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (color ?? theme.colorScheme.onSurface).withOpacity(0.1),
                  (color ?? theme.colorScheme.onSurface).withOpacity(0.3),
                  (color ?? theme.colorScheme.onSurface).withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            text,
            style:
                textStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: (color ?? theme.colorScheme.onSurface).withOpacity(
                    0.6,
                  ),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Expanded(
          child: Container(
            height: thickness ?? 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (color ?? theme.colorScheme.onSurface).withOpacity(0.1),
                  (color ?? theme.colorScheme.onSurface).withOpacity(0.3),
                  (color ?? theme.colorScheme.onSurface).withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final String? linkText;
  final VoidCallback? onLinkTap;
  final Color? activeColor;
  final double? size;
  final bool enabled;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.linkText,
    this.onLinkTap,
    this.activeColor,
    this.size,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: activeColor ?? theme.colorScheme.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: enabled
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              children: linkText != null
                  ? <TextSpan>[
                      TextSpan(
                        text: linkText,
                        style: TextStyle(
                          color: enabled
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: enabled
                            ? (TapGestureRecognizer()..onTap = onLinkTap)
                            : null,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

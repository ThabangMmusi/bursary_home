import 'package:bursary_home_ui/theme/styles.dart';
import 'package:bursary_home_ui/widgets/styled_load_spinner.dart';
import 'package:flutter/material.dart';

class SelectableBtn extends StatelessWidget {
  const SelectableBtn({
    super.key,
    required this.onPressed,
    required this.label,
    required this.isSelected,
    this.isLoading = false,
    this.style,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isSelected;
  final bool isLoading;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    ButtonStyle currentStyle;

    if (isSelected) {
      final ButtonStyle? baseSelectedStyle = theme.filledButtonTheme.style;
      currentStyle = (baseSelectedStyle ?? const ButtonStyle()).copyWith(
        backgroundColor: WidgetStateProperty.all(theme.colorScheme.primary),
        foregroundColor: WidgetStateProperty.all(theme.colorScheme.onPrimary),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Corners.xl),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.med),
        ),
      );
    } else {
      final ButtonStyle? baseUnselectedStyle = theme.outlinedButtonTheme.style;
      currentStyle = (baseUnselectedStyle ?? const ButtonStyle()).copyWith(
        foregroundColor: WidgetStateProperty.all(
          theme.colorScheme.onSurfaceVariant,
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: theme.colorScheme.outline),
        ),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Corners.xl),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.med),
        ),
      );
    }

    if (this.style != null) {
      currentStyle = currentStyle.merge(this.style);
    }

    final effectiveOnPressed = isLoading ? null : onPressed;

    return TextButton(
      onPressed: effectiveOnPressed,
      style: currentStyle,
      child:
          isLoading
              ? StyledLoadSpinner.small(
                valueColor:
                    currentStyle.foregroundColor?.resolve({}) ??
                    (isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant),
              )
              : Text(label),
    );
  }
}

/* 
// Ensure StyledLoadSpinner and its named constructors are defined and theme-aware.
// This is a simplified example.
class StyledLoadSpinner extends StatelessWidget {
  final double size;
  final Color? color; // Allow overriding color

  const StyledLoadSpinner({super.key, required this.size, this.color});

  // Named constructors for common sizes, attempting to infer color from context
  factory StyledLoadSpinner.small({required BuildContext context, Color? color}) {
    final buttonTextStyle = DefaultTextStyle.of(context).style;
    final textSize = buttonTextStyle.fontSize ?? 14.0;
    final spinnerSize = textSize * 1.2; // Slightly larger than text
    return StyledLoadSpinner(
        size: spinnerSize,
        color: color ?? buttonTextStyle.color ?? Theme.of(context).colorScheme.primary);
  }

  factory StyledLoadSpinner.verySmall({required BuildContext context, Color? color}) {
    final buttonTextStyle = DefaultTextStyle.of(context).style;
    final textSize = buttonTextStyle.fontSize ?? 12.0;
    final spinnerSize = textSize * 1.1; // Slightly larger than text
    return StyledLoadSpinner(
        size: spinnerSize,
        color: color ?? buttonTextStyle.color ?? Theme.of(context).colorScheme.primary);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Default spinner color from button's foreground or primary
    final Color finalColor = this.color ??
        DefaultTextStyle.of(context).style.color ?? // From button's text color
        theme.colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: size / 7,
        valueColor: AlwaysStoppedAnimation<Color>(finalColor),
      ),
    );
  }
}
*/

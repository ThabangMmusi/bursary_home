import 'package:bursary_home_ui/theme/styles.dart';
import 'package:bursary_home_ui/widgets/styled_load_spinner.dart';
import 'package:flutter/material.dart';

class DeleteBtn extends StatelessWidget {
  const DeleteBtn({
    super.key,
    required this.onPressed,
    this.label,
    this.icon = Icons.delete_outline,
    this.isLoading = false,
    this.isTextOnly = false,
  });

  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final bool isLoading;
  final bool isTextOnly;

  static String get _defaultLabel => 'Delete';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final String currentLabel = label ?? _defaultLabel;

    final ButtonStyle? baseFilledButtonStyle = theme.filledButtonTheme.style;
    final ButtonStyle deleteButtonStyle =
        (baseFilledButtonStyle ?? const ButtonStyle()).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.disabled))
              return colorScheme.error.withOpacity(0.3);
            return colorScheme.error;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.disabled))
              return colorScheme.onError.withOpacity(0.7);
            return colorScheme.onError;
          }),
          textStyle: WidgetStateProperty.all(
            (baseFilledButtonStyle?.textStyle?.resolve({}) ??
                    textTheme.labelLarge)
                ?.copyWith(color: colorScheme.onError),
          ),
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              horizontal: isTextOnly ? Insets.lg : Insets.med,
              vertical: Insets.sm + 2,
            ),
          ),
          shape:
              baseFilledButtonStyle?.shape ??
              WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Corners.med),
                ),
              ),
        );

    if (isTextOnly || this.icon == null) {
      return FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: deleteButtonStyle,
        child:
            isLoading
                ? StyledLoadSpinner.small(
                  valueColor: deleteButtonStyle.foregroundColor?.resolve({}),
                )
                : Text(currentLabel),
      );
    }

    return FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: deleteButtonStyle,
      icon:
          isLoading
              ? const SizedBox.shrink()
              : Icon(this.icon, size: IconSizes.med * 0.9),
      label:
          isLoading
              ? StyledLoadSpinner.small(
                valueColor: deleteButtonStyle.foregroundColor?.resolve({}),
              )
              : Text(currentLabel),
    );
  }
}

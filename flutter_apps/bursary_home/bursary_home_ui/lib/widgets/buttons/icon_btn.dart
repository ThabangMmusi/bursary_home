import 'package:bursary_home_ui/theme/styles.dart';
import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {
  const IconBtn(
    this.icon, {
    super.key,
    required this.onPressed,
    this.tooltip,
    this.iconSize,
    this.color,
    this.style,
    this.isCompact = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double? iconSize;
  final Color? color;
  final ButtonStyle? style;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    ButtonStyle? baseStyle = theme.iconButtonTheme.style;
    ButtonStyle effectiveStyle =
        baseStyle?.merge(this.style) ?? this.style ?? const ButtonStyle();

    double finalIconSize =
        this.iconSize ?? (isCompact ? IconSizes.med * 0.8 : IconSizes.med);

    if (isCompact) {
      final EdgeInsetsGeometry currentDefaultPadding =
          effectiveStyle.padding?.resolve({}) ?? const EdgeInsets.all(8.0);
      effectiveStyle = effectiveStyle.copyWith(
        padding: WidgetStateProperty.all(
          EdgeInsets.all(
            (currentDefaultPadding.horizontal * 0.75).clamp(
              Insets.xs,
              Insets.sm,
            ),
          ),
        ),
      );
    }

    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      tooltip: tooltip,
      iconSize: finalIconSize,
      color: this.color,
      style: effectiveStyle,
    );
  }
}

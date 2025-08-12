import 'package:flutter/material.dart';

enum AlertType {
  error,
  success,
  warning,
  info,
}

class AlertMessage extends StatelessWidget {
  final String message;
  final AlertType type;

  const AlertMessage({
    super.key,
    required this.message,
    this.type = AlertType.info,
  });

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case AlertType.error:
        return colorScheme.errorContainer;
      case AlertType.success:
        return colorScheme.secondaryContainer; // Using secondary for success
      case AlertType.warning:
        return colorScheme.tertiaryContainer; // Using tertiary for warning
      case AlertType.info:
        return colorScheme.primaryContainer; // Using primary for info
    }
  }

  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case AlertType.error:
        return colorScheme.onErrorContainer;
      case AlertType.success:
        return colorScheme.onSecondaryContainer;
      case AlertType.warning:
        return colorScheme.onTertiaryContainer;
      case AlertType.info:
        return colorScheme.onPrimaryContainer;
    }
  }

  Color _getIconColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case AlertType.error:
        return colorScheme.error;
      case AlertType.success:
        return colorScheme.secondary;
      case AlertType.warning:
        return colorScheme.tertiary;
      case AlertType.info:
        return colorScheme.primary;
    }
  }

  IconData _getIconData(BuildContext context) {
    switch (type) {
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0), // 0.85rem 1.25rem
      margin: const EdgeInsets.only(bottom: 24.0), // 1.5rem
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: _getBackgroundColor(context).withOpacity(0.5)), // Simplified border
      ),
      child: Row(
        children: [
          Icon(
            _getIconData(context),
            color: _getIconColor(context),
            size: 19.2, // 1.2rem
          ),
          const SizedBox(width: 12.0), // 0.75rem
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: _getTextColor(context),
                fontSize: 14.4, // 0.9rem
              ),
            ),
          ),
        ],
      ),
    );
  }
}

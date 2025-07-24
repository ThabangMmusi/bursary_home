import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';

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
    switch (type) {
      case AlertType.error:
        return const Color(0xFFfee2e2); // #fee2e2
      case AlertType.success:
        return const Color(0xFFdcfce7); // #dcfce7
      case AlertType.warning:
        return const Color(0xFFfef3c7); // #fef3c7
      case AlertType.info:
        return const Color(0xFFdbeafe); // #dbeafe
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (type) {
      case AlertType.error:
        return const Color(0xFF991b1b); // #991b1b
      case AlertType.success:
        return const Color(0xFF166534); // #166534
      case AlertType.warning:
        return const Color(0xFF92400e); // #92400e
      case AlertType.info:
        return const Color(0xFF1e40af); // #1e40af
    }
  }

  Color _getIconColor(BuildContext context) {
    switch (type) {
      case AlertType.error:
        return const Color(0xFFdc2626); // #dc2626
      case AlertType.success:
        return AppColors.successColor;
      case AlertType.warning:
        return const Color(0xFFd97706); // #d97706
      case AlertType.info:
        return const Color(0xFF2563eb); // #2563eb
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

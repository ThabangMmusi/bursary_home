import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';

enum UserStatus {
  verified,
  pending,
  unverified,
}

class StatusLabel extends StatelessWidget {
  final UserStatus status;

  const StatusLabel({
    super.key,
    required this.status,
  });

  Color _getBackgroundColor() {
    switch (status) {
      case UserStatus.verified:
        return AppColors.successColor;
      case UserStatus.pending:
        return const Color(0xFFffc107); // #ffc107
      case UserStatus.unverified:
        return AppColors.errorColor;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case UserStatus.verified:
        return AppColors.white;
      case UserStatus.pending:
        return Colors.black;
      case UserStatus.unverified:
        return AppColors.white;
    }
  }

  IconData _getIconData() {
    switch (status) {
      case UserStatus.verified:
        return Icons.check_circle_outline;
      case UserStatus.pending:
        return Icons.hourglass_empty;
      case UserStatus.unverified:
        return Icons.cancel_outlined;
    }
  }

  String _getText() {
    switch (status) {
      case UserStatus.verified:
        return 'Verified';
      case UserStatus.pending:
        return 'Pending Verification';
      case UserStatus.unverified:
        return 'Profile Incomplete';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.8, vertical: 6.4), // 0.4rem 0.8rem
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white.withOpacity(0.75), width: 1.0), // Inner border
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconData(),
            color: _getTextColor(),
            size: 16.0, // Adjust icon size as needed
          ),
          const SizedBox(width: 4.0),
          Text(
            _getText(),
            style: TextStyle(
              color: _getTextColor(),
              fontSize: 0.85 * 16.0, // 0.85rem
            ),
          ),
        ],
      ),
    );
  }
}

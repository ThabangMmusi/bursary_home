import 'package:flutter/material.dart';

enum UserStatus { verified, pending, unverified }

class StatusLabel extends StatelessWidget {
  final UserStatus status;

  const StatusLabel({super.key, required this.status});

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case UserStatus.verified:
        return colorScheme.secondary;
      case UserStatus.pending:
        return colorScheme.tertiary;
      case UserStatus.unverified:
        return colorScheme.error;
    }
  }

  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case UserStatus.verified:
        return colorScheme.onSecondary;
      case UserStatus.pending:
        return colorScheme.onTertiary;
      case UserStatus.unverified:
        return colorScheme.onError;
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
      padding: const EdgeInsets.symmetric(
        horizontal: 12.8,
        vertical: 6.4,
      ), // 0.4rem 0.8rem
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.75),
          width: 1.0,
        ), // Inner border
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconData(),
            color: _getTextColor(context),
            size: 16.0, // Adjust icon size as needed
          ),
          const SizedBox(width: 4.0),
          Text(
            _getText(),
            style: TextStyle(
              color: _getTextColor(context),
              fontSize: 0.85 * 16.0, // 0.85rem
            ),
          ),
        ],
      ),
    );
  }
}

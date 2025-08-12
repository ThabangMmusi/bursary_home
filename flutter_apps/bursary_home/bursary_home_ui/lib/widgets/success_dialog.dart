import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/styles.dart';
import 'package:bursary_home_ui/theme/theme_colors.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onClose;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // 90%
        constraints: const BoxConstraints(maxWidth: 400.0),
        padding: const EdgeInsets.all(32.0), // 2rem
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.secondary,
              size: 64.0, // 4rem
            ),
            const SizedBox(height: 16.0), // 1rem
            Text(
              title,
              style: TextStyles.headlineSmall.copyWith(
                color: Theme.of(context).extension<ThemeColors>()!.primaryColor,
                fontSize: 24.0, // 1.5rem
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0), // 0.5rem
            Text(
              message,
              style: TextStyles.bodyLarge.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16.0, // 1rem
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0), // 1.5rem
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 11.2), // 0.7rem
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: TextStyles.bodyMedium.copyWith(fontSize: 14.4), // 0.9rem
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

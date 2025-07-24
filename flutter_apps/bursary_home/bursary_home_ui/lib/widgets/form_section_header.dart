import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';
import 'package:bursary_home_ui/theme/styles.dart';

class FormSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;

  const FormSectionHeader({
    super.key,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0), // 0.75rem
      margin: const EdgeInsets.only(bottom: 24.0), // 1.5rem
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryColor,
            width: 1.0, // 1px solid rgba(3, 82, 70, 0.1)
          ),
        ),
      ),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0), // 0.5rem
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 1.1 * 16.0, // 1.1em
              ),
            ),
          Text(
            title,
            style: TextStyles.headlineSmall.copyWith(
              color: AppColors.primaryColor,
              fontSize: 1.2 * 16.0, // 1.2rem
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/styles.dart';
import 'package:bursary_home_ui/theme/theme_colors.dart';

class SidebarNavigationItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const SidebarNavigationItem({
    super.key,
    required this.title,
    required this.icon,
    this.isActive = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12.8, vertical: 8.0), // 0.8rem 0.5rem
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).extension<ThemeColors>()!.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).extension<ThemeColors>()!.primaryColor,
              size: 24.0,
            ),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: TextStyles.bodyLarge.copyWith(
                color: isActive ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

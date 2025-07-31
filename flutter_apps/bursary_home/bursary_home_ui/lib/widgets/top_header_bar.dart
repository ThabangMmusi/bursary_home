import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';
import 'package:bursary_home_ui/theme/styles.dart';

class TopHeaderBar extends StatelessWidget {
  final String userName;
  final String userRole;
  final String userProfileImagePath;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onNotificationPressed;

  const TopHeaderBar({
    super.key,
    required this.userName,
    required this.userRole,
    required this.userProfileImagePath,
    this.onSearchChanged,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32.0), // 2rem
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0), // 37.5rem
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search bursaries, applications...',
                hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: const Color(0xFFAAAAAA),
                  size: 16.0,
                ), // 1rem
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyles.bodyLarge,
            ),
          ),
          const SizedBox(width: 16.0), // 1rem
          Row(
            children: [
              InkWell(
                onTap: onNotificationPressed,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: AppColors.white,
                    size: 24.0,
                  ),
                ),
              ),
              const SizedBox(width: 16.0), // 1rem
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userName,
                    style: TextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userRole,
                    style: TextStyles.bodySmall.copyWith(
                      color: const Color(0xFF666666),
                      fontSize: 0.7 * 16.0,
                    ), // 0.7rem
                  ),
                ],
              ),
              const SizedBox(width: 16.0), // 1rem
              CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage(userProfileImagePath),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

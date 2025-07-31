import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';
import 'package:bursary_home_ui/theme/styles.dart';
import 'package:bursary_home_ui/widgets/status_label.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final String userName;
  final String currentDate;
  final UserStatus userStatus;
  final int bursariesAvailableCount;
  final int bursariesDisplayedCount;
  final String headerImagePath;

  const DashboardHeaderWidget({
    super.key,
    required this.userName,
    required this.currentDate,
    required this.userStatus,
    required this.bursariesAvailableCount,
    required this.bursariesDisplayedCount,
    required this.headerImagePath,
  });

  @override
  Widget build(BuildContext context) {
    String bursariesText;
    if (bursariesDisplayedCount < bursariesAvailableCount) {
      bursariesText = 'Showing $bursariesDisplayedCount of $bursariesAvailableCount available bursaries matching your profile';
    } else if (bursariesDisplayedCount == bursariesAvailableCount && bursariesAvailableCount > 0) {
      bursariesText = 'You qualify for $bursariesAvailableCount available bursaries matching your profile';
    } else {
      bursariesText = 'No bursaries available matching your profile';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(24.0), // 1.5rem
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Image.asset(
              headerImagePath,
              fit: BoxFit.contain,
              height: 350, // max-height: 200px
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.8,
                      vertical: 6.4,
                    ), // 0.4rem 0.8rem
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      currentDate,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 0.85 * 16.0, // 0.85rem
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0), // 1rem
                  StatusLabel(status: userStatus),
                ],
              ),
              const SizedBox(height: 16.0), // 1rem
              SizedBox(
                width:
                    MediaQuery.of(context).size.width * 0.55, // max-width: 55%
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,\n$userName!',
                      style: TextStyles.headlineLarge.copyWith(
                        color: AppColors.white,
                        fontSize: 2.2 * 16.0, // 2.2rem
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8.0), // 0.5rem
                    Text(
                      bursariesText,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 1.0 * 16.0, // 1rem
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
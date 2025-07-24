import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';
import 'package:bursary_home_ui/theme/styles.dart';
import 'package:bursary_home_ui/widgets/progress_bar.dart';

enum BursaryCardType {
  available,
  application,
}

class BursaryCard extends StatefulWidget {
  final String title;
  final String provider;
  final String deadline;
  final String fieldOfStudy;
  final double matchPercentage;
  final BursaryCardType type;
  final VoidCallback? onApplyPressed;
  final VoidCallback? onViewDetailsPressed;

  const BursaryCard({
    super.key,
    required this.title,
    required this.provider,
    required this.deadline,
    required this.fieldOfStudy,
    this.matchPercentage = 0.0,
    this.type = BursaryCardType.available,
    this.onApplyPressed,
    this.onViewDetailsPressed,
  });

  @override
  State<BursaryCard> createState() => _BursaryCardState();
}

class _BursaryCardState extends State<BursaryCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onViewDetailsPressed, // Make the whole card tappable for details
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(_isHovering ? 24.0 : 16.0), // 1.5rem : 1rem
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovering ? 0.1 : 0.05),
                blurRadius: _isHovering ? 16.0 : 8.0,
                offset: Offset(0, _isHovering ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyles.titleMedium.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: _isHovering ? 19.2 : 17.6, // 1.2rem : 1.1rem
                      fontWeight: FontWeight.w600,
                    ),
                    child: Text(widget.title),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Provider: ${widget.provider}',
                    style: TextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF666666),
                      fontSize: _isHovering ? 14.4 : 13.6, // 0.9rem : 0.85rem
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Deadline: ${widget.deadline}',
                    style: TextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF444444),
                      fontSize: _isHovering ? 16.0 : 15.2, // 1rem : 0.95rem
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProgressBar(progress: widget.matchPercentage),
                  const SizedBox(height: 8.0),
                  Text(
                    'Match: ${widget.matchPercentage.toInt()}%',
                    style: TextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF666666),
                      fontSize: _isHovering ? 14.4 : 13.6, // 0.9rem : 0.85rem
                    ),
                  ),
                  const SizedBox(height: 16.0), // 1rem
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0), // 0.25rem 0.7rem
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      widget.fieldOfStudy,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 12.8, // 0.8rem
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (widget.type == BursaryCardType.available && widget.onApplyPressed != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onApplyPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF023a31),
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 9.6), // 0.6rem
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          textStyle: TextStyles.bodyMedium.copyWith(fontSize: 14.4), // 0.9rem
                        ).copyWith(
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return const Color(0xFF012a23); // #012a23 on hover
                              }
                              return null;
                            },
                          ),
                        ),
                        child: const Text('Apply Now'),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

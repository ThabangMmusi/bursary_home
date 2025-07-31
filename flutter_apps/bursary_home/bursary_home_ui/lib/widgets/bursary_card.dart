import 'package:bursary_home_ui/widgets/gpa_progress_bar.dart';
import 'package:data_layer/data_layer.dart';
import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';
import 'package:bursary_home_ui/theme/styles.dart';

enum BursaryCardType { available, application }

class BursaryCard extends StatefulWidget {
  final String title;
  final String provider;
  final String deadline;
  final String field;
  final double userGpa;
  final double requiredGpa;
  final BursaryCardType type;
  final ApplicationStatus? status;
  final VoidCallback? onApplyPressed;
  final VoidCallback? onViewDetailsPressed;
  final VoidCallback? onCancelPressed;

  const BursaryCard({
    super.key,
    required this.title,
    required this.provider,
    required this.deadline,
    required this.field,
    required this.userGpa,
    required this.requiredGpa,
    this.type = BursaryCardType.available,
    this.status,
    this.onApplyPressed,
    this.onViewDetailsPressed,
    this.onCancelPressed,
  }) : assert(type == BursaryCardType.application ? status != null : true);

  @override
  State<BursaryCard> createState() => _BursaryCardState();
}

class _BursaryCardState extends State<BursaryCard> {
  bool _isHovering = false;

  Color _getStatusColor(ApplicationStatus? status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.yellow.shade700;
      case ApplicationStatus.processing:
        return Colors.orange.shade700;
      case ApplicationStatus.approved:
        return Colors.green.shade700;
      case ApplicationStatus.rejected:
        return Colors.red.shade700;
      case ApplicationStatus.cancelled:
        return Colors.grey.shade700;
      default:
        return Colors.transparent;
    }
  }

  String _getStatusText(ApplicationStatus? status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.processing:
        return 'Processing';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.cancelled:
        return 'Cancelled';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap:
            widget
                .onViewDetailsPressed, // Make the whole card tappable for details
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(_isHovering ? 18 : 16.0), // 1.5rem : 1rem
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
                  if (widget.status != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Chip(
                        label: Text(_getStatusText(widget.status)),
                        backgroundColor: _getStatusColor(widget.status),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
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
                  GpaProgressBar(
                    userGpa: widget.userGpa,
                    requiredGpa: widget.requiredGpa,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'GPA',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'Required: ${widget.requiredGpa}',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        'Extra: ${(widget.userGpa - widget.requiredGpa).toStringAsFixed(1)}',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0), // 1rem
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ), // 0.25rem 0.7rem
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      widget.field,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 12.8, // 0.8rem
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (widget.type == BursaryCardType.available &&
                      widget.onApplyPressed != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onApplyPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF023a31),
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 9.6,
                          ), // 0.6rem
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          textStyle: TextStyles.bodyMedium.copyWith(
                            fontSize: 14.4,
                          ), // 0.9rem
                        ).copyWith(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>((
                                Set<MaterialState> states,
                              ) {
                                if (states.contains(MaterialState.hovered)) {
                                  return const Color(
                                    0xFF012a23,
                                  ); // #012a23 on hover
                                }
                                return null;
                              }),
                        ),
                        child: const Text('Apply Now'),
                      ),
                    ),
                  if (widget.type == BursaryCardType.application &&
                      widget.onCancelPressed != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onCancelPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 9.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          textStyle: TextStyles.bodyMedium.copyWith(
                            fontSize: 14.4,
                          ),
                        ).copyWith(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>((
                                Set<MaterialState> states,
                              ) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.red[900];
                                }
                                return null;
                              }),
                        ),
                        child: const Text('Cancel'),
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

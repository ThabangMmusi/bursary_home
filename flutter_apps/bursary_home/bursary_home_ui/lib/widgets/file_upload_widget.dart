import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';

class FileUploadWidget extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isRequired;
  final bool isFileSelected;
  final String? selectedFileName;
  final VoidCallback onPressed;

  const FileUploadWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isRequired = false,
    this.isFileSelected = false,
    this.selectedFileName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0), // 1.5rem
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          padding: const EdgeInsets.all(12.0), // 0.75rem
          decoration: BoxDecoration(
            color: isFileSelected
                ? AppColors.successColor.withOpacity(0.05)
                : (isRequired ? AppColors.primaryColor.withOpacity(0.05) : AppColors.white),
            border: Border.all(
              color: isFileSelected
                  ? AppColors.successColor
                  : (isRequired ? AppColors.primaryColor : const Color(0xFFddd).withOpacity(0.2)),
              style: BorderStyle.solid,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: isFileSelected ? AppColors.successColor : AppColors.primaryColor,
                    size: 24.0,
                  ),
                  const SizedBox(width: 8.0), // 0.5rem
                  Expanded(
                    child: Text(
                      selectedFileName ?? label,
                      style: TextStyle(
                        color: isFileSelected ? AppColors.successColor : AppColors.textDark,
                        fontSize: 14.4, // 0.9rem
                        fontWeight: isFileSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isRequired && !isFileSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.6), // 0.1rem 0.4rem
                      decoration: BoxDecoration(
                        color: AppColors.errorColor,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Text(
                        'REQUIRED',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10.4, // 0.65rem
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  if (isFileSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.successColor,
                      size: 20.0,
                    ),
                ],
              ),
              if (!isFileSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, top: 4.0), // Align with text
                  child: Text(
                    hint,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 12.8, // 0.8rem
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

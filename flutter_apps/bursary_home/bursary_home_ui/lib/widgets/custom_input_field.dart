import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const CustomInputField({
    super.key,
    required this.labelText,
    this.icon,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14.4), // 0.9rem
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.textDark, fontSize: 14.4), // 0.9rem
        prefixIcon: icon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0), // Adjust as needed
                child: Icon(
                  icon,
                  color: const Color(0xFFAAAAAA), // #aaa
                  size: 19.2, // 1.2rem
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // 8px 12px
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0), // 6px
          borderSide: const BorderSide(color: Color(0xFFddd)), // 1px solid #ddd
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: Color(0xFFddd)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
      ),
    );
  }
}

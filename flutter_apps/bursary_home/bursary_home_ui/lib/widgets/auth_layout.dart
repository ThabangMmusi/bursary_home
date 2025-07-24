import 'package:bursary_home_ui/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:bursary_home_ui/theme/app_colors.dart';
import 'package:bursary_home_ui/widgets/logo_component.dart';

enum AuthLayoutType { student, provider }

class AuthLayout extends StatelessWidget {
  final Widget formContent;
  final AuthLayoutType type;

  const AuthLayout({
    super.key,
    required this.formContent,
    this.type = AuthLayoutType.student,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 768) {
          // Two-column layout for larger screens
          return Stack(
            children: [
              // Books decoration (conceptual, might need image asset)
              Positioned(
                bottom: -50,
                right: -50,
                child: Image.asset(
                  'assets/images/books.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color:
                          AppColors
                              .backgroundColor, // Background color for left side
                      child: Stack(
                        children: [
                          // Background waves (conceptual, might need custom painter or image)
                          // Positioned.fill(
                          //   child: CustomPaint(
                          //     painter: WavePainter(),
                          //   ),
                          // ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Adjust spacing
                                Spacer(),
                                Image.asset(
                                  type == AuthLayoutType.student
                                      ? 'assets/images/students.png'
                                      : 'assets/images/school_student.png', // Placeholder for provider image
                                  height: constraints.maxHeight * 0.85,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [formContent],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: Insets.med,
                child: Container(
                  margin: EdgeInsets.all(Insets.xl),
                  width: constraints.maxWidth - Insets.xl * 3,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: Shadows.universal,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        type == AuthLayoutType.student
                            ? 'Student Login'
                            : 'Provider Login',
                        style: TextStyles.titleMedium.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      HSpace.xl,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: Insets.med,
                left: Insets.med,
                child: LogoComponent(
                  direction:
                      type == AuthLayoutType.student
                          ? LogoDirection.horizontal
                          : LogoDirection.vertical,
                ),
              ),
            ],
          );
        } else {
          // Single-column layout for smaller screens
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColors.backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: [
                      const LogoComponent(direction: LogoDirection.vertical),
                      const SizedBox(height: 20), // Adjust spacing
                      Image.asset(
                        type == AuthLayoutType.student
                            ? 'assets/images/students.png'
                            : 'assets/images/school_student.png', // Placeholder for provider image
                        height: 200,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: formContent,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

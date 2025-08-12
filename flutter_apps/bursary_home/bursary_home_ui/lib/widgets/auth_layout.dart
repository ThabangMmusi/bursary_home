import 'package:bursary_home_ui/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:bursary_home_ui/widgets/logo_component.dart';
import 'package:bursary_home_ui/theme/theme_colors.dart';
import 'package:bursary_home_ui/enums.dart';

class AuthLayout extends StatelessWidget {
  final Widget formContent;
  final ThemeType themeType; // Changed from AuthLayoutType type;

  const AuthLayout({
    super.key,
    required this.formContent,
    this.themeType = ThemeType.student, // Changed default value
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
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                bottom: -50,
                right:
                    themeType == ThemeType.student
                        ? -50
                        : -250, // Slide off to the right
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
                      // color:
                      //     Theme.of(context)
                      //         .extension<ThemeColors>()!
                      //         .backgroundColor, // Background color for left side
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
                                AnimatedSwitcher(
                                  duration: const Duration(
                                    milliseconds: 800,
                                  ), // Slide in slower
                                  reverseDuration: const Duration(
                                    milliseconds: 1200,
                                  ), // Slide out fast
                                  transitionBuilder: (
                                    Widget child,
                                    Animation<double> animation,
                                  ) {
                                    final offsetAnimation = Tween<Offset>(
                                      begin: const Offset(
                                        -1.5,
                                        0.0,
                                      ), // Appear from left
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Interval(
                                          0.6,
                                          1.0,
                                          curve: Curves.easeOut,
                                        ), // Incoming starts after outgoing
                                      ),
                                    );
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                  child: Image.asset(
                                    themeType == ThemeType.student
                                        ? 'assets/images/students.png'
                                        : 'assets/images/provider_login.png', // Placeholder for provider image
                                    height: constraints.maxHeight * 0.85,
                                    key: ValueKey(
                                      themeType,
                                    ), // Important for AnimatedSwitcher
                                  ),
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800), // New duration
                reverseDuration: const Duration(
                  milliseconds: 1200,
                ), // New reverseDuration
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0.0, -1.0), // Slide from top
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(
                        0.6,
                        1.0,
                        curve: Curves.easeOut,
                      ), // Incoming starts after outgoing
                    ),
                  );
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                child: Padding(
                  key: ValueKey(themeType), // Important for AnimatedSwitcher
                  padding: EdgeInsets.only(left: Insets.lg, top: Insets.xs - 1),
                  child: Container(
                    margin: EdgeInsets.all(Insets.xl),
                    width: constraints.maxWidth - Insets.xl * 3,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: Shadows.universal,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          themeType == ThemeType.student
                              ? 'Student Login'
                              : 'Provider Login',
                          style: TextStyles.titleMedium.copyWith(
                            color:
                                Theme.of(
                                  context,
                                ).extension<ThemeColors>()!.primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        HSpace.xl,
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800), // New duration
                reverseDuration: const Duration(
                  milliseconds: 1200,
                ), // New reverseDuration
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0.0, -1.0), // Slide from top
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Interval(
                        0.6,
                        1.0,
                        curve: Curves.easeOut,
                      ), // Incoming starts after outgoing
                    ),
                  );
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                child: Padding(
                  key: ValueKey(themeType), // Important for AnimatedSwitcher
                  padding: EdgeInsets.all(Insets.lg),
                  child: LogoComponent(
                    direction: LogoDirection.horizontal, // Fixed direction
                  ),
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
                  color:
                      Theme.of(
                        context,
                      ).extension<ThemeColors>()!.backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: [
                      const LogoComponent(direction: LogoDirection.vertical),
                      const SizedBox(height: 20), // Adjust spacing
                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 500,
                        ), // Slide in slower
                        reverseDuration: const Duration(
                          milliseconds: 200,
                        ), // Slide out fast
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                        ) {
                          final offsetAnimation = Tween<Offset>(
                            begin: const Offset(-1.0, 0.0), // Appear from left
                            end: Offset.zero,
                          ).animate(animation);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        child: Image.asset(
                          themeType == ThemeType.student
                              ? 'assets/images/students.png'
                              : 'assets/images/school_student.png', // Placeholder for provider image
                          height: 200,
                          key: ValueKey(
                            themeType,
                          ), // Important for AnimatedSwitcher
                        ),
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

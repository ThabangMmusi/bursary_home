import 'package:bursary_home_ui/widgets/auth_layout.dart';
import 'package:bursary_home_ui/widgets/buttons/buttons.dart';
import 'package:bursary_home_ui/widgets/buttons/secondary_btn.dart';
import 'package:bursary_home_ui/widgets/styled_load_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:ionicons/ionicons.dart';
import 'package:student_app/features/auth/bloc/sign_in_bloc.dart';
import 'package:student_app/features/auth/bloc/app_bloc.dart';
import 'package:student_app/features/auth/bloc/app_state.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppBloc, AppState>(
        listener: (context, appState) {
          if (appState.status == AppStatus.authenticated) {
            context.go('/dashboard');
          } else if (appState.status == AppStatus.unauthenticated) {
            // Stay on login page, or show error if needed
          }
        },
        builder: (context, appState) {
          if (appState.status == AppStatus.loading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [LogoComponent(), VSpace.med, StyledLoadSpinner()],
              ),
            );
          }
          return AuthLayout(
            formContent: Padding(
              padding: EdgeInsets.only(top: Insets.xxl * 2),
              child: AuthFormContainer(
                width: 350.0, // auth-form width
                padding: EdgeInsets.symmetric(
                  horizontal: Insets.xxl,
                  vertical: Insets.xxl,
                ), // 1rem 2rem 1rem 2rem
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Removed LogoComponent here, it's handled by AuthLayout
                    Text(
                      'Get Started', // Updated text
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    VSpace.xs,
                    Text(
                      'Sign in and start financing the future', // Updated text
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    VSpace.xl,
                    BlocBuilder<SignInBloc, SignInState>(
                      builder: (context, signInState) {
                        final bool isLoading =
                            appState.status == AppStatus.loading;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SecondaryBtn(
                                    label: 'Sign in with Google',
                                    icon: Ionicons.logo_google,
                                    onPressed:
                                        isLoading
                                            ? null
                                            : () {
                                              context.read<SignInBloc>().add(
                                                SignInGoogleRequested(),
                                              );
                                            },
                                  ),
                                ),
                              ],
                            ),

                            VSpace.med,
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    'Or',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: const Color(0xFF666666),
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            VSpace.med,
                            Row(
                              children: [
                                Expanded(
                                  child: SecondaryBtn(
                                    label: 'Sign in with Microsoft',
                                    icon: Ionicons.logo_microsoft,
                                    onPressed:
                                        isLoading
                                            ? null
                                            : () {
                                              context.read<SignInBloc>().add(
                                                SignInMicrosoftRequested(),
                                              );
                                            },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

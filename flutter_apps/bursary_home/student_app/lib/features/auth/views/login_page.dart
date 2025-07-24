import 'package:bursary_home_ui/widgets/auth_layout.dart';
import 'package:bursary_home_ui/widgets/buttons/buttons.dart';
import 'package:bursary_home_ui/widgets/buttons/secondary_btn.dart';
import 'package:bursary_home_ui/widgets/styled_load_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:ionicons/ionicons.dart';
import 'package:student_app/features/auth/bloc/sign_in_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthLayout(
        formContent: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state.status == SignInStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication Failed'),
                ),
              );
            }
          },
          child: Padding(
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                    builder: (context, state) {
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
                                      state.status == SignInStatus.loading
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
                                      state.status == SignInStatus.loading
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

                          // if (state.status == SignInStatus.loading)
                          //   const Padding(
                          //     padding: EdgeInsets.all(8.0),
                          //     child: StyledLoadSpinner(),
                          //   ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

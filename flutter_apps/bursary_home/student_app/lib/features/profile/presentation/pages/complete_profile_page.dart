import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/features/profile/bloc/complete_profile_bloc.dart';
import 'package:student_app/features/profile/presentation/widgets/personal_details_card.dart';
import 'package:student_app/features/profile/presentation/widgets/academic_details_form.dart';
import 'package:data_layer/data_layer.dart';
import 'package:student_app/features/auth/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CompleteProfileBloc(
            profileRepository: RepositoryProvider.of<ProfileRepository>(
              context,
            ),
            authBloc: BlocProvider.of<AuthBloc>(context),
          ),
      child: BlocListener<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state.submissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            GoRouter.of(context).go('/dashboard');
          } else if (state.submissionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error submitting profile. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
          builder: (context, state) {
            print('Current Entry Mode: ${state.entryMode}'); // Debug print
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: AuthFormContainer(
                    width: 580, // profile-form width
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LogoComponent(
                          direction: LogoDirection.horizontal,
                        ), // Adjust as needed
                        const SizedBox(height: 24.0),
                        Text(
                          'Complete Your Profile',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: AppColors.primaryColor),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Let us know more about you to enhance your experience.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFF666666)),
                        ),
                        const SizedBox(height: 32.0),
                        const PersonalDetailsCard(),
                        const SizedBox(height: 24),
                        const FormSectionHeader(
                          title: 'Academic Details',
                          icon: Icons.school,
                        ),
                        const SizedBox(height: 16),
                        if (state.entryMode == CompleteProfileEntryMode.none)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<CompleteProfileBloc>().add(
                                      ManualEntrySelected(),
                                    );
                                  },
                                  child: const Text('Enter Manually'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<CompleteProfileBloc>().add(
                                      AIScanInitiated(),
                                    );
                                  },
                                  child: const Text('Read from Document (AI)'),
                                ),
                              ),
                            ],
                          ),
                        if (state.entryMode != CompleteProfileEntryMode.none)
                          AcademicDetailsForm(),
                        if (state.subjects.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed:
                                          state.isSubmitting
                                              ? null
                                              : () {
                                                context
                                                    .read<CompleteProfileBloc>()
                                                    .add(FormSubmitted());
                                              },
                                      child:
                                          state.isSubmitting
                                              ? const CircularProgressIndicator()
                                              : const Text('Submit'),
                                    ),
                                  ),
                                ],
                              ),
                              if (state.submissionSuccess)
                                const Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    'Profile submitted successfully!',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              if (state.submissionError)
                                const Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    'Error submitting profile. Please try again.',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

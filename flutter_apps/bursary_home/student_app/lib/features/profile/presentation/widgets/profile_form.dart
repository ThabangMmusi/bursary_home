import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/features/auth/bloc/app_bloc.dart';
import 'package:student_app/features/auth/bloc/app_state.dart';
import 'package:student_app/features/profile/bloc/complete_profile_bloc.dart';
import 'package:student_app/features/profile/presentation/widgets/personal_details_card.dart';
import 'package:student_app/features/profile/presentation/widgets/academic_details_form.dart';
import 'package:student_app/features/profile/presentation/widgets/company_details_form.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();
  final TextEditingController _taxNumberController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _registrationNumberController.dispose();
    _taxNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        return BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PersonalDetailsCard(),
                const SizedBox(height: 24),
                if (appState.isStudent) ...[
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
                ] else
                  CompanyDetailsForm(
                    companyNameController: _companyNameController,
                    registrationNumberController: _registrationNumberController,
                    taxNumberController: _taxNumberController,
                  ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            state.isSubmitting
                                ? null
                                : () {
                                  if (appState.isStudent) {
                                    context.read<CompleteProfileBloc>().add(
                                      FormSubmitted(),
                                    );
                                  } else {
                                    // context.read<CompleteProfileBloc>().add(
                                    //   ProviderProfileSubmitted(
                                    //     name: state.name,
                                    //     surname: state.surname,
                                    //     companyName:
                                    //         _companyNameController.text,
                                    //     registrationNumber:
                                    //         _registrationNumberController.text,
                                    //     taxNumber: _taxNumberController.text,
                                    //   ),
                                    // );
                                  }
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
            );
          },
        );
      },
    );
  }
}

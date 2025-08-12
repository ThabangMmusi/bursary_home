import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:student_app/features/profile/bloc/profile_bloc.dart';
import 'package:student_app/features/profile/bloc/complete_profile_bloc.dart';
import 'package:student_app/features/profile/presentation/pages/complete_profile_page.dart';
import 'package:data_layer/data_layer.dart';
import 'package:student_app/features/auth/bloc/app_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        print('ProfilePage: Current State Status: ${state.status}');
        print('ProfilePage: Profile Data: ${state.profile}');
        print('ProfilePage: Academic Details: ${state.academicDetails}');

        if (state.status == ProfileStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == ProfileStatus.error) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state.status == ProfileStatus.loaded &&
            state.profile != null) {
          final profile = state.profile!;
          final academicDetails = state.academicDetails;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Profile',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return Dialog(
                              child: BlocProvider(
                                create:
                                    (context) => CompleteProfileBloc(
                                      profileRepository: RepositoryProvider.of<
                                        ProfileRepository
                                      >(context),
                                      appBloc: BlocProvider.of<AppBloc>(
                                        context,
                                      ),
                                    ),
                                child: const CompleteProfilePage(),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                const FormSectionHeader(
                  title: 'Personal Information',
                  icon: Icons.person,
                ),
                Text('Name: ${profile.name ?? 'N/A'}'),
                Text('Surname: ${profile.surname ?? 'N/A'}'),
                Text('Email: ${profile.email ?? 'N/A'}'),
                Text('GPA: ${profile.gpa?.toStringAsFixed(2) ?? 'N/A'}'),
                Text(
                  'Profile Completed: ${profile.hasCompletedProfile ? 'Yes' : 'No'}',
                ),
                const SizedBox(height: 24.0),
                const FormSectionHeader(
                  title: 'Academic Information',
                  icon: Icons.school,
                ),
                if (academicDetails != null) ...[
                  Text(
                    'Qualification: ${academicDetails['qualificationName'] ?? 'N/A'}',
                  ),
                  Text('Subjects:'),
                  if (academicDetails['subjects'] is List) ...[
                    for (var subject
                        in (academicDetails['subjects'] as List)) ...[
                      if (subject is Map) ...[
                        Text(
                          '- ${subject['name'] ?? 'N/A'} (${subject['marks'] ?? 'N/A'})',
                        ),
                      ],
                    ],
                  ],
                ] else ...[
                  const Text('No academic details found.'),
                ],
                const SizedBox(height: 24.0),
                const FormSectionHeader(
                  title: 'Documents',
                  icon: Icons.folder_open,
                ),
                const Text('No documents uploaded yet.'), // Placeholder
              ],
            ),
          );
        } else {
          return const Center(child: Text('No profile data.'));
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:student_app/features/profile/bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ProfileStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state.status == ProfileStatus.loaded && state.profile != null) {
            final profile = state.profile!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Profile',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryColor,
                        ),
                  ),
                  const SizedBox(height: 24.0),
                  FormSectionHeader(
                    title: 'Personal Information',
                    icon: Icons.person,
                  ),
                  // Display personal info (dummy for now)
                  Text('User ID: ${profile.userId}'),
                  Text('Status: ${profile.status}'),
                  const SizedBox(height: 24.0),
                  FormSectionHeader(
                    title: 'Academic Information',
                    icon: Icons.school,
                  ),
                  Text('Student Number: ${profile.extractedData?['student_number'] ?? 'N/A'}'),
                  Text('Institution: ${profile.extractedData?['institution'] ?? 'N/A'}'),
                  Text('Study Program: ${profile.extractedData?['study_program'] ?? 'N/A'}'),
                  Text('Academic Year: ${profile.extractedData?['academic_year'] ?? 'N/A'}'),
                  Text('Average Grade: ${profile.extractedData?['average_grade'] ?? 'N/A'}'),
                  Text('Contact Number: ${profile.extractedData?['contact_number'] ?? 'N/A'}'),
                  const SizedBox(height: 24.0),
                  FormSectionHeader(
                    title: 'Documents',
                    icon: Icons.folder_open,
                  ),
                  Text('Matric Results: ${profile.matricResultsDocUrl != null ? 'Uploaded' : 'Not Uploaded'}'),
                  // TODO: Add more document display/upload options as needed
                ],
              ),
            );
          } else {
            return const Center(child: Text('No profile data.'));
          }
        },
      ),
    );
  }
}

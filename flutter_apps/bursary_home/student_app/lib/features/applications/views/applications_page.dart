import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:student_app/features/applications/bloc/applications_bloc.dart';
import 'package:intl/intl.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TopHeaderBar (reused from dashboard)
          TopHeaderBar(
            userName: 'Student', // Replace with actual user name
            userRole: 'Student',
            userProfileImagePath: 'assets/images/boy white.png',
            onSearchChanged: (query) {
              // TODO: Implement search for applications
            },
            onNotificationPressed: () {
              // TODO: Implement notification logic
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Applications',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textDark,
                        ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: BlocBuilder<ApplicationsBloc, ApplicationsState>(
                      builder: (context, state) {
                        if (state.status == ApplicationsStatus.loading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state.status == ApplicationsStatus.error) {
                          return Center(child: Text('Error: ${state.errorMessage}'));
                        } else if (state.status == ApplicationsStatus.loaded &&
                            state.applications.isNotEmpty) {
                          return GridView.builder(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 24.0,
                              mainAxisSpacing: 24.0,
                            ),
                            itemCount: state.applications.length,
                            itemBuilder: (context, index) {
                              final application = state.applications[index];
                              // You might need to fetch bursary details for each application
                              // or pass them along with the application data.
                              return BursaryCard(
                                title: 'Bursary Name (TODO)', // Placeholder
                                provider: 'Provider Name (TODO)', // Placeholder
                                deadline: DateFormat('d MMM y').format(application.appliedDate), // Using applied date as placeholder
                                fieldOfStudy: 'Field (TODO)', // Placeholder
                                matchPercentage: application.progress,
                                type: BursaryCardType.application,
                                // You can add specific actions for applications here
                                onApplyPressed: () {},
                                onViewDetailsPressed: () {
                                  // TODO: Show application details modal
                                  print('View application details for ${application.id}');
                                },
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text('No applications found.'));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

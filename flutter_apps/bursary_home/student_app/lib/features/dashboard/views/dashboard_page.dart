import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:student_app/features/profile/bloc/profile_bloc.dart';
import 'package:student_app/features/dashboard/bloc/bursary_bloc.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('MMMM d, y').format(DateTime.now());

    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, profileState) {
              String userName = 'User';
              UserStatus userStatus = UserStatus.unverified;

              if (profileState.status == ProfileStatus.loaded &&
                  profileState.profile != null) {
                userName = profileState.profile!.extractedData?['full_name'] ??
                    'User'; // Assuming full_name is extracted
                if (profileState.profile!.status == 'complete') {
                  userStatus = UserStatus.verified; // Simplified for now
                } else if (profileState.profile!.status == 'pending_verification') {
                  userStatus = UserStatus.pending;
                } else {
                  userStatus = UserStatus.unverified;
                }
              }

              return DashboardHeaderSection(
                userName: userName,
                currentDate: formattedDate,
                userStatus: userStatus,
                bursariesAvailable: '8', // Placeholder
                headerImagePath: 'assets/images/boy white.png',
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Bursaries',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.textDark,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to see all bursaries
                        },
                        child: Text(
                          'See all',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: BlocBuilder<BursaryBloc, BursaryState>(
                      builder: (context, bursaryState) {
                        if (bursaryState.status == BursaryStatus.loading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (bursaryState.status == BursaryStatus.error) {
                          return Center(child: Text('Error: ${bursaryState.errorMessage}'));
                        } else if (bursaryState.status == BursaryStatus.loaded &&
                            bursaryState.bursaries.isNotEmpty) {
                          return GridView.builder(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300, // minmax(280px, 1fr)
                              childAspectRatio: 0.8, // Adjust as needed
                              crossAxisSpacing: 24.0, // 1.5rem
                              mainAxisSpacing: 24.0, // 1.5rem
                            ),
                            itemCount: bursaryState.bursaries.length,
                            itemBuilder: (context, index) {
                              final bursary = bursaryState.bursaries[index];
                              return BursaryCard(
                                title: bursary.name,
                                provider: bursary.provider,
                                deadline: DateFormat('d MMM y').format(bursary.deadline),
                                fieldOfStudy: bursary.fieldOfStudy,
                                matchPercentage: bursary.gpaRequirement * 10, // Example
                                onApplyPressed: () {
                                  // TODO: Implement apply logic
                                  print('Apply for ${bursary.name}');
                                },
                                onViewDetailsPressed: () {
                                  // TODO: Show bursary details modal
                                  print('View details for ${bursary.name}');
                                },
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text('No bursaries available at the moment.'));
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

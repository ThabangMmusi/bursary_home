import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:student_app/features/auth/bloc/auth_bloc.dart';
import 'package:student_app/features/dashboard/bloc/bursary_bloc.dart';
import 'package:student_app/features/dashboard/views/bursary_details_page.dart';

import 'package:bursary_home_ui/bursary_home_ui.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BursaryBloc, BursaryState>(
      builder: (context, bursaryState) {
        // Debugging prints
        print('Dashboard - totalEligibleBursariesCount: ${bursaryState.totalEligibleBursariesCount}');
        print('Dashboard - bursaries.length: ${bursaryState.bursaries.length}');

        final userGpa = context.select((AuthBloc bloc) => bloc.state.user.gpa);

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    DashboardHeaderWidget(
                      userName: context.select(
                        (AuthBloc bloc) => bloc.state.user.name ?? 'User',
                      ),
                      currentDate: DateFormat(
                        'EEEE, d MMMM y',
                      ).format(DateTime.now()),
                      userStatus: context.select(
                        (AuthBloc bloc) =>
                            bloc.state.user.hasCompletedProfile
                                ? UserStatus.verified
                                : UserStatus.unverified,
                      ),
                      bursariesAvailableCount:
                          bursaryState.totalEligibleBursariesCount,
                      bursariesDisplayedCount: bursaryState.bursaries.length,
                      headerImagePath: 'assets/images/school_student.png',
                    ),
                    const SizedBox(height: 16.0), // Spacing after header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Bursaries',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: AppColors.textDark),
                        ),
                        if (bursaryState.totalEligibleBursariesCount >
                            bursaryState.bursaries.length)
                          TextButton(
                            key: const ValueKey('see_all_button'), // Added key
                            onPressed: () {
                              context.go(
                                '/bursaries',
                              ); // Navigate to bursary list screen
                            },
                            child: Text(
                              'See all',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16.0), // Spacing before grid
                  ],
                ),
              ),
            ),
            if (bursaryState.status == BursaryStatus.loading)
              const SliverFillRemaining(
                key: ValueKey('loading'),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (bursaryState.status == BursaryStatus.error)
              SliverFillRemaining(
                key: ValueKey('error'),
                child: Center(
                  child: Text('Error: ${bursaryState.errorMessage}'),
                ),
              )
            else if (bursaryState.status == BursaryStatus.loaded &&
                bursaryState.bursaries.isNotEmpty)
              if (userGpa == null)
                const SliverFillRemaining(
                  key: ValueKey('gpa_null'),
                  child: Center(
                    child: Text(
                      'Your GPA is not set. Please update your profile to see relevant bursaries.',
                    ),
                  ),
                )
              else
                SliverPadding(
                  key: ValueKey('bursary_grid'),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300, // minmax(280px, 1fr)
                          childAspectRatio: 1.0, // Adjust as needed
                          crossAxisSpacing: 24.0, // 1.5rem
                          mainAxisSpacing: 24.0, // 1.5rem
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final bursary = bursaryState.bursaries[index];
                      return BursaryCard(
                        title: bursary.name,
                        provider:
                            bursary.company_id.isNotEmpty
                                ? bursary.company_id
                                : 'N/A',
                        deadline: DateFormat(
                          'd MMM y',
                        ).format(bursary.deadline),
                        field: bursary.field,
                        userGpa: userGpa,
                        requiredGpa: bursary.gpa,
                        onApplyPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BursaryDetailsPage(bursary: bursary);
                            },
                          );
                        },
                        onViewDetailsPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BursaryDetailsPage(bursary: bursary);
                            },
                          );
                        },
                      );
                    }, childCount: bursaryState.bursaries.length),
                  ),
                )
            else
              const SliverFillRemaining(
                key: ValueKey('no_bursaries_available'),
                child: Center(
                  child: Text('No bursaries available at the moment.'),
                ),
              ),
          ],
        );
      },
    );
  }
}
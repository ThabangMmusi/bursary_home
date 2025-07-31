import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:student_app/features/applications/bloc/applications_bloc.dart';
import 'package:intl/intl.dart';
import 'package:student_app/features/auth/bloc/auth_bloc.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ApplicationsBloc>().add(const LoadApplications());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Applications',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.textDark),
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
                  final userGpa = context.watch<AuthBloc>().state.user.gpa ?? 0.0;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 24.0,
                          mainAxisSpacing: 24.0,
                        ),
                    itemCount: state.applications.length,
                    itemBuilder: (context, index) {
                      final application = state.applications[index];
                      // You might need to fetch bursary details for each application
                      // or pass them along with the application data.
                      return BursaryCard(
                        title: application.bursary!.name,
                        provider: application.bursary!.company_id,
                        deadline: DateFormat(
                          'd MMM y',
                        ).format(application.appliedDate),
                        field: application.bursary!.field,
                        userGpa: userGpa,
                        requiredGpa: application.bursary!.gpa,
                        status: application.status,
                        type: BursaryCardType.application,
                        // You can add specific actions for applications here
                        onApplyPressed: () {},
                        onViewDetailsPressed: () {
                          // TODO: Show application details modal
                          print(
                            'View application details for ${application.id}',
                          );
                        },
                        onCancelPressed: () {
                          context.read<ApplicationsBloc>().add(
                                CancelApplication(application),
                              );
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
    );
  }
}

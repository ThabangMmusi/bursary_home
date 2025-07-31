import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:student_app/features/dashboard/bloc/bursary_bloc.dart';
import 'package:intl/intl.dart';
import 'package:student_app/features/auth/bloc/auth_bloc.dart';

class BursariesPage extends StatefulWidget {
  const BursariesPage({super.key});

  @override
  State<BursariesPage> createState() => _BursariesPageState();
}

class _BursariesPageState extends State<BursariesPage> {
  @override
  void initState() {
    super.initState();
    context.read<BursaryBloc>().add(LoadStudentBursaries());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Bursaries',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.textDark),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: BlocBuilder<BursaryBloc, BursaryState>(
              builder: (context, state) {
                if (state.status == BursaryStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == BursaryStatus.error) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                } else if (state.status == BursaryStatus.loaded &&
                    state.allBursaries.isNotEmpty) {
                  final userGpa = context.watch<AuthBloc>().state.user.gpa ?? 0.0;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 24.0,
                          mainAxisSpacing: 24.0,
                        ),
                    itemCount: state.allBursaries.length,
                    itemBuilder: (context, index) {
                      final bursary = state.allBursaries[index];
                      return BursaryCard(
                        title: bursary.name,
                        provider: bursary.company_id,
                        deadline: DateFormat('d MMM y').format(bursary.deadline),
                        field: bursary.field,
                        userGpa: userGpa,
                        requiredGpa: bursary.gpa,
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
                  return const Center(child: Text('No bursaries found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
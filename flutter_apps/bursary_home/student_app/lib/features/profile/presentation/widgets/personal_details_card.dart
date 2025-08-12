import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/features/auth/bloc/app_bloc.dart';
import 'package:student_app/features/profile/bloc/complete_profile_bloc.dart';

class PersonalDetailsCard extends StatelessWidget {
  const PersonalDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AppBloc>().state;
    return BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
      builder: (context, state) {
        if (state.name.isEmpty) {
          // If name is empty, use the authState user details

          context.read<CompleteProfileBloc>().add(
            NameChanged(authState.user.name!),
          );
          context.read<CompleteProfileBloc>().add(
            SurnameChanged(authState.user.surname!),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const FormSectionHeader(
            //   title: 'Personal Details',
            //   icon: Icons.person,
            // ),
            // const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StyledTextInput(
                    initialValue: state.name,
                    onChanged:
                        (value) => context.read<CompleteProfileBloc>().add(
                          NameChanged(value),
                        ),
                    label: 'Name',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StyledTextInput(
                    initialValue: state.surname,
                    onChanged:
                        (value) => context.read<CompleteProfileBloc>().add(
                          SurnameChanged(value),
                        ),
                    label: 'Surname',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

import 'package:bursary_home_ui/widgets/form_section_header.dart';
import 'package:bursary_home_ui/widgets/styled_text_input.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/features/profile/bloc/complete_profile_bloc.dart';

class CompanyDetailsForm extends StatelessWidget {
  const CompanyDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const FormSectionHeader(
            //   title: 'Company Details',
            //   icon: Icons.corporate_fare,
            // ),
            StyledTextInput(
              initialValue: state.companyName,
              onChanged:
                  (value) => context.read<CompleteProfileBloc>().add(
                    CompanyNameChanged(value),
                  ),
              label: 'Company Name',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StyledTextInput(
                    initialValue: state.registrationNumber,
                    onChanged:
                        (value) => context.read<CompleteProfileBloc>().add(
                          RegistrationNumberChanged(value),
                        ),
                    label: 'Registration No',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StyledTextInput(
                    initialValue: state.taxNumber,
                    onChanged:
                        (value) => context.read<CompleteProfileBloc>().add(
                          TaxNumberChanged(value),
                        ),
                    label: 'Tax Number',
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

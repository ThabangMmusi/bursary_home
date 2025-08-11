import 'package:bursary_home_ui/widgets/form_section_header.dart';
import 'package:bursary_home_ui/widgets/styled_text_input.dart';
import 'package:flutter/material.dart';

class CompanyDetailsForm extends StatelessWidget {
  const CompanyDetailsForm({
    super.key,
    required this.companyNameController,
    required this.registrationNumberController,
    required this.taxNumberController,
  });

  final TextEditingController companyNameController;
  final TextEditingController registrationNumberController;
  final TextEditingController taxNumberController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const FormSectionHeader(
        //   title: 'Company Details',
        //   icon: Icons.corporate_fare,
        // ),
        StyledTextInput(
          controller: companyNameController,
          label: 'Company Name',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StyledTextInput(
                controller: registrationNumberController,
                label: 'Registration No',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StyledTextInput(
                controller: taxNumberController,
                label: 'Tax Number',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

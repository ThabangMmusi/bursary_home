import 'package:bursary_home_ui/widgets/buttons/primary_btn.dart';
import 'package:flutter/material.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:student_app/data/models/bursary_model.dart';
import 'package:intl/intl.dart';

class BursaryDetailsPage extends StatelessWidget {
  final Bursary bursary;

  const BursaryDetailsPage({super.key, required this.bursary});

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      title: bursary.name,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow(context, 'Provider', bursary.provider),
          _buildDetailRow(
            context,
            'Deadline',
            DateFormat('d MMMM y').format(bursary.deadline),
          ),
          _buildDetailRow(context, 'Field of Study', bursary.fieldOfStudy),
          _buildDetailRow(
            context,
            'GPA Requirement',
            '${bursary.gpaRequirement}',
          ),
          // Add more details as needed
          const SizedBox(height: 16.0),
          Text(
            'Description:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textDark),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        PrimaryBtn(
          label: 'Apply Now',
          onPressed: () {
            // TODO: Implement actual application logic
            Navigator.of(context).pop(); // Close modal
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Applying for ${bursary.name}')),
            );
          },
        ),
      ],
      onClose: () => Navigator.of(context).pop(),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

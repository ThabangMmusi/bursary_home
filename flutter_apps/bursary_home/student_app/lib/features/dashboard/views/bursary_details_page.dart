import 'package:flutter/material.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:data_layer/data_layer.dart';
import 'package:intl/intl.dart';

class BursaryDetailsPage extends StatefulWidget {
  final Bursary bursary;

  const BursaryDetailsPage({super.key, required this.bursary});

  @override
  State<BursaryDetailsPage> createState() => _BursaryDetailsPageState();
}

class _BursaryDetailsPageState extends State<BursaryDetailsPage> {
  String _companyName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchCompanyName();
  }

  Future<void> _fetchCompanyName() async {
    final companyRepository = CompanyRepository();
    final name = await companyRepository.getCompanyName(
      widget.bursary.company_id,
    );
    setState(() {
      _companyName = name ?? 'Unknown Provider';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      title: widget.bursary.name,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDetailRow(context, 'Provider', _companyName),
          _buildDetailRow(
            context,
            'Deadline',
            DateFormat('d MMMM y').format(widget.bursary.deadline),
          ),
          _buildDetailRow(context, 'Field of Study', widget.bursary.field),
          _buildDetailRow(context, 'GPA Requirement', '${widget.bursary.gpa}'),
          // _buildDetailRow(context, 'Academic Level', bursary.academicLevel),
          // _buildDetailRow(context, 'Amount', 'R${bursary.amount}'),
          // Add more details as needed
          const SizedBox(height: 16.0),
          Text(
            'Description:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.textDark),
          ),
          const SizedBox(height: 8.0),
          // Text(
          //   bursary.description,
          //   style: Theme.of(context).textTheme.bodyMedium,
          // ),
        ],
      ),
      actions: [
        PrimaryBtn(
          label: 'Apply Now',
          onPressed: () {
            // TODO: Implement actual application logic
            Navigator.of(context).pop(); // Close modal
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Applying for ${widget.bursary.name}')),
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

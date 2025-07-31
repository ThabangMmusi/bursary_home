import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/features/profile/presentation/widgets/subject_entry_widget.dart';
import 'package:student_app/features/profile/bloc/complete_profile_bloc.dart';

class AcademicDetailsForm extends StatefulWidget {
  const AcademicDetailsForm({super.key});

  @override
  State<AcademicDetailsForm> createState() => _AcademicDetailsFormState();
}

class _AcademicDetailsFormState extends State<AcademicDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: state.qualificationName,
              onChanged: (value) => context.read<CompleteProfileBloc>().add(QualificationNameChanged(value)),
              decoration: const InputDecoration(
                labelText: 'Qualification Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Subjects',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...state.subjects.asMap().entries.map((entry) {
              int index = entry.key;
              return SubjectEntryWidget(
                index: index,
                subject: entry.value,
                onRemove: (idx) => context.read<CompleteProfileBloc>().add(SubjectRemoved(idx)),
                onSubjectNameChanged: (name) => context.read<CompleteProfileBloc>().add(SubjectNameChanged(index, name)),
                onSubjectMarksChanged: (marks) => context.read<CompleteProfileBloc>().add(SubjectMarksChanged(index, marks)),
              );
            }).toList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<CompleteProfileBloc>().add(SubjectAdded()),
              child: const Text('Add Subject'),
            ),
          ],
        );
      },
    );
  }
}
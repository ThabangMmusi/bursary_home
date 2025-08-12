import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/features/auth/bloc/app_bloc.dart';
import 'package:bursary_home_ui/widgets/form_section_header.dart';
import 'package:student_app/features/profile/bloc/complete_profile_bloc.dart';

class PersonalDetailsCard extends StatefulWidget {
  const PersonalDetailsCard({super.key});

  @override
  State<PersonalDetailsCard> createState() => _PersonalDetailsCardState();
}

class _PersonalDetailsCardState extends State<PersonalDetailsCard> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AppBloc>().state;
    _nameController = TextEditingController(text: authState.user.name ?? '');
    _surnameController = TextEditingController(
      text: authState.user.surname ?? '',
    );

    // Initialize CompleteProfileBloc state with current user data
    context.read<CompleteProfileBloc>().add(
      NameChanged(authState.user.name ?? ''),
    );
    context.read<CompleteProfileBloc>().add(
      SurnameChanged(authState.user.surname ?? ''),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormSectionHeader(
            title: 'Personal Details',
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  onChanged:
                      (value) => context.read<CompleteProfileBloc>().add(
                        NameChanged(value),
                      ),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _surnameController,
                  onChanged:
                      (value) => context.read<CompleteProfileBloc>().add(
                        SurnameChanged(value),
                      ),
                  decoration: const InputDecoration(
                    labelText: 'Surname',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

import 'package:bursary_home_ui/widgets/buttons/primary_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import 'package:student_app/features/profile/bloc/profile_bloc.dart';
import 'package:student_app/features/profile/bloc/document_upload_bloc.dart';
import 'package:student_app/data/models/profile_model.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final TextEditingController _studentNumberController =
      TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _studyProgramController = TextEditingController();
  final TextEditingController _academicYearController = TextEditingController();
  final TextEditingController _averageGradeController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  String? _matricResultsFileName;
  PlatformFile? _matricResultsFile;

  String? _idDocumentFileName;
  PlatformFile? _idDocumentFile;

  Map<String, dynamic>? _extractedData; // New state variable

  @override
  void initState() {
    super.initState();
    // Load existing profile data if available
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  void dispose() {
    _studentNumberController.dispose();
    _institutionController.dispose();
    _studyProgramController.dispose();
    _academicYearController.dispose();
    _averageGradeController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickMatricResults() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _matricResultsFile = result.files.single;
        _matricResultsFileName = result.files.single.name;
      });
    }
  }

  Future<void> _pickIdDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _idDocumentFile = result.files.single;
        _idDocumentFileName = result.files.single.name;
      });
    }
  }

  void _submitProfile() {
    final user = fb_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated.')));
      return;
    }

    if (_matricResultsFile == null || _idDocumentFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both your matric results and ID document.')),
      );
      return;
    }

    // Trigger document uploads
    context.read<DocumentUploadBloc>().add(
      UploadDocument(userId: user.uid, file: _matricResultsFile!.bytes!, documentType: 'matric_results'),
    );
    context.read<DocumentUploadBloc>().add(
      UploadDocument(userId: user.uid, file: _idDocumentFile!.bytes!, documentType: 'id_document'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state.status == ProfileStatus.loaded &&
                  state.profile != null) {
                _studentNumberController.text =
                    state.profile!.extractedData?['student_number'] ?? '';
                _institutionController.text =
                    state.profile!.extractedData?['institution'] ?? '';
                _studyProgramController.text =
                    state.profile!.extractedData?['study_program'] ?? '';
                _academicYearController.text =
                    state.profile!.extractedData?['academic_year'] ?? '';
                _averageGradeController.text =
                    state.profile!.extractedData?['average_grade'] ?? '';
                _contactNumberController.text =
                    state.profile!.extractedData?['contact_number'] ?? '';

                if (state.profile!.matricResultsDocUrl != null) {
                  _matricResultsFileName =
                      'Uploaded Document'; // Or parse from URL
                }
                setState(() {});
              } else if (state.status == ProfileStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? 'Error loading profile',
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<DocumentUploadBloc, DocumentUploadState>(
            listener: (context, state) {
              if (state.status == DocumentUploadStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document uploaded and processed!'),
                  ),
                );
                
                setState(() {
                  _extractedData = state.extractedData;
                });
              } else if (state.status == DocumentUploadStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ?? 'Document upload failed',
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: AuthFormContainer(
              width: 520.0, // profile-form width
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LogoComponent(
                    direction: LogoDirection.horizontal,
                  ), // Adjust as needed
                  const SizedBox(height: 24.0),
                  Text(
                    'Complete Your Profile',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Please upload your highest qualification and ID document.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  FormSectionHeader(
                    title: 'Required Documents',
                    icon: Icons.upload_file,
                  ),
                  FileUploadWidget(
                    label: 'Matric Results / Transcript / Certificate',
                    hint: '(PDF, max 5MB)',
                    icon: Icons.picture_as_pdf,
                    isRequired: true,
                    isFileSelected: _matricResultsFile != null,
                    selectedFileName: _matricResultsFileName,
                    onPressed: _pickMatricResults,
                  ),
                  // VSpace.sms,
                  FileUploadWidget(
                    label: 'ID Document/smart card',
                    hint: '(PDF, JPG, PNG, max 5MB)',
                    icon: Icons.picture_as_pdf,
                    isRequired: true,
                    isFileSelected: _idDocumentFile != null,
                    selectedFileName: _idDocumentFileName,
                    onPressed: _pickIdDocument,
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryBtn(
                      label: 'Save Profile',
                      icon: Icons.save,
                      onPressed: _submitProfile,
                    ),
                  ),
                  Visibility(
                    visible: _extractedData != null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32.0),
                        FormSectionHeader(
                          title: 'Extracted Information Preview',
                          icon: Icons.info_outline,
                        ),
                        const SizedBox(height: 16.0),
                        if (_extractedData != null && _extractedData!['name'] != null)
                          Text('Name: ${_extractedData!['name']}'),
                        if (_extractedData != null && _extractedData!['surname'] != null)
                          Text('Surname: ${_extractedData!['surname']}'),
                        if (_extractedData != null && _extractedData!['gpa'] != null)
                          Text('GPA: ${_extractedData!['gpa']}'),
                        if (_extractedData != null && _extractedData!['subjects'] != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8.0),
                              Text(
                                'Subjects/Modules:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              ...(_extractedData!['subjects'] as List).map((subject) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                                  child: Text(
                                    '- ${subject['name']}: Marks ${subject['marks']}, Level ${subject['level']}, Passed: ${subject['passed'] ? 'Yes' : 'No'}',
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

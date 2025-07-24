import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_app/data/repositories/profile_repository.dart';

part 'document_upload_event.dart';
part 'document_upload_state.dart';

class DocumentUploadBloc extends Bloc<DocumentUploadEvent, DocumentUploadState> {
  final ProfileRepository _profileRepository;

  DocumentUploadBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(DocumentUploadState.initial()) {
    on<UploadDocument>(_onUploadDocument);
  }

  Future<void> _onUploadDocument(
      UploadDocument event, Emitter<DocumentUploadState> emit) async {
    final String documentType = event.documentType;
    emit(state.copyWith(status: DocumentUploadStatus.uploading));
    try {
      // Simulate upload time
      await Future.delayed(const Duration(seconds: 2));
      final downloadUrl = await _profileRepository.uploadDocument(
          event.userId, event.file, documentType);

      // Simulate AI processing time
      await Future.delayed(const Duration(seconds: 2));
      Map<String, dynamic> extractedData = {};
      if (documentType == 'matric_results') {
        extractedData = {
          'name': 'Simulated Student Name',
          'surname': 'Simulated Student Surname',
          'subjects': [
            {'name': 'Mathematics', 'marks': 85, 'level': 7, 'passed': true},
            {'name': 'Physics', 'marks': 70, 'level': 6, 'passed': true},
            {'name': 'English', 'marks': 60, 'level': 5, 'passed': true},
          ],
          'gpa': 3.5, // Simulated GPA
        };
      } else if (documentType == 'id_document') {
        extractedData = {
          'name': 'Simulated ID Name',
          'surname': 'Simulated ID Surname',
        };
      }

      emit(state.copyWith(
        status: DocumentUploadStatus.success,
        downloadUrl: downloadUrl,
        extractedData: extractedData,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: DocumentUploadStatus.failure,
          errorMessage: e.toString()));
    }
  }
}

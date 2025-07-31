import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_layer/data_layer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart'; // For Uint8List

part 'document_upload_event.dart';
part 'document_upload_state.dart';

class DocumentUploadBloc extends Bloc<DocumentUploadEvent, DocumentUploadState> {
  final ProfileRepository _profileRepository;
  final FirebaseStorage _firebaseStorage;
  final FirebaseFunctions _firebaseFunctions;

  DocumentUploadBloc({
    required ProfileRepository profileRepository,
    FirebaseStorage? firebaseStorage,
    FirebaseFunctions? firebaseFunctions,
  })
      : _profileRepository = profileRepository,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firebaseFunctions = firebaseFunctions ?? FirebaseFunctions.instance,
        super(DocumentUploadState.initial()) {
    on<UploadDocument>(_onUploadDocument);
  }

  Future<void> _onUploadDocument(
      UploadDocument event, Emitter<DocumentUploadState> emit) async {
    emit(state.copyWith(status: DocumentUploadStatus.uploading));
    try {
      // 1. Upload file to Firebase Storage
      final String storagePath = 'users/${event.userId}/documents/${event.documentType}_${DateTime.now().millisecondsSinceEpoch}.${event.fileExtension}'; // Dynamic path
      final Reference ref = _firebaseStorage.ref().child(storagePath);

      UploadTask uploadTask;
      if (event.file is Uint8List) {
        uploadTask = ref.putData(event.file as Uint8List);
      } else {
        // Handle other file types if necessary, e.g., ref.putFile(event.file as File);
        throw Exception('Unsupported file type for upload.');
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // 2. Call the Cloud Function
      final HttpsCallable callable = _firebaseFunctions.httpsCallable('processDocumentExtraction');
      final result = await callable.call({
        'userId': event.userId,
        'documentType': event.documentType,
        'documentUrl': downloadUrl,
      });

      // The Cloud Function now handles Firestore updates directly.
      // The client just needs to know if the function call was successful.
      if (result.data['status'] == 'success') {
        emit(state.copyWith(
          status: DocumentUploadStatus.success,
          downloadUrl: downloadUrl,
          extractedData: Map<String, dynamic>.from(result.data['extractedData'] as Map),
        ));
      } else {
        emit(state.copyWith(
          status: DocumentUploadStatus.failure,
          errorMessage: result.data['message'] ?? 'Cloud Function failed.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: DocumentUploadStatus.failure,
          errorMessage: e.toString()));
    }
  }
}

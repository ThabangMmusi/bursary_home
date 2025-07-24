part of 'document_upload_bloc.dart';

abstract class DocumentUploadEvent extends Equatable {
  const DocumentUploadEvent();

  @override
  List<Object> get props => [];
}

class UploadDocument extends DocumentUploadEvent {
  final String userId;
  final dynamic file; // Can be File or List<int> (for web)
  final String documentType;

  const UploadDocument({required this.userId, required this.file, required this.documentType});

  @override
  List<Object> get props => [userId, file, documentType];
}

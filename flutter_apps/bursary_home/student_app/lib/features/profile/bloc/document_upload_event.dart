part of 'document_upload_bloc.dart';

abstract class DocumentUploadEvent extends Equatable {
  const DocumentUploadEvent();

  @override
  List<Object> get props => [];
}

class UploadDocument extends DocumentUploadEvent {
  final dynamic file;
  final String userId;
  final String documentType;
  final String fileExtension;

  const UploadDocument({
    required this.file,
    required this.userId,
    required this.documentType,
    required this.fileExtension,
  });

  @override
  List<Object> get props => [file, userId, documentType, fileExtension];
}

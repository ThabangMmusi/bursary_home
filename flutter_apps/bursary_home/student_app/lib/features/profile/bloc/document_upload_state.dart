part of 'document_upload_bloc.dart';

enum DocumentUploadStatus { initial, uploading, success, failure }

class DocumentUploadState extends Equatable {
  final DocumentUploadStatus status;
  final String? downloadUrl;
  final Map<String, dynamic>? extractedData;
  final String? errorMessage;

  const DocumentUploadState({
    required this.status,
    this.downloadUrl,
    this.extractedData,
    this.errorMessage,
  });

  factory DocumentUploadState.initial() {
    return const DocumentUploadState(status: DocumentUploadStatus.initial);
  }

  DocumentUploadState copyWith({
    DocumentUploadStatus? status,
    String? downloadUrl,
    Map<String, dynamic>? extractedData,
    String? errorMessage,
  }) {
    return DocumentUploadState(
      status: status ?? this.status,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      extractedData: extractedData ?? this.extractedData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, downloadUrl, extractedData, errorMessage];
}

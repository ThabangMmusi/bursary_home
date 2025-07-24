import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StudentProfile extends Equatable {
  final String? id;
  final String userId;
  final String status;
  final String? matricResultsDocUrl;
  final Map<String, dynamic>? extractedData;

  const StudentProfile({
    this.id,
    required this.userId,
    this.status = 'incomplete',
    this.matricResultsDocUrl,
    this.extractedData,
  });

  StudentProfile copyWith({
    String? id,
    String? userId,
    String? status,
    String? matricResultsDocUrl,
    Map<String, dynamic>? extractedData,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      matricResultsDocUrl: matricResultsDocUrl ?? this.matricResultsDocUrl,
      extractedData: extractedData ?? this.extractedData,
    );
  }

  static StudentProfile fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StudentProfile(
      id: doc.id,
      userId: data['userId'] as String,
      status: data['status'] as String,
      matricResultsDocUrl: data['matricResultsDocUrl'] as String?,
      extractedData: data['extractedData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'status': status,
      'matricResultsDocUrl': matricResultsDocUrl,
      'extractedData': extractedData,
    };
  }

  @override
  List<Object?> get props =>
      [id, userId, status, matricResultsDocUrl, extractedData];
}

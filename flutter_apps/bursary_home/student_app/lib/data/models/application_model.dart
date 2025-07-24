import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ApplicationStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

class Application extends Equatable {
  final String id;
  final String bursaryId;
  final String userId;
  final ApplicationStatus status;
  final double progress;
  final DateTime appliedDate;

  const Application({
    required this.id,
    required this.bursaryId,
    required this.userId,
    this.status = ApplicationStatus.pending,
    this.progress = 0.0,
    required this.appliedDate,
  });

  factory Application.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Application(
      id: doc.id,
      bursaryId: data['bursaryId'] as String,
      userId: data['userId'] as String,
      status: ApplicationStatus.values.firstWhere(
          (e) => e.toString() == 'ApplicationStatus.' + data['status']),
      progress: (data['progress'] as num).toDouble(),
      appliedDate: (data['appliedDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'bursaryId': bursaryId,
      'userId': userId,
      'status': status.name,
      'progress': progress,
      'appliedDate': Timestamp.fromDate(appliedDate),
    };
  }

  @override
  List<Object> get props =>
      [id, bursaryId, userId, status, progress, appliedDate];
}

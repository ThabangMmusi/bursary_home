import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'bursary_model.dart';

enum ApplicationStatus { pending, approved, rejected, cancelled, processing }

class Application extends Equatable {
  final String? id;
  final String bursaryId;
  final String userId;
  final ApplicationStatus status;
  final double progress;
  final DateTime appliedDate;
  final Bursary? bursary;

  const Application({
    this.id,
    required this.bursaryId,
    required this.userId,
    this.status = ApplicationStatus.pending,
    this.progress = 0.0,
    required this.appliedDate,
    this.bursary,
  });

  factory Application.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Application(
      id: doc.id,
      bursaryId: data['bursaryId'] as String,
      userId: data['userId'] as String,
      status: ApplicationStatus.values.firstWhere(
        (e) => e.toString() == 'ApplicationStatus.' + data['status'],
      ),
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

  Application copyWith({
    String? id,
    String? bursaryId,
    String? userId,
    ApplicationStatus? status,
    double? progress,
    DateTime? appliedDate,
    Bursary? bursary,
  }) {
    return Application(
      id: id ?? this.id,
      bursaryId: bursaryId ?? this.bursaryId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      appliedDate: appliedDate ?? this.appliedDate,
      bursary: bursary ?? this.bursary,
    );
  }

  @override
  List<Object?> get props =>
      [bursaryId, userId, status, progress, appliedDate, bursary];
}

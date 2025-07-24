import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Bursary extends Equatable {
  final String id;
  final String name;
  final String provider;
  final DateTime deadline;
  final String fieldOfStudy;
  final double gpaRequirement;

  const Bursary({
    required this.id,
    required this.name,
    required this.provider,
    required this.deadline,
    required this.fieldOfStudy,
    required this.gpaRequirement,
  });

  factory Bursary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Bursary(
      id: doc.id,
      name: data['name'] as String,
      provider: data['provider'] as String,
      deadline: (data['deadline'] as Timestamp).toDate(),
      fieldOfStudy: data['fieldOfStudy'] as String,
      gpaRequirement: (data['gpaRequirement'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'provider': provider,
      'deadline': Timestamp.fromDate(deadline),
      'fieldOfStudy': fieldOfStudy,
      'gpaRequirement': gpaRequirement,
    };
  }

  @override
  List<Object> get props =>
      [id, name, provider, deadline, fieldOfStudy, gpaRequirement];
}

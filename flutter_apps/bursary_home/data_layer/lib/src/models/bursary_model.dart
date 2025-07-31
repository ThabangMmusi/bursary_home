import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Bursary extends Equatable {
  final String id;
  final String name;
  final String company_id;
  final DateTime deadline;
  final String field;
  final double gpa;

  const Bursary({
    required this.id,
    required this.name,
    required this.company_id,
    required this.deadline,
    required this.field,
    required this.gpa,
  });

  factory Bursary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    print('Bursary.fromFirestore: Raw data for doc ${doc.id}: $data');
    final name = data['name'] as String? ?? '';
    final companyId = data['company_id'] as String? ?? '';
    final deadline = (data['deadline'] as Timestamp? ?? Timestamp.now()).toDate();
    final field = data['field'] as String? ?? '';
    final gpa = (data['gpa'] as num?)?.toDouble();

    print('Bursary.fromFirestore: Parsed values - name: $name, company_id: $companyId, deadline: $deadline, field: $field, gpa: $gpa');

    return Bursary(
      id: doc.id,
      name: name,
      company_id: companyId,
      deadline: deadline,
      field: field,
      gpa: gpa ?? 0.0, // Provide a default for gpa if null
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'company_id': company_id,
      'deadline': Timestamp.fromDate(deadline),
      'field': field,
      'gpa': gpa,
    };
  }

  @override
  List<Object> get props =>
      [id, name, company_id, deadline, field, gpa];
}

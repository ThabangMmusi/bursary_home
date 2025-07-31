import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_layer/src/models/bursary_model.dart';
import 'package:data_layer/src/models/application_model.dart';

class BursaryRepository {
  final FirebaseFirestore _firestore;

  BursaryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<String>> _getExcludedBursaryIds(String userId) async {
    final excludedStatuses = [
      ApplicationStatus.pending.name,
      ApplicationStatus.rejected.name,
      ApplicationStatus.processing.name,
    ];

    final querySnapshot = await _firestore
        .collection('applications')
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: excludedStatuses)
        .get();

    return querySnapshot.docs.map((doc) => doc['bursaryId'] as String).toList();
  }

  Stream<List<Bursary>> loadStudentDashboardBursaries(
      String userId, double userGpa) async* {
    final excludedBursaryIds = await _getExcludedBursaryIds(userId);

    Query<Map<String, dynamic>> query = _firestore
        .collection('bursaries')
        .where('gpa', isLessThanOrEqualTo: userGpa);

    if (excludedBursaryIds.isNotEmpty) {
      query = query.where(FieldPath.documentId, whereNotIn: excludedBursaryIds);
    }

    yield* query.limit(4).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Bursary.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Bursary>> loadStudentBursaries(
      String userId, double userGpa, {
      DocumentSnapshot? lastDocument,
      int pageSize = 10,
  }) async* {
    final excludedBursaryIds = await _getExcludedBursaryIds(userId);

    Query<Map<String, dynamic>> query = _firestore
        .collection('bursaries')
        .where('gpa', isLessThanOrEqualTo: userGpa);

    if (excludedBursaryIds.isNotEmpty) {
      query = query.where(FieldPath.documentId, whereNotIn: excludedBursaryIds);
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    yield* query.limit(pageSize).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Bursary.fromFirestore(doc)).toList();
    });
  }

  Future<int> getEligibleBursariesCount(String userId, double userGpa) async {
    final excludedBursaryIds = await _getExcludedBursaryIds(userId);

    Query<Map<String, dynamic>> query = _firestore
        .collection('bursaries')
        .where('gpa', isLessThanOrEqualTo: userGpa);

    if (excludedBursaryIds.isNotEmpty) {
      query = query.where(FieldPath.documentId, whereNotIn: excludedBursaryIds);
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs.length;
  }

  Future<Bursary?> getBursaryById(String id) async {
    try {
      final doc = await _firestore.collection('bursaries').doc(id).get();
      if (doc.exists) {
        return Bursary.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting bursary: $e');
      rethrow;
    }
  }
}
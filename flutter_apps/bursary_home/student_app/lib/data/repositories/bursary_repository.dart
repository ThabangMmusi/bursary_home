import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_app/data/models/bursary_model.dart';

class BursaryRepository {
  final FirebaseFirestore _firestore;

  BursaryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Bursary>> getBursaries() {
    return _firestore.collection('bursaries').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Bursary.fromFirestore(doc)).toList();
    });
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

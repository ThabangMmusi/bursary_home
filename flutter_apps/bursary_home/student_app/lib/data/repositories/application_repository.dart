import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_app/data/models/application_model.dart';

class ApplicationRepository {
  final FirebaseFirestore _firestore;

  ApplicationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Application>> getApplications(String userId) {
    return _firestore
        .collection('applications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Application.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> createApplication(Application application) async {
    try {
      await _firestore
          .collection('applications')
          .add(application.toFirestore());
    } catch (e) {
      print('Error creating application: $e');
      rethrow;
    }
  }

  Future<void> updateApplication(Application application) async {
    try {
      await _firestore
          .collection('applications')
          .doc(application.id)
          .update(application.toFirestore());
    } catch (e) {
      print('Error updating application: $e');
      rethrow;
    }
  }
}
